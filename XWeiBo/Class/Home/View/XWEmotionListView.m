//
//  XWEmotionListView.m
//  XWeiBo
//
//  Created by DP on 15/4/6.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#define kXWEmotionMaxRows 3
#define kXWEmotionMaxCols 7
#define kXWEmotionMaxCountPerPage 20

#import "XWEmotionListView.h"

@interface XWEmotionListView()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation XWEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIScrollView *scrollView = [[UIScrollView alloc] init];
        self.scrollView = scrollView;
        self.scrollView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.scrollView];
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        self.pageControl.backgroundColor = [UIColor blueColor];
        self.pageControl = pageControl;
        [self addSubview:self.pageControl];
        
    }
    return self;
}


- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    self.pageControl.numberOfPages = (_emotions.count + kXWEmotionMaxCountPerPage - 1) / kXWEmotionMaxCountPerPage;
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
    
    
}

@end
