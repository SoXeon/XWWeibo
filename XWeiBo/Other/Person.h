//
//  Person.h
//  XWeiBo
//
//  Created by DP on 15/6/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) Card *card;

@end
