//
//  XWEmotionTextView.m
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWEmotionTextView.h"
#import "XWEmotion.h"
#import "RegexKitLite.h"

@implementation XWEmotionTextView
- (void)appendEmotion:(XWEmotion *)emotion
{
    if (emotion.emoji) {
        [self insertText:emotion.emoji];
    } else {
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        //带图片表情的富文本
        NSTextAttachment *attach =[[NSTextAttachment alloc] init];
        attach.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png]];
        attach.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        int insertIndex = self.selectedRange.location;
        
        [attributedText insertAttributedString:attachString atIndex:insertIndex];
        
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        self.attributedText = attributedText;
        
        self.selectedRange = NSMakeRange(insertIndex + 1, 0);
        
#warning 无奈之举，没有办法识别图像，然后使得placeholder消失,不知道这里是否会影响以后的内容上传
        [self insertText:@""];
    }
}

- (NSString *)realText
{
    NSMutableString *string = [NSMutableString string];
    
    //遍历富文本中所有内容
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSTextAttachment *attach = attrs[@"NSAttachment"];
        if (attach) {
            [string appendString:@"[哈哈]"];
        } else {
            NSString *subStr = [self.attributedText attributedSubstringFromRange:range].string;
            [string appendString:subStr];
        }
    }];
    
    return string;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
