//
//  Card.h
//  XWeiBo
//
//  Created by DP on 15/6/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * no;
@property (nonatomic, retain) NSManagedObject *person;

@end
