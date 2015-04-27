//
//  kLink.h
//  XWeiBo
//
//  Created by DP on 15/4/22.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNormalWebType,
    kViedoType,
    kMusicType,
    kAvtivityType,
    kVoteType
} urlType;


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

/**
 *  链接类型
 */
@property (nonatomic, assign) urlType urlDetailType;

@end
