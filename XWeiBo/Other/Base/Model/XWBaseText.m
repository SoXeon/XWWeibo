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
#import "XWRegexResult.h"
#import "XWEmotionAttachment.h"
#import "XWEmotionTool.h"

@implementation XWBaseText

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.text = dict[@"text"];
        self.user = [[XWUser alloc] initWithDict:dict[@"user"]];
    }
    return self;
}

- (NSArray *)regexResultsWithText:(NSString *)text
{
    //存放所有匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
    //拼配原则
    
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4c00-\\u9fa5]+\\]";
    
    //非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XWRegexResult *rr = [[XWRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = NO;
        [regexResults addObject:rr];
    }];

    
    //表情
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        XWRegexResult *rr = [[XWRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = YES;
        [regexResults addObject:rr];
    }];
    
    
    [regexResults sortUsingComparator:^NSComparisonResult(XWRegexResult *rr1, XWRegexResult *rr2) {
        NSUInteger loc1 = rr1.range.location;
        NSUInteger loc2 = rr2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];

    return regexResults;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    //链接、@某人、#话题#
    
    //拼配普通文字和表情
    NSArray *regexResults = [self regexResultsWithText:text];
    
    //解析普通文本中的表情
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    
    [regexResults enumerateObjectsUsingBlock:^(XWRegexResult *result, NSUInteger idx, BOOL *stop) {
        
        if (result.isEmotion) {
            XWEmotionAttachment *attach = [[XWEmotionAttachment alloc] init];
            
            //传递表情
            attach.emotion = [XWEmotionTool emotionWithDesc:result.string];
            attach.bounds = CGRectMake(0, -3, kTextFont.lineHeight, kTextFont.lineHeight);
            
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributeText appendAttributedString:attachString];
            
        } else {
            
            NSMutableAttributedString *subStr = [[NSMutableAttributedString alloc] initWithString:result.string];
            
            // 匹配#话题#
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [result.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [subStr addAttribute:NSForegroundColorAttributeName value:kStatusHighTextColor range:*capturedRanges];
                [subStr addAttribute:kTopic value:*capturedStrings range:*capturedRanges];

            }];
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+ ?";
            [result.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [subStr addAttribute:NSForegroundColorAttributeName value:kStatusHighTextColor range:*capturedRanges];
                [subStr addAttribute:kMetionSomeone value:*capturedStrings range:*capturedRanges];

            }];
            
            // 匹配超链接
            NSString *httpRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [result.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [subStr addAttribute:NSForegroundColorAttributeName value:kStatusHighTextColor range:*capturedRanges];
                [subStr addAttribute:kLink value:*capturedStrings range:*capturedRanges];
            }];
            
            
            [attributeText appendAttributedString:subStr];
            
        }
        
    }];
    [attributeText addAttribute:NSFontAttributeName value:kRichTextFont range:NSMakeRange(0, attributeText.length)];
    
    self.attributeText = attributeText;
}

@end
