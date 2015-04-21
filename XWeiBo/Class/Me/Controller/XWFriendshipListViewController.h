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


#warning 傻逼微博，又他妈封接口，有意思吗你！！！

@interface XWFriendshipListViewController : UITableViewController <IWFriendshipCellDelegate>
{
    NSMutableArray *_friendships;
    XWFriendshipParam *_param;
    XWFriendshipResult *_result;
}
@end
