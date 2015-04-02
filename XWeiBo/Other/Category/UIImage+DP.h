//
//  UIImage+DP.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DP)

+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)originalImageWithName:(NSString *)name;

@end
