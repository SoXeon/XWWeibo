//
//  XWEmotionToobar.h
//  XWeiBo
//
//  Created by DP on 15/4/7.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWEmotionToobar;

typedef enum {
    XWEmotionTypeRecent,
    XWEmotionTypeDefault,
    XWEmotionTypeEmoji,
    XWEmotionTypeLXH
}XWemotionType;

@protocol XWEmotionToobarDelegate <NSObject>

- (void)emotionToolbar:(XWEmotionToobar *)toolbar didSelectedButton:(XWemotionType)emotionType;

@end

@interface XWEmotionToobar : UIView
@property (nonatomic, weak) id<XWEmotionToobarDelegate> delegate;
@end
