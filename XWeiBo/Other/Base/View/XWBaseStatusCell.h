//
//  XWBaseStatusCell.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseWordCell.h"
#import "XWBaseStatusCellFrame.h"

@interface XWBaseStatusCell : XWBaseWordCell
{
    UIImageView *_retweeted;
}
@property (nonatomic, strong) XWBaseStatusCellFrame *cellFrame;
@end
