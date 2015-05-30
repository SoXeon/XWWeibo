//
//  XWAboutViewController.m
//  XWeiBo
//
//  Created by DP on 15/5/30.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWAboutViewController.h"

@interface XWAboutViewController ()

@end

@implementation XWAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57 * 2, 57 * 2)];
    iconImageView.centerX = self.view.centerX;
    iconImageView.centerY = self.view.centerY;
    iconImageView.image = [UIImage imageNamed:@"bear"];
    
    [self.view addSubview:iconImageView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + 10, 100, 44)];
    versionLabel.font = kTimeFont;
    versionLabel.centerX = self.view.centerX;
    versionLabel.text = @"version:1.0.0";
    [self.view addSubview:versionLabel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
