//
//  XWAccount.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWAccount : NSObject <NSCoding>

@property (nonatomic,copy)NSString *accessToken;
@property (nonatomic,copy)NSString *uid;

@end
