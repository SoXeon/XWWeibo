//
//  IWFriendshipCell.h
//  ItcastWeibo
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "XWBgCell.h"
@class XWUser;
@class IWFriendshipCell;

@protocol IWFriendshipCellDelegate<NSObject>

- (void)customCell:(IWFriendshipCell *)cell didTapButton:(UIButton *)button;

@end

@interface IWFriendshipCell : XWBgCell
@property (nonatomic, strong) XWUser *user;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (nonatomic, weak) id<IWFriendshipCellDelegate> delegate;

- (IBAction)changeFriendshipAction:(UIButton *)sender;
+ (CGFloat)cellHeight;
@end


