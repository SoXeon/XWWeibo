//
//  XWEmotion.m
//  XWeiBo
//
//  Created by DP on 15/4/7.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotion.h"
#import "NSString+Emoji.h"

@implementation XWEmotion

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@ - %@", self.chs, self.png, self.code];
}

- (void)setCode:(NSString *)code
{
    _code = [code copy];
    
    self.emoji = [NSString emojiWithStringCode:code];
}

@end
