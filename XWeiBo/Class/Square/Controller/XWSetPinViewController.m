//
//  XWSetPinViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/28.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWSetPinViewController.h"
#import "XWSecSetPinViewController.h"

@interface XWSetPinViewController()

@property (nonatomic, strong) UIButton *repeatBtn;
@property (nonatomic, assign) NSInteger pinSetCounts;

@end



@implementation XWSetPinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *colorData = [XWUserDefaults objectForKey:XWUserThemeColor];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    if (color) {
        self.view.backgroundColor = color;
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    self.repeatBtn  = [[UIButton alloc] init];
    self.repeatBtn.frame = CGRectMake(0, 0, 200, 44);
    [self.repeatBtn setTitle:@"再输入一次" forState:UIControlStateNormal];
    self.repeatBtn.center = self.view.center;
    [self.repeatBtn addTarget:self action:@selector(showPinViewAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.repeatBtn];
    
    [self showPinViewAnimated:NO];
    
}

- (void)showPinViewAnimated:(BOOL)animated
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.promptTitle = @"Enter PIN";
    UIColor *darkBlueColor = [UIColor colorWithRed:0.012f green:0.071f blue:0.365f alpha:1.0f];
    pinViewController.promptColor = darkBlueColor;
    pinViewController.view.tintColor = darkBlueColor;
    
    // for a solid background color, use this:
    pinViewController.backgroundColor = [UIColor whiteColor];
    
    // for a translucent background, use this:
    self.view.tag = THPinViewControllerContentViewTag;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    pinViewController.translucentBackground = YES;
    
    [self presentViewController:pinViewController animated:animated completion:nil];
}

#pragma mark PinViewController Delegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if (self.pinSetCounts == 0) {
        self.pinSetCounts++;
        [XWUserDefaults setObject:pin forKey:kUserSetFirstPin];
        return YES;

    } else {
        
        if ([pin isEqualToString:[XWUserDefaults stringForKey:kUserSetFirstPin]]) {
            [XWUserDefaults setObject:pin forKey:kUserPin];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserHasThePin object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            return YES;
        }
        return NO;
    }

}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return YES;
}

@end
