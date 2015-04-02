//
//  RepostViewController.h
//  XWeiBo
//
//  Created by DP on 15/2/11.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWStatus;

@interface RepostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *canelBtn;
@property (weak, nonatomic) IBOutlet UIButton *repostBtn;
@property (weak, nonatomic) IBOutlet UITextView *repostMessage;
@property (nonatomic, strong) XWStatus *status;


- (IBAction)cancelAction:(id)sender;
- (IBAction)repostAction:(id)sender;

@end
