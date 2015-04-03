//
//  XWBaseStatusListViewController.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface XWBaseStatusListViewController : UITableViewController <SWTableViewCellDelegate>
{
    NSMutableArray *_statusFrames;
}
@end
