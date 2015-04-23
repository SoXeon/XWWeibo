//
//  XWCommentDock.h
//  XWeiBo
//
//  Created by DP on 15/2/25.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWCommentDock : UIView
+ (instancetype)dock;

- (IBAction)clickRepeatAtion:(id)sender;
- (IBAction)clickTopicAction:(id)sender;
- (IBAction)clickEmjoyAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *repeatOther;
@property (weak, nonatomic) IBOutlet UIButton *topic;
@property (weak, nonatomic) IBOutlet UIButton *emjoy;


@end
