//
//  XWBaseStatusListViewController.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseRefreshViewController.h"
#import "SWTableViewCell.h"

@interface XWBaseStatusListViewController : XWBaseRefreshViewController <SWTableViewCellDelegate>
{
    NSMutableArray *_statusFrames;
}
@end
