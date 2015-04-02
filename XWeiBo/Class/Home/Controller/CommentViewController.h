//
//  CommentViewController.h
//  XWeiBo
//
//  Created by DP on 15/2/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWStatus;
@interface CommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic, strong) XWStatus *status;

- (IBAction)cancelAction:(id)sender;
- (IBAction)commentAction:(id)sender;

@end
