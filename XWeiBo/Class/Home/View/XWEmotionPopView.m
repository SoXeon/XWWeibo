//
//  XWEmotionPopView.m
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionPopView.h"
#import "XWEmotionView.h"


@interface XWEmotionPopView()
@property (weak, nonatomic) IBOutlet XWEmotionView *emotionView;

@end

@implementation XWEmotionPopView


+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XWEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFromEmotionView:(XWEmotionView *)fromEmotionView
{
    self.emotionView.emotion = fromEmotionView.emotion;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    CGFloat centerX = fromEmotionView.centerX;
    CGFloat centerY = fromEmotionView.centerY - self.height * 0.5;
    CGPoint center = CGPointMake(centerX, centerY);
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];
    
}

- (void)dismiss
{
    [self removeFromSuperview];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIImage imageWithName:@"emoticon_keyboard_magnifier"] drawInRect:rect];
}


@end
