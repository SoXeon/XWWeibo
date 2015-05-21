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

#import "CRToast.h"


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
    
    
    NSDictionary *options = @{
                              kCRToastTextKey: @"正在转发...",
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey: [UIColor yellowColor],
                              kCRToastTextColorKey: [UIColor redColor],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom),
                              kCRToastAnimationInTimeIntervalKey : @(0.5)
                              };
    
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *options = @{
                                  kCRToastTextKey: @"转发成功",
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey: [UIColor yellowColor],
                                  kCRToastTextColorKey: [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionBottom),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationInTimeIntervalKey : @(0.5),
                                  };
        
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
        
    });

    
    
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
