//
//  XWEmotionGridView.m
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionGridView.h"
#import "XWEmotion.h"

@implementation XWEmotionGridView

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    //添加新数据
    int count = (int)emotions.count;
    for (int i = 0; i < count; i++) {
        UIButton *emotionView = [[UIButton alloc] init];
        emotionView.adjustsImageWhenHighlighted = NO;

        XWEmotion *emotion = emotions[i];
        
        if (emotion.code) {
            emotionView.titleLabel.font = [UIFont systemFontOfSize:32.0f];
            [emotionView setTitle:emotion.emoji forState:UIControlStateNormal];
        } else {
            NSString *imageURL = [NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png];
            [emotionView setImage:[UIImage imageWithName:imageURL] forState:UIControlStateNormal];

        }
        
         [self addSubview:emotionView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = (int)self.emotions.count;
    CGFloat leftInset = 15;
    CGFloat topInset = 15;
    CGFloat emotionViewW = (self.width - 2 * leftInset) / kXWEmotionMaxCols;
    CGFloat emotionViewH = (self.height - 0.8 * topInset) / kXWEmotionMaxRows;
    for (int i = 0; i < count; i++) {
        UIButton *emotionView = self.subviews[i];
        emotionView.x = leftInset + (i % kXWEmotionMaxCols) * emotionViewW;
        emotionView.y = topInset + (i / kXWEmotionMaxCols) * emotionViewH;
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
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
