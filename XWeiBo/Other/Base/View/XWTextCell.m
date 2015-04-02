//
//  XWTextCell.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWTextCell.h"
#import "XWIconView.h"
#import "XWBaseText.h"
#import "XWUser.h"
#import "UIImage+DP.h"
#import "XWBaseTextCellFrame.h"

@interface XWTextCell()

@end

@implementation XWTextCell

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    // 1.获得文件名
    int count = (int)[_myTableView numberOfRowsInSection:indexPath.section];
    NSString *bgName = @"statusdetail_comment_background_middle.png";
    NSString *seletcedBgName = @"statusdetail_comment_background_middle_highlighted.png";
    if (count - 1 == indexPath.row) { // 末行
        bgName = @"statusdetail_comment_background_bottom.png";
        seletcedBgName = @"statusdetail_comment_background_bottom_highlighted.png";
    }
    
    // 2.设置背景图片
    _bg.image = [UIImage resizedImage:bgName];
    _selectedBg.image = [UIImage resizedImage:seletcedBgName];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = kTableBorderWidth;
    frame.size.width -= kTableBorderWidth * 2;
    
    [super setFrame:frame];
}

- (void)setCellFrame:(XWBaseTextCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    XWBaseText *baseText = cellFrame.baseText;
    
    // 1.头像
    _icon.frame = cellFrame.iconFrame;
    _icon.user = baseText.user;
    
    // 2.昵称
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = baseText.user.screenName;
    
    // 3.判断是不是会员
    if (baseText.user.mbtype == kMBTypeNone) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    // 4.内容
    _text.frame = cellFrame.textFrame;
    _text.text = baseText.text;
    
    // 5.时间
    _time.frame = cellFrame.timeFrame;
    _time.text = baseText.createdAt;
}


@end
