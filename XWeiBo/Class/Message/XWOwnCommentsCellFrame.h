//
//  XWOwnCommentsCellFrame.h
//  XWeiBo
//
//  Created by DP on 15/2/16.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWOwnComment.h"

@interface XWOwnCommentsCellFrame : NSObject

@property (nonatomic, strong) XWOwnComment *ownComments;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) CGRect iconFrame;
@property (nonatomic, readonly) CGRect screenNameFrame;
@property (nonatomic, readonly) CGRect mbIconFrame;
@property (nonatomic, readonly) CGRect timeFrame;
@property (nonatomic, readonly) CGRect textFrame;


@property (nonatomic, readonly) CGRect statusFrame;
@property (nonatomic, readonly) CGRect statusScreenNameFrame; // 回复微博作者的昵称
@property (nonatomic, readonly) CGRect statusTextFrame; // 回复微博的内容
@property (nonatomic, readonly) CGRect statusImageFrame; // 回复微博的配图


@end
