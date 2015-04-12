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

@interface XWEmotionGridView()

@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, strong) NSMutableArray *emotionViews;

@end

@implementation XWEmotionGridView

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
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    return self;
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
            emotionView.backgroundColor = XWRandomColor;
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
