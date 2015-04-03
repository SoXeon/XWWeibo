//
//  XWFriendshipListViewController.h
//  XWeiBo
//
//  Created by DP on 14/12/5.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWFriendshipCell.h"
@class XWFriendshipParam, XWFriendshipResult;

@interface XWFriendshipListViewController : UITableViewController <IWFriendshipCellDelegate>
{
    NSMutableArray *_friendships;
    XWFriendshipParam *_param;
    XWFriendshipResult *_result;
}
@end
