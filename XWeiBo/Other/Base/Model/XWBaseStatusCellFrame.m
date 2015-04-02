//
//  XWBaseStatusCellFrame.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseStatusCellFrame.h"
#import "XWStatus.h"
#import "XWUser.h"
#import "XWIconView.h"
#import "XWImageListView.h"

@implementation XWBaseStatusCellFrame

- (void)setStatus:(XWStatus *)status
{
    _status = status;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - kTableBorderWidth * 2;
    
    CGFloat iconX = kCellBorderWidth * 2;
    CGFloat iconY = kCellBorderWidth;
    CGSize iconSize = [XWIconView iconSizeWithType:kIconTypeSmall];
    _iconFrame = CGRectMake(iconX, iconY, iconSize.width, iconSize.height);
    
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) + kCellBorderWidth * 2;
    CGFloat screenNameY = iconY;
    CGSize screenNameSize = [status.user.screenName sizeWithFont:kScreenNameFont];
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    
    // 会员图标
    if (status.user.mbtype != kMBTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth * 2;
        CGFloat mbIconY = screenNameY + (screenNameSize.height - kMBIconH) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, kMBIconW, kMBIconH);
    }
    
    // 3.时间
    CGFloat timeX = screenNameX + kCellBorderWidth;
    CGFloat timeY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth;
    CGSize timeSize = [status.createdAt sizeWithFont:kTimeFont];
    _timeFrame = (CGRect){{timeX, timeY}, timeSize};
    
    // 4.来源
    CGFloat sourceX = CGRectGetMaxX(_timeFrame) + kCellBorderWidth * 2;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:kSourceFont];
    _sourceFrame = (CGRect) {{sourceX, sourceY}, sourceSize};
    
    // 5.内容
    CGFloat textX = iconX ;
    CGFloat maxY = MAX(CGRectGetMaxY(_sourceFrame), CGRectGetMaxY(_iconFrame));
    CGFloat textY = maxY + kCellBorderWidth;
    CGSize textSize = [status.text sizeWithFont:kTextFont constrainedToSize:CGSizeMake(cellWidth - 2 * kCellBorderWidth, MAXFLOAT)];
    _textFrame = (CGRect){{textX, textY}, textSize};
    
    if (status.picUrls.count) { // 6.有配图
        CGFloat imageX = textX;
        CGFloat imageY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
        CGSize imageSize = [XWImageListView imageListSizeWithCount:status.picUrls.count];
        _imageFrame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
    } else if (status.retweetedStatus) { // 7.有转发的微博
        // 被转发微博整体
        CGFloat retweetX = textX;
        CGFloat retweetY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
        CGFloat retweetWidth = cellWidth - 2 * kCellBorderWidth;
        CGFloat retweetHeight = kCellBorderWidth;
        
        // 8.被转发微博的昵称
        CGFloat retweetedScreenNameX = kCellBorderWidth;
        CGFloat retweetedScreenNameY = kCellBorderWidth;
        NSString *name = [NSString stringWithFormat:@"@%@", status.retweetedStatus.user.screenName];
        CGSize retweetedScreenNameSize = [name sizeWithFont:kRetweetedScreenNameFont];
        _retweetedScreenNameFrame = (CGRect){{retweetedScreenNameX, retweetedScreenNameY}, retweetedScreenNameSize};
        
        // 9.被转发微博的内容
        CGFloat retweetedTextX = retweetedScreenNameX + kCellBorderWidth;
        CGFloat retweetedTextY = CGRectGetMaxY(_retweetedScreenNameFrame) + kCellBorderWidth;
        CGSize retweetedTextSize = [status.retweetedStatus.text sizeWithFont:kRetweetedTextFont constrainedToSize:CGSizeMake(retweetWidth - 2 * kCellBorderWidth, MAXFLOAT)];
        _retweetedTextFrame = (CGRect){{retweetedTextX, retweetedTextY}, retweetedTextSize};
        
        // 10.被转发微博的配图
        if (status.retweetedStatus.picUrls.count) {
            CGFloat retweetedImageX = retweetedTextX;
            CGFloat retweetedImageY = CGRectGetMaxY(_retweetedTextFrame) + kCellBorderWidth;
            CGSize imageSize = [XWImageListView imageListSizeWithCount:status.retweetedStatus.picUrls.count];
            _retweetedImageFrame = CGRectMake(retweetedImageX, retweetedImageY, imageSize.width, imageSize.height);
            
            retweetHeight += CGRectGetMaxY(_retweetedImageFrame);
        } else {
            retweetHeight += CGRectGetMaxY(_retweetedTextFrame);
        }
        
        _retweetedFrame = CGRectMake(retweetX, retweetY, retweetWidth, retweetHeight);
    }
    
    // 11.整个cell的高度
    _cellHeight = kCellBorderWidth + kCellMargin;
    if (status.picUrls.count) {
        _cellHeight += CGRectGetMaxY(_imageFrame);
    } else if (status.retweetedStatus) {
        _cellHeight += CGRectGetMaxY(_retweetedFrame);
    } else {
        _cellHeight += CGRectGetMaxY(_textFrame);
    }

    
}

@end
