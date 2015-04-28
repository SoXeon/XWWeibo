//
//  XWSecSetPinViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/28.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWSecSetPinViewController.h"
#import "THPinViewController.h"

@interface XWSecSetPinViewController() <THPinViewControllerDelegate>

@end

@implementation XWSecSetPinViewController

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
    
    [self showPinViewAnimated:NO];
}

- (void)showPinViewAnimated:(BOOL)animated
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.promptTitle = @"Enter PIN Again";
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
    
    if (pin == [XWUserDefaults objectForKey:kUserSetFirstPin]) {
        [XWUserDefaults setObject:pin forKey:kUserSetSecPin];
        [XWUserDefaults setObject:pin forKey:kUserPin];
        return YES;
    } else {
        return NO;
    }
    
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return YES;
}
@end
