//
//  XWEmotionTextView.m
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionTextView.h"
#import "XWEmotion.h"

@implementation XWEmotionTextView
- (void)appendEmotion:(XWEmotion *)emotion
{
    if (emotion.emoji) {
        [self insertText:emotion.emoji];
    } else {
        [self insertText:emotion.chs];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
