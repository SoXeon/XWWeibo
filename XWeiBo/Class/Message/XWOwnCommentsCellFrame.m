//
//  XWOwnCommentsCellFrame.m
//  XWeiBo
//
//  Created by DP on 15/2/16.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWOwnCommentsCellFrame.h"
#import "XWIconView.h"
#import "XWUser.h"
#import "XWOwnComment.h"
#import "XWStatus.h"
#import "XWImageListView.h"

@implementation XWOwnCommentsCellFrame

- (void)setOwnComments:(XWOwnComment *)ownComments
{
    _ownComments = ownComments;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - kTableBorderWidth * 2;
    
    // 1.头像
    CGFloat iconX = kCellBorderWidth;
    CGFloat iconY = kCellBorderWidth;
    CGSize iconSize = [XWIconView iconSizeWithType:kIconTypeDefault];
    _iconFrame = CGRectMake(iconX, iconY, iconSize.width, iconSize.height);
    
    // 2.昵称
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) + kCellBorderWidth;
    CGFloat screenNameY = iconY;
    CGSize screenNameSize = [ownComments.user.screenName sizeWithFont:kScreenNameFont];
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    
    // 会员图标
    if (ownComments.user.mbtype != kMBTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
        CGFloat mbIconY = screenNameY + (screenNameSize.height - kMBIconH) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, kMBIconW, kMBIconH);
    }
    
    // 3.时间
    CGFloat timeX = screenNameX;
    CGFloat timeWidth = 95.0;
    CGFloat timeY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth;
    CGSize timeSize = CGSizeMake(timeWidth, kTimeFont.lineHeight);
    _timeFrame = (CGRect){{timeX, timeY}, timeSize};

    
    // 4.微博\评论的内容
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(_timeFrame) + kCellBorderWidth;
    CGFloat textWidth = cellWidth - kCellBorderWidth - textX;
    CGSize textSize = [ownComments.text sizeWithFont:kTextFont constrainedToSize:CGSizeMake(textWidth, MAXFLOAT)];
    _textFrame = (CGRect){{textX, textY}, textSize};
    
    
    //回复微博内容
    CGFloat statusX = kCellBorderWidth;
    CGFloat statusY =  CGRectGetMaxY(_timeFrame) + kCellBorderWidth;
    CGFloat statusWidth = cellWidth - 2 * kCellBorderWidth;
    CGFloat statusHeight = kCellBorderWidth;
    
    CGFloat statusScreenNameX;
    CGFloat statusScreenNameY;
    NSString *name = [NSString stringWithFormat:@"@%@",ownComments.user.screenName];
    
    CGSize statusScreenNameSize = [name sizeWithFont:kRetweetedScreenNameFont];
    
    CGFloat statusTextX;
    CGFloat statusTextY;
    
    CGFloat imageX = kCellBorderWidth;
    CGFloat imageY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
    CGSize imageSize = CGSizeMake(85, 85);
    _statusImageFrame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
        
    statusScreenNameX = CGRectGetMaxX(_statusImageFrame) + kCellBorderWidth;
    statusScreenNameY = CGRectGetMinY(_statusImageFrame) + kCellBorderWidth;
    _statusScreenNameFrame = (CGRect) {{statusScreenNameX, statusScreenNameY}, statusScreenNameSize};
        
    statusTextX = statusScreenNameX;
    statusTextY = CGRectGetMaxY(_statusScreenNameFrame) + kCellBorderWidth * 0.5;
        
    CGSize statusTextSize = CGSizeMake(200, 44);
    _statusTextFrame = (CGRect){{statusTextX, statusTextY}, statusTextSize};
    
    _statusFrame = CGRectMake(statusX, statusY, statusWidth , statusHeight);
    
    // 11.整个cell的高度

    _cellHeight = CGRectGetMaxY(_statusTextFrame) + kCellBorderWidth * 4;
    
}

@end
