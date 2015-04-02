//
//  RepostViewController.m
//  XWeiBo
//
//  Created by DP on 15/2/11.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "RepostViewController.h"
#import "UIViewController+MaryPopin.h"
#import "XWStatus.h"
#import "XWStatusTool.h"
#import "XWAccountTool.h"

@interface RepostViewController () <UITextViewDelegate>
@property (nonatomic, strong) NSString *statusText;

@end

@implementation RepostViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTextView];
}

- (void)setTextView
{
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.repostMessage.delegate = self;
    
    self.repostMessage.text =_status.text;
    self.statusText = _status.text;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)setStatus:(XWStatus *)status
{
    _status = status;
}

- (IBAction)cancelAction:(id)sender {
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        NSLog(@"Popin dismissed !");
    }];
}

- (IBAction)repostAction:(id)sender {
    
    __weak typeof(& *self) wself = self;
    
    [HttpTool postWithpath:@"2/statuses/repost.json" params:@{
                                                              @"id" : @(_status.ID),
                                                            
                                                              @"status" :self.statusText
                                                              } success:^(id JSON) {
                                                                  
                                                                  [wself.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
                                                                      NSLog(@"Popin dismissed !");
                                                                  }];
                                                              
                                                              } failure:^(NSError *error) {
                                                                  
                                                              }];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.statusText = textView.text;
}
@end
