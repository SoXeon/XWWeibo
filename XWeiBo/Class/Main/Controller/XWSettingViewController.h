//
//  XWSettingViewController.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWSettingGroup;
@class XWSettingCheckGroup;

@interface XWSettingViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *groups;

- (XWSettingGroup *)addGroup;
- (XWSettingCheckGroup *)addCheckGroup;
@end
