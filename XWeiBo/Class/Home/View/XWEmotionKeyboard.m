//
//  XWEmotionKeyboard.m
//  XWeiBo
//
//  Created by DP on 15/4/5.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionKeyboard.h"
#import "XWEmotionListView.h"
#import "XWEmotionToobar.h"
#import "MJExtension.h"
#import "XWEmotion.h"

@interface XWEmotionKeyboard() <XWEmotionToobarDelegate>

@property (nonatomic, weak) XWEmotionListView *listView;
@property (nonatomic, weak) XWEmotionToobar *toolbar;
/** 默认表情 */
@property (nonatomic, strong) NSArray *defaultEmotions;
/** emoji表情 */
@property (nonatomic, strong) NSArray *emojiEmotions;
/** 浪小花表情 */
@property (nonatomic, strong) NSArray *lxhEmotions;

@end

@implementation XWEmotionKeyboard

- (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        self.defaultEmotions = [XWEmotion objectArrayWithFile:plist];
    }
    return _defaultEmotions;
}


- (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiEmotions = [XWEmotion objectArrayWithFile:plist];
    }
    return _emojiEmotions;
}

- (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhEmotions = [XWEmotion objectArrayWithFile:plist];
    }
    return _lxhEmotions;
}


+ (instancetype)keyboard
{
    return [self new];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"emoticon_keyboard_background"]];
        
        
        XWEmotionListView *listView = [XWEmotionListView new];
        [self addSubview:listView];
        self.listView = listView;
        
        XWEmotionToobar *toolbar = [XWEmotionToobar new];
        toolbar.delegate = self;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.toolbar.width = self.width;
    self.toolbar.height = 35;
    self.toolbar.y = self.height - self.toolbar.height;
    
    self.listView.width = self.width;
    self.listView.height = self.toolbar.y;
    
}

#pragma mark XWEmotionToolBarDelegate
- (void)emotionToolbar:(XWEmotionToobar *)toolbar didSelectedButton:(XWemotionType)emotionType
{
    switch (emotionType) {
        case XWEmotionTypeDefault:
            self.listView.emotions = self.defaultEmotions;
            break;
        case XWEmotionTypeEmoji:
            self.listView.emotions = self.emojiEmotions;
            break;
        case XWEmotionTypeLXH:
            self.listView.emotions = self.lxhEmotions;
            break;
        default:
            break;
    }
    
    NSLog(@"%lu %@", (unsigned long)self.listView.emotions.count, [self.listView.emotions firstObject]);
}
@end
