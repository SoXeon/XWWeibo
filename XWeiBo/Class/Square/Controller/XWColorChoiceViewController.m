//
//  XWColorChoiceViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/24.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWColorChoiceViewController.h"
#import "HRColorPickerView.h"
#import "MAThemeKit.h"

@interface XWColorChoiceViewController()

@property (nonatomic, strong) HRColorPickerView *colorPickerView;

@end

@implementation XWColorChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSData *colorData = [XWUserDefaults objectForKey:XWUserThemeColor];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.colorPickerView = [[HRColorPickerView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65)];
    
    [self.view addSubview:self.colorPickerView];
    
    if (color) {
        self.colorPickerView.color = color;
    }
    
    [self.colorPickerView addTarget:self
                             action:@selector(colorDidChanged:)
                   forControlEvents:UIControlEventValueChanged];
    
}

- (void)colorDidChanged:(HRColorPickerView *)pickerView
{
    [[[UIApplication sharedApplication] keyWindow] setTintColor:pickerView.color];
    
    [MAThemeKit customizeNavigationBarColor:self.colorPickerView.color textColor:self.colorPickerView.color buttonColor:self.colorPickerView.color];
    
    [MAThemeKit customizeSwitchOnColor:self.colorPickerView.color];
    [MAThemeKit customizeActivityIndicatorColor:self.colorPickerView.color];
    
    self.navigationController.navigationBar.tintColor = self.colorPickerView.color;
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:self.colorPickerView.color];
    [XWUserDefaults setObject:colorData forKey:XWUserThemeColor];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:themeChangeNotification object:nil userInfo:@{@"themeColor": colorData }];
    
}

@end
