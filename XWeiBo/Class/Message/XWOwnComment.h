//
//  XWOwnComment.h
//  XWeiBo
//
//  Created by DP on 15/2/16.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWBaseText.h"
#import "XWStatus.h"

@interface XWOwnComment : XWBaseText

@property (nonatomic, strong) XWStatus *status;

@property (nonatomic, assign) long long commentsID;

@end
