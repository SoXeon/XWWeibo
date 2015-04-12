//
//  XWEmotionAttachment.m
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionAttachment.h"
#import "XWEmotion.h"
@implementation XWEmotionAttachment

- (void)setEmotion:(XWEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png]];
}

@end
