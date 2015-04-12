//
//  XWEmotionTool.h
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  XWEmotion;
@interface XWEmotionTool : NSObject

+ (NSArray *)defaultEmotions;

+ (NSArray *)emojiEmotions;

+ (NSArray *)lxhEmotions;

+ (NSArray *)recentEmotions;

+ (void)addRecentEmotion:(XWEmotion *)emotion;
@end
