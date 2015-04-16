//
//  XWRegexResult.h
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWRegexResult : NSObject
@property (nonatomic,copy) NSString *string;
@property (nonatomic,assign) NSRange range;
@end
