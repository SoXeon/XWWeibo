//
//  kLink.h
//  XWeiBo
//
//  Created by DP on 15/4/22.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kLink : NSObject

/**
 *  链接文字
 */
@property (nonatomic, copy) NSString *text;
/**
 *  链接范围
 */
@property (nonatomic, assign) NSRange range;
/**
 *  链接的边框
 */
@property (nonatomic, strong) NSArray *rects;

@end
