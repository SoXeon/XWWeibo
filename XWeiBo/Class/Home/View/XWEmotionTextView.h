//
//  XWEmotionTextView.h
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWPlaceholderTextView.h"
@class XWEmotion;
@interface XWEmotionTextView : XWPlaceholderTextView

- (void)appendEmotion:(XWEmotion *)emotion;
- (NSString *)realText;
@end
