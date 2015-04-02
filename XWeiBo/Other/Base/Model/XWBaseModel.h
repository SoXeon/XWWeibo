//
//  XWBaseModel.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWBaseModel : NSObject
@property (nonatomic, assign) long long ID;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *idstr;
@property (nonatomic, strong) NSDate *createdTime;

- (id)initWithDict:(NSDictionary *)dict;

@end
