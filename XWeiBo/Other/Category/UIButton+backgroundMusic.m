//
//  UIButton+backgroundMusic.m
//  XWeiBo
//
//  Created by DP on 15/5/1.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "UIButton+backgroundMusic.h"

@implementation UIButton (backgroundMusic)

- (void)addRandomMusicForButton:(UIButton *)btn
{
    SystemSoundID ID;
    
    NSString *musicName = [NSString stringWithFormat:@"sharing %d", 1 + (arc4random() % (16 - 1 + 1))];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:musicName ofType:@"wav"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileURL), &ID);
    
    AudioServicesPlaySystemSound(ID);
}

- (void)addCertainMusicWithName:(NSString *)name forButton:(UIButton *)btn
{
    
}
                          

@end
