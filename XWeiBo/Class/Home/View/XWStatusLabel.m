//
//  XWStatusLabel.m
//  XWeiBo
//
//  Created by DP on 15/4/18.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWStatusLabel.h"

@interface XWStatusLabel()

@property (nonatomic, weak) UITextView *textView;

@end

@implementation XWStatusLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITextView *textView = [[UITextView alloc] init];
        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        textView.backgroundColor = [UIColor clearColor];
        [self addSubview:textView];
        self.textView = textView;
    }
    return self;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    self.textView.attributedText = attributedText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
