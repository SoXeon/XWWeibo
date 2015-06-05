//
//  CommentViewController.m
//  XWeiBo
//
//  Created by DP on 15/2/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "CommentViewController.h"
#import "UIViewController+MaryPopin.h"
#import "XWStatus.h"
#import "XWStatusTool.h"
#import "XWAccountTool.h"
#import "NSString+DP.h"
#import "UIButton+backgroundMusic.h"
#import "CRToast.h"

static BOOL firstComment = YES;

@interface CommentViewController () <UITextViewDelegate>

@property (nonatomic, strong) NSString *commentText;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTextView];

}

- (void)setTextView
{
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.commentTextView.delegate = self;
    self.commentText = self.commentTextView.text;
    self.commentBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelAction:(id)sender {
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        NSLog(@"Popin dismissed !");
    }];
    
    [self.cancelBtn addCertainMusicWithName:@"sharing 10" forButton:nil];
}

- (IBAction)commentAction:(id)sender {
    
    NSDictionary *options = @{
                              kCRToastTextKey: @"正在回复...",
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
                                  kCRToastTextKey: @"回复成功",
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
    
    [HttpTool postWithpath:@"2/comments/create.json" params:@{
                                                              @"id" : @(_status.ID),
                                                              @"comment" : self.commentText
                                                              
                                                              } success:^(id JSON) {
                                           
                                                                  [wself.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
                                                                      NSLog(@"Popin dismissed !");
                                                                  }];
                                                              } failure:^(NSError *error) {
                                                                  
                                                              }];
    
    [self.commentBtn addCertainMusicWithName:@"sharing 10" forButton:nil];
}

#pragma mark textView Delegate
- (void)textViewDidChange:(UITextView *)textView
{

    if (textView.text.length) {
        self.commentBtn.enabled = YES;
        self.commentText = textView.text;
    } else {
        self.commentBtn.enabled = NO;
    }
}



@end
