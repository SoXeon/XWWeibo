//
//  IWComposeDock.h
//  ItcastWeibo
//
//  Created by mj on 14-1-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWComposeDock : UIView
+ (instancetype)dock;

@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (weak, nonatomic) IBOutlet UIButton *atBtn;
@property (weak, nonatomic) IBOutlet UIButton *topicBtn;
@property (weak, nonatomic) IBOutlet UIButton *emotionBtn;

@end
