//
//  DetailHeader.m
//  新浪微博
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "DetailHeader.h"
#import "XWStatus.h"

@interface DetailHeader()
{
    UIButton *_selectedBtn;
}
@end

@implementation DetailHeader

#pragma mark 监听按钮点击
- (IBAction)btnClick:(UIButton *)sender {
    // 控制状态
    _selectedBtn.enabled = YES;
    sender.enabled = NO;
    _selectedBtn = sender;
    
    // 移动三角形指示器
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = _hint.center;
        center.x  = sender.center.x;
        _hint.center = center;
    }];
    
    DetailHeaderBtnType type = (sender==_repost)?kDetailHeaderBtnTypeRepost:kDetailHeaderBtnTypeComment;
    _currentBtnType = type;
    
    // 通知代理
    if ([_delegate respondsToSelector:@selector(detailHeader:btnClick:)]) {
        [_delegate detailHeader:self btnClick:type];
    }
}

+ (id)header
{
    return [[NSBundle mainBundle] loadNibNamed:@"DetailHeader" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    [self btnClick:_comment];
}

- (void)setStatus:(XWStatus *)status
{
    _status = status;
    
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