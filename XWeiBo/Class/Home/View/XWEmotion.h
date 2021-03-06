//
//  XWEmotion.h
//  XWeiBo
//
//  Created by DP on 15/4/7.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWEmotion : NSObject

/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
@property (nonatomic, copy) NSString *cht;

/** 表情的文png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的编码 */
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *emoji;

/** 表情存放路径 */
@property (nonatomic, copy) NSString *directory;

@end
