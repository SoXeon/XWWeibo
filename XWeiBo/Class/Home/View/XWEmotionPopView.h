//
//  XWEmotionPopView.h
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWEmotionView;

@interface XWEmotionPopView : UIView

+ (instancetype)popView;
- (void)showFromEmotionView:(XWEmotionView *)fromEmotionView;
- (void)dismiss;

@end
