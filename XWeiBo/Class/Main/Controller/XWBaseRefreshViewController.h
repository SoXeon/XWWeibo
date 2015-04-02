//
//  XWBaseRefreshViewController.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface XWBaseRefreshViewController : UITableViewController <MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}
@end
