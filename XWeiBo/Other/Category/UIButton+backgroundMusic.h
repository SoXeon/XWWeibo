//
//  UIButton+backgroundMusic.h
//  XWeiBo
//
//  Created by DP on 15/5/1.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (backgroundMusic)

- (void)addRandomMusicForButton:(UIButton *)btn;

- (void)addCertainMusicWithName:(NSString *)name forButton:(UIButton *)btn;

@end
