//
//  XWBaseText.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseModel.h"
@class XWUser;

@interface XWBaseText : XWBaseModel
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributeText;
@property (nonatomic, strong) XWUser *user;
@end
