//
//  XWEmotionToobar.m
//  XWeiBo
//
//  Created by DP on 15/4/7.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionToobar.h"

#define XWEmotionToolbarButtonMaxCount 4

@interface XWEmotionToobar()

@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation XWEmotionToobar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加4个按钮
        [self setupToolbarButton:@"最近" tag:XWEmotionTypeRecent];
        
        UIButton *defaultButton = [self setupToolbarButton:@"默认" tag:XWEmotionTypeDefault];
        [self setupToolbarButton:@"Emoji" tag:XWEmotionTypeEmoji];
        [self setupToolbarButton:@"浪小花" tag:XWEmotionTypeLXH];
        
        // 2.默认选中“默认”按钮
        [self toolbarButtonClick:defaultButton];


    }
    return self;
}

- (UIButton *)setupToolbarButton:(NSString *)title tag:(XWemotionType)tag
{
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = tag;
 
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(toolbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];

    [self addSubview:btn];
    
    NSUInteger count = self.subviews.count;
    
    if (count == 1) { // 第一个按钮
        [btn setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
    } else if (count == XWEmotionToolbarButtonMaxCount) { // 最后一个按钮
        [btn setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
    } else { // 中间按钮
        [btn setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    }
    
    return btn;
    
    
}

/**
 *  监听工具条按钮点击
 */
- (void)toolbarButtonClick:(UIButton *)button
{
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]) {
        [self.delegate emotionToolbar:self didSelectedButton:(int)button.tag];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.width / XWEmotionToolbarButtonMaxCount;
    CGFloat btnH = self.height;
    
    for (int i = 0; i < XWEmotionToolbarButtonMaxCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
    }
}

@end
