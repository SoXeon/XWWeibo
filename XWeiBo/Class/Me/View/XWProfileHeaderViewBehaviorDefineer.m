//
//  XWProfileHeaderViewBehaviorDefineer.m
//  XWeiBo
//
//  Created by DP on 15/4/25.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWProfileHeaderViewBehaviorDefineer.h"
#import "BLKFlexibleHeightBar.h"

@implementation XWProfileHeaderViewBehaviorDefineer


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.isCurrentlySnapping)
    {
        CGFloat progress = (scrollView.contentOffset.y+scrollView.contentInset.top) / (self.flexibleHeightBar.maximumBarHeight-self.flexibleHeightBar.minimumBarHeight);
        self.flexibleHeightBar.progress = progress;
        [self.flexibleHeightBar setNeedsLayout];
    }
}

@end
