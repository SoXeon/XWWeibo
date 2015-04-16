//
//  XWBaseText.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseText.h"
#import "XWUser.h"
#import "RegexKitLite.h"

@implementation XWBaseText

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.text = dict[@"text"];
        self.user = [[XWUser alloc] initWithDict:dict[@"user"]];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    //解析普通文本中的表情
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    
    //拼配原则

    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4c00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XWLog(@"%@",*capturedStrings);
    }];
    
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
    }];
    
    self.attributeText = attributeText;
}

@end
