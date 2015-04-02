//
//  XWMoreBtn.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "IWMoreBtn.h"

@implementation IWMoreBtn

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeBottom;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


#pragma mark - 覆盖父类的2个方法
#pragma mark 设置按钮标题的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat halfH = contentRect.size.height * 0.5;
    return CGRectMake(0, halfH, contentRect.size.width, 18);
}
#pragma mark 设置按钮图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * 0.5 - 2);
}

@end
