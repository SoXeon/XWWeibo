//
//  XWDetailHeader.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWDetailHeader.h"
#import "XWStatus.h"

@interface XWDetailHeader()
{
    UIButton *_selectedBtn;
}

@end

@implementation XWDetailHeader

- (IBAction)btnClick:(UIButton *)sender {
    
    _selectedBtn.enabled = YES;
    sender.enabled = NO;
    _selectedBtn = sender;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = _hint.center;
        center.x = sender.center.x;
        _hint.center = center;
    }];
    
    DetailHeaderBtnType type = (sender == _repost)?kDetailHeaderBtnTypeRepost:kDetailHeaderBtnTypeComment;
    _currentBtnType = type;
    
    if ([_delegate respondsToSelector:@selector(detailHeader:btnClick:)]) {
        [_delegate detailHeader:self btnClick:type];
    }
}

+ (id)header
{
    return [[NSBundle mainBundle] loadNibNamed:@"XWDetailHeader" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    self.backgroundColor =  XWColor(232, 232, 232);
    [self btnClick:_comment];
}

- (void)setStatus:(XWStatus *)status
{
    [self setBtn:_comment title:@"评论" count:status.commentsCount];
    [self setBtn:_repost title:@"转发" count:status.repostsCount];
    [self setBtn:_attitude title:@"赞" count:status.attitudesCount];
}

- (void)setBtn:(UIButton *)btn title:(NSString *)title count:(int)count
{
    if (count >= 10000) { // 上万
        CGFloat final = count / 10000.0;
        title = [NSString stringWithFormat:@"%.1f万 %@", final, title];
        // 替换.0为空串
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [btn setTitle:title forState:UIControlStateNormal];
    } else { // 一万以内
        title = [NSString stringWithFormat:@"%d %@", count, title];
        [btn setTitle:title forState:UIControlStateNormal];
    }
}

@end
