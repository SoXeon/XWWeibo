//
//  XWEmotionListView.m
//  XWeiBo
//
//  Created by DP on 15/4/6.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//


#import "XWEmotionListView.h"
#import "SMPageControl.h"
#import "XWEmotionGridView.h"

@interface XWEmotionListView() <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) SMPageControl *pageControl;

@end

@implementation XWEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollEnabled = YES;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        self.scrollView = scrollView;
        [self addSubview:self.scrollView];
        
        SMPageControl *pageControl = [[SMPageControl alloc] init];
        pageControl.pageIndicatorImage = [UIImage imageWithName:@"compose_keyboard_dot_normal-1"];
        pageControl.currentPageIndicatorImage = [UIImage imageWithName:@"compose_keyboard_dot_selected-1"];
        
        self.pageControl = pageControl;
        [self addSubview:self.pageControl];
        
    }
    return self;
}


- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSInteger totalPages = (NSInteger)(emotions.count + kXWEmotionMaxCountPerPage - 1) / kXWEmotionMaxCountPerPage;
    int currentGridViewCount =  (int)self.scrollView.subviews.count;

    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = 0;
    
    for (int i = 0; i < totalPages; i++) {
        XWEmotionGridView *gridView = nil;
        if (i >= currentGridViewCount) {
            gridView = [[XWEmotionGridView alloc] init];
            [self.scrollView addSubview:gridView];
        } else {
            gridView = self.scrollView.subviews[i];
        }
        
        int loc = i * kXWEmotionMaxCountPerPage;
        int len = kXWEmotionMaxCountPerPage;
        if (loc + len > emotions.count) {
            len = (int)emotions.count - loc;
        }
        
        
        NSRange emotionRange = NSMakeRange(loc, len);
        NSArray *gridEmotions = [emotions subarrayWithRange:emotionRange];
        gridView.emotions = gridEmotions;
        gridView.hidden = NO;
    }
    
    for (int i = (int)totalPages; i < currentGridViewCount; i++) {
        XWEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.hidden = YES;
    }
    
    [self setNeedsLayout];
    
    self.scrollView.contentOffset = CGPointZero;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.y = self.height - self.pageControl.height;
    
    //scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    
    // 3.设置UIScrollView内部控件的尺寸
    int count = (int)self.pageControl.numberOfPages;
    CGFloat gridW = self.scrollView.width;
    CGFloat gridH = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(count * gridW, 0);
    for (int i = 0; i<count; i++) {
        UIView *gridView = self.scrollView.subviews[i];
        gridView.width = gridW;
        gridView.height = gridH;
        gridView.x = i * gridW;
    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}


@end
