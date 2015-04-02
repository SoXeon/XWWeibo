//
//  XWPlaceholderTextView.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWPlaceholderTextView.h"

@implementation XWPlaceholderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
        
        // 2.默认颜色
        _placeholderColor = [UIColor grayColor];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)note
{
    if (_placeholder.length == 0) return;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    if (_placeholder.length == 0) return;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if (_placeholder.length == 0 || self.text.length != 0) return;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    if (_placeholder.length == 0 || self.text.length != 0) return;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.text.length == 0) {
        [_placeholderColor set];
        CGFloat padding = 8;
        CGRect placeholderRect = CGRectMake(padding, padding, rect.size.width - padding * 2, rect.size.height - padding);
        [_placeholder drawInRect:placeholderRect withFont:self.font];
    }
}


@end
