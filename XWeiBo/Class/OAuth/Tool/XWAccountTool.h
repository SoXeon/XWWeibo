//
//  XWAccountTool.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Single.h"
#import "XWAccount.h"

@interface XWAccountTool : NSObject

single_interface(XWAccountTool)

- (void)saveAccount:(XWAccount *)account;

@property (nonatomic,readonly)XWAccount *currentAccount;


@end
