//
//  XWPasswordWindow.m
//  XWeiBo
//
//  Created by DP on 15/5/7.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWPasswordWindow.h"
#import "THPinViewController.h"
#import "THPinView.h"
#import "THPinInputCirclesView.h"

@interface XWPasswordWindow() <THPinViewControllerDelegate>

@property (nonatomic, strong) THPinViewController *pinViewController;

@end

@implementation XWPasswordWindow

+ (XWPasswordWindow *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.pinViewController = [[THPinViewController alloc] initWithDelegate:self];
        self.pinViewController.promptTitle = @"Enter PIN Again";
        self.pinViewController.promptColor = [UIColor greenColor];
        self.pinViewController.view.tintColor = [UIColor yellowColor];
        self.pinViewController.backgroundColor = [UIColor orangeColor];
        self.rootViewController = self.pinViewController;
        self.backgroundColor = [UIColor orangeColor];
        self.rootViewController.view.tag = THPinViewControllerContentViewTag;
        self.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.pinViewController.translucentBackground = YES;
        self.pinViewController.hideLetters = NO;
        
    }
    return self;
}

- (void)show
{
    [self makeKeyAndVisible];
    
    if ([self.pinViewController.pinView.input length] > 0) {
        
        [self.pinViewController.pinView.input deleteCharactersInRange:NSMakeRange(0, 4)];
        [self.pinViewController.pinView.inputCirclesView unfillAllCircles];

    }
    self.hidden = NO;
}

#pragma mark PinViewDelegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if ([pin isEqualToString: [XWUserDefaults objectForKey:kUserPin]]) {
        [self resignKeyWindow];
        self.hidden = YES;
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
