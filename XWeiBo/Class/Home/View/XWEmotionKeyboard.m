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
#import "XWEmotionTool.h"

@interface XWEmotionKeyboard() <XWEmotionToobarDelegate>

@property (nonatomic, weak) XWEmotionListView *listView;
@property (nonatomic, weak) XWEmotionToobar *toolbar;

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
            self.listView.emotions = [XWEmotionTool defaultEmotions];
            break;
        case XWEmotionTypeEmoji:
            self.listView.emotions = [XWEmotionTool emojiEmotions];
            break;
        case XWEmotionTypeLXH:
            self.listView.emotions = [XWEmotionTool lxhEmotions];
            break;
        case XWEmotionTypeRecent:
            self.listView.emotions = [XWEmotionTool recentEmotions];
        default:
            break;
    }
    
}
@end
