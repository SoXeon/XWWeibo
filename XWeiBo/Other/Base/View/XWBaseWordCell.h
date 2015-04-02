//
//  XWBaseWordCell.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseCell.h"
@class XWIconView;
@interface XWBaseWordCell : XWBaseCell
{
    XWIconView *_icon;
    UILabel *_screenName;
    UIImageView *_mbIcon;
    UILabel *_text;
    UILabel *_time;
}
@end
