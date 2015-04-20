//
//  XWProfileBtn.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWProfileBtn.h"

@implementation XWProfileBtn

- (void)awakeFromNib
{
    [self setBackgroundImage:[UIImage resizedImage:@"userinfo_appsview_background_highlighted"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont fontWithName:kLTFont size:14];
}

@end
