//
//  XWImageListView.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#define kCount 9

#define kOneW 85
#define kOneH 85

#define kMultiW 80
#define kMultiH 80

#define kMargin 10

#import "XWImageListView.h"
#import "UIImageView+WebCache.h"
#import "XWImageItemView.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

const int IWPhotoMargin = 5;

@implementation XWImageListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 先把有可能显示的控件都加进去
        for (int i = 0; i<kCount; i++) {
            XWImageItemView *imageView = [[XWImageItemView alloc] init];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
            [self addSubview:imageView];
        }
    }
    return self;
}

#pragma mark 点击了图片
- (void)imageTap:(UITapGestureRecognizer *)tap
{
    int count = _imageUrls.count;
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSString *url = _imageUrls[i][@"thumbnail_pic"];
        url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url];
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag;
    browser.photos = photos;
    [browser show];
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    // 4
    _imageUrls = imageUrls;
    int count = (int)imageUrls.count;
    
    for (int i = 0; i<kCount; i++) {
        // 1.取出对应位置的子控件
        XWImageItemView *child = self.subviews[i];
        
        // 2.不要显示图片
        if (i >= count) {
            child.hidden = YES;
            continue;
        }
        
        // 需要显示图片
        child.hidden = NO;
        
        // 3.设置图片
        child.url = imageUrls[i][@"thumbnail_pic"];
        
        // 4.设置frame
        if (count == 1) { // 1张
            child.contentMode = UIViewContentModeScaleAspectFit;
            child.frame = CGRectMake(0, 0, kOneW, kOneH);
            continue;
        }
        
        // 超出边界的减掉
        child.clipsToBounds = YES;
        child.contentMode = UIViewContentModeScaleAspectFill;
        
        int temp = (count == 4) ? 2 : 3;
        CGFloat row = i/temp; // 行号
        CGFloat column = i%temp; // 列号
        CGFloat x = (kMultiW + kMargin) * column;
        CGFloat y = (kMultiH + kMargin) * row;
        child.frame = CGRectMake(x, y, kMultiW, kMultiH);
    }
}

+ (CGSize)imageListSizeWithCount:(int)count
{
    // 1.只有1张图片
    if (count == 1) {
        return CGSizeMake(kOneW, kOneH);
    }
    
    // 2.至少2张图片
    CGFloat countRow = (count == 4) ? 2 : 3;
    // 总行数
    int rows = (count + countRow - 1) / countRow;
    // 总列数
    int columns = (count >= 3) ? 3 : 2;
    
    CGFloat width = columns * kMultiW + (columns - 1) * kMargin;
    CGFloat height = rows * kMultiH + (rows - 1) * kMargin;
    return CGSizeMake(width, height);
}

@end
