//
//  XWBaseTextCellFrame.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseTextCellFrame.h"
#import "XWIconView.h"
#import "XWUser.h"
#import "XWBaseText.h"

@implementation XWBaseTextCellFrame

- (void)setBaseText:(XWBaseText *)baseText
{
    _baseText = baseText;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - kTableBorderWidth * 2;
    
    // 1.头像
    CGFloat iconX = kCellBorderWidth;
    CGFloat iconY = kCellBorderWidth;
    CGSize iconSize = [XWIconView iconSizeWithType:kIconTypeSmall];
    _iconFrame = CGRectMake(iconX, iconY, iconSize.width, iconSize.height);
    
    // 2.昵称
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) + kCellBorderWidth;
    CGFloat screenNameY = iconY;
    CGSize screenNameSize = [baseText.user.screenName sizeWithFont:kScreenNameFont];
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    
    // 会员图标
    if (baseText.user.mbtype != kMBTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
        CGFloat mbIconY = screenNameY + (screenNameSize.height - kMBIconH) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, kMBIconW, kMBIconH);
    }
    
    // 3.微博\评论的内容
    CGFloat textX = screenNameX;
    CGFloat textY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth;
    CGFloat textWidth = cellWidth - kCellBorderWidth - textX;
    CGSize textSize = [baseText.text sizeWithFont:kTextFont constrainedToSize:CGSizeMake(textWidth, MAXFLOAT)];
    _textFrame = (CGRect){{textX, textY}, textSize};
    
    // 4.时间
    CGFloat timeX = textX;
    CGFloat timeY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
    CGSize timeSize = CGSizeMake(textWidth, kTimeFont.lineHeight);
    _timeFrame = (CGRect){{timeX, timeY}, timeSize};
    
    // 5.cell的高度
    _cellHeight = CGRectGetMaxY(_timeFrame) + kCellBorderWidth;
}

@end
