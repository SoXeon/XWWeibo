//
//  XWStatusLabel.m
//  XWeiBo
//
//  Created by DP on 15/4/18.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWStatusLabel.h"
#import "kLink.h"

#define kLinkBackgroundTag 10000

@interface XWStatusLabel()

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *links;

@end

@implementation XWStatusLabel

- (NSMutableArray *)links
{
    if (!_links) {
        NSMutableArray *links = [NSMutableArray array];
        
        //搜索所有的链接
        [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            NSString *linkText = attrs[kLinkText];
            
            if (linkText == nil) {
                return;
            }
            
            //创建一个链接
            kLink *link = [[kLink alloc] init];
            link.text = linkText;
            link.range = range;
            
            //处理矩形框
            NSMutableArray *rects = [NSMutableArray array];
            self.textView.selectedRange = range;
            NSArray *selectionRects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
            for (UITextSelectionRect *selectionRect in selectionRects) {
                if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) {
                    continue;
                }
                [rects addObject:selectionRect];

            }
            link.rects = rects;
            [links addObject:link];
            
        }];
        self.links = links;
    }
    return _links;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITextView *textView = [[UITextView alloc] init];
        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.userInteractionEnabled = NO;
        
        textView.textContainerInset = UIEdgeInsetsMake(0, -5, -5, -5);
        
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
    self.links = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    kLink *touchingLink = [self touchingLinkWithPoint:point];
    [self showLinkBackground:touchingLink];
    if (touchingLink) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLinkWillSelectedNotification object:nil userInfo:@{kLinkText : touchingLink.text}];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    kLink *touchingLink = [self touchingLinkWithPoint:point];
    if (touchingLink) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLinkDidSelectedNotification object:nil userInfo:@{kLinkText : touchingLink.text}];
    }
    
    //相当于触摸被取消了
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAllLinkBackground];
    });
}

/**
 *  根据触摸点找出被触摸的链接
 *
 *  @param point 触摸点
 *
 *  @return 链接模型
 */
- (kLink *)touchingLinkWithPoint:(CGPoint)point
{
    __block kLink *touchingLink = nil;
    [self.links enumerateObjectsUsingBlock:^(kLink *link, NSUInteger idx, BOOL *stop) {
        for (UITextSelectionRect *selectionRect in link.rects) {
            if (CGRectContainsPoint(selectionRect.rect, point)) {
                touchingLink = link;
                break;
            }
        }
    }];
    return touchingLink;
}


/**
 *  显示链接背景
 *
 *  @param link 需要显示背景的link
 */
- (void)showLinkBackground:(kLink *)link
{
    for (UITextSelectionRect *selectionRect in link.rects) {
        UIView *bg = [UIView new];
        bg.tag = kLinkBackgroundTag;
        bg.layer.cornerRadius = 3;
        bg.frame = selectionRect.rect;
        bg.backgroundColor = [UIColor orangeColor];
        [self insertSubview:bg atIndex:0];
    }
}

- (void)removeAllLinkBackground
{
    for (UIView *child in self.subviews) {
        if (child.tag == kLinkBackgroundTag) {
            [child removeFromSuperview];
        }
    }
}

@end
