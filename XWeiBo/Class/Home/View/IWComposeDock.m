//
//  IWComposeDock.m
//  ItcastWeibo
//
//  Created by mj on 14-1-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWComposeDock.h"
#import "NSString+DP.h"

@interface IWComposeDock()

@end

@implementation IWComposeDock

+ (instancetype)dock
{
    return [[NSBundle mainBundle] loadNibNamed:@"IWComposeDock" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    // 1.背景
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"compose_toolbar_background"]];
    
    // 2.按钮图片
    [self setupBtn:_cameraBtn icon:@"compose_camerabutton_background"];
    [self setupBtn:_albumBtn icon:@"compose_toolbar_picture"];
    [self setupBtn:_atBtn icon:@"compose_mentionbutton_background"];
    [self setupBtn:_topicBtn icon:@"compose_trendbutton_background"];
    [self setupBtn:_emotionBtn icon:@"compose_emoticonbutton_background"];
}

- (void)setupBtn:(UIButton *)btn icon:(NSString *)icon
{
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageWithName:[icon stringByAppendingString:@"_highlighted"]] forState:UIControlStateHighlighted];
}

- (IBAction)cameraClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cameraClick" object:self];
}

- (IBAction)albumClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"albumClick" object:self];
}

- (IBAction)atClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"atClick" object:self];

}

- (IBAction)topicClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topicClick" object:self];
}

- (IBAction)emotionClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emotionClick" object:self];
    
}

@end
