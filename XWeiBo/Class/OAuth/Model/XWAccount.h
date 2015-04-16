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


/** string 	access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSString *expires_in;

/** 过期时间 */
@property (nonatomic, strong) NSDate *expires_time;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *name;
@end
