//
//  XWPinDetailController.h
//  XWeiBo
//
//  Created by DP on 15/4/28.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWPinDetailController : UIViewController

@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger     *remainingPinEntries;
@property (nonatomic, assign) BOOL     locked;

@end
