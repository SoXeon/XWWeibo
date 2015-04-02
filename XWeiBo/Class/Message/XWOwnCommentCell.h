//
//  XWOwnCommentCell.h
//  XWeiBo
//
//  Created by DP on 15/2/16.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWBaseWordCell.h"
#import "XWOwnCommentsCellFrame.h"

@class XWOwnCommentCell;
@protocol XWCommentsCellDelegate <NSObject>

- (void)commentsCell:(XWOwnCommentCell *)cell didTapCommentsButton:(UIButton *)button;

@end

@interface XWOwnCommentCell : XWBaseWordCell
@property (nonatomic, strong) XWOwnCommentsCellFrame *cellFrame;

@property (nonatomic, strong) UIButton *commentsBtn;

@property (nonatomic, weak) id<XWCommentsCellDelegate> delegate;


@end
