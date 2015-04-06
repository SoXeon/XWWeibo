//
//  XWEmotionKeyboard.m
//  XWeiBo
//
//  Created by DP on 15/4/5.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionKeyboard.h"
#import "XWEmotionListView.h"

#define XWEmotionToolbarButtonMaxCount 4


@interface XWEmotionKeyboard()

@property (nonatomic, weak) XWEmotionListView *listView;
@property (nonatomic, weak) UIView *toolbar;
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation XWEmotionKeyboard


+ (instancetype)keyboard
{
    return [self new];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        XWEmotionListView *listView = [XWEmotionListView new];
        listView.backgroundColor = [UIColor yellowColor];
        [self addSubview:listView];
        self.listView = listView;
        
        UIView *toolbar = [UIView new];
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
        [self setupToolbarButton:@"最近"];
        UIButton *defaultBtn = [self setupToolbarButton:@"默认"];
        [self setupToolbarButton:@"Emoji"];
        [self setupToolbarButton:@"浪小花"];
        
        [self toolbarButtonClick:defaultBtn];
        
    }
    
    return self;
}

- (UIButton *)setupToolbarButton:(NSString *)title
{
    UIButton *btn = [UIButton new];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(toolbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolbar addSubview:btn];
    
    NSUInteger count = self.toolbar.subviews.count;
    
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
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.toolbar.width = self.width;
    self.toolbar.height = 35;
    self.toolbar.y = self.height - self.toolbar.height;
    
    self.listView.width = self.width;
    self.listView.height = self.toolbar.y;
    
    CGFloat btnW = self.toolbar.width / XWEmotionToolbarButtonMaxCount;
    CGFloat btnH = self.toolbar.height;
    
    for (int i = 0; i < XWEmotionToolbarButtonMaxCount; i++) {
        UIButton *btn = self.toolbar.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
    }
}
@end
