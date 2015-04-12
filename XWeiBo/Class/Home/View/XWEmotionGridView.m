//
//  XWEmotionGridView.m
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionGridView.h"
#import "XWEmotion.h"
#import "XWEmotionView.h"
#import "XWEmotionPopView.h"
#import "XWEmotionTool.h"

@interface XWEmotionGridView()

@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, strong) NSMutableArray *emotionViews;
@property (nonatomic, strong) XWEmotionPopView *popView;
@end

@implementation XWEmotionGridView

- (XWEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [XWEmotionPopView popView];
        self.popView.backgroundColor = [UIColor clearColor];

    }
    return _popView;
}

- (NSMutableArray *)emotionViews
{
    if (!_emotionViews) {
        self.emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

- (id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        
        //手势识别
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

// 长按手势
- (void)longPress:(UILongPressGestureRecognizer *)recoginzer
{
    CGPoint point = [recoginzer locationInView:recoginzer.view];
    
    XWEmotionView *emotionView = [self emotionViewWithPoint:point];
    
    if (recoginzer.state == UIGestureRecognizerStateEnded) {
        [self.popView dismiss];
        
        [self selectedEmotion:emotionView.emotion];
    } else {
        [self.popView showFromEmotionView:emotionView];
    }
}

- (XWEmotionView *)emotionViewWithPoint:(CGPoint)point
{
    __block XWEmotionView *foundEmotionView = nil;
    [self.emotionViews enumerateObjectsUsingBlock:^(XWEmotionView *emotionView, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(emotionView.frame, point)) {
            foundEmotionView = emotionView;
            *stop = YES;
        }
    }];
    return foundEmotionView;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    //添加新数据
    int count = (int)emotions.count;
    int currentEmotionViewCount = (int)self.emotionViews.count;
    
    for (int i = 0; i < count; i++) {
        XWEmotionView *emotionView = nil;
        
        if (i >= currentEmotionViewCount) {
            emotionView = [[XWEmotionView alloc] init];
            [emotionView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:emotionView];
            [self.emotionViews addObject:emotionView];
        } else {
            emotionView = self.emotionViews[i];
        }
        
        emotionView.emotion = emotions[i];
        emotionView.hidden = NO;
        
    }
    
    for (int i = count; i < currentEmotionViewCount; i++) {
        UIButton *emotionView = self.emotionViews[i];
        emotionView.hidden = YES;
    }
}

- (void)emotionClick:(XWEmotionView *)emotionView
{
    [self.popView showFromEmotionView:emotionView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView dismiss];
    });
    
    [self selectedEmotion:emotionView.emotion];
}

- (void)selectedEmotion:(XWEmotion *)emotion
{
    if (emotion == nil) {
        return;
    }
    
    [XWEmotionTool addRecentEmotion:emotion];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kXWEmotionDidSelectedNotification object:nil userInfo:@{kXWSelectedEmotion : emotion}];
}

- (void)deleteClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kXWEmotionDidDeletedNotification object:nil userInfo:nil];
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
        UIButton *emotionView = self.emotionViews[i];
        emotionView.x = leftInset + (i % kXWEmotionMaxCols) * emotionViewW;
        emotionView.y = topInset + (i / kXWEmotionMaxCols) * emotionViewH;
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
    }
    
    self.deleteBtn.width = emotionViewW;
    self.deleteBtn.height = emotionViewH;
    self.deleteBtn.x = self.width - leftInset - self.deleteBtn.width;
    self.deleteBtn.y = self.height - self.deleteBtn.height;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
