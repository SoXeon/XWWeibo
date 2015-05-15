//
//  XWStatusDock.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatusDock.h"
#import "NSString+DP.h"
#import "UIImage+DP.h"
#import "XWStatus.h"
#import "XWStatusTool.h"
#import "XWAccountTool.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"


@interface XWStatusDock()
{
    UIButton *_repost;
    UIButton *_comment;
    UIButton *_attitude;
}
@end

@implementation XWStatusDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        // 0.设置整个dock的背景
        self.image = [UIImage resizedImage:@"timeline_card_bottom.png"];
        
        // 1.添加3个按钮
        _repost = [self addBtn:@"转发" icon:@"icn_gallery_tweet_action_inline_retweet_off.png" bg:@"timeline_card_leftbottom.png" index:0];
        
        _comment = [self addBtn:@"评论" icon:@"icn_gallery_tweet_action_inline_reply_off.png" bg:@"timeline_card_middlebottom.png" index:1];
        _attitude = [self addBtn:@"赞" icon:@"icn_gallery_tweet_action_inline_favorite_off.png" bg:@"timeline_card_rightbottom.png" index:2];
    }
    return self;
}

- (UIButton *)addBtn:(NSString *)title icon:(NSString *)icon bg:(NSString *)bg index:(int)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 标题
    [btn setTitle:title forState:UIControlStateNormal];
    //    btn.tag = index + kBtnTagStart;
    // 图标
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    // 普通背景
    [btn setBackgroundImage:[UIImage resizedImage:bg] forState:UIControlStateNormal];
    // 高亮背景
    [btn setBackgroundImage:[UIImage resizedImage:[bg fileAppend:@"_highlighted"]] forState:UIControlStateHighlighted];
    // 文字颜色
    [btn setTitleColor:XWColor(188, 188, 188) forState:UIControlStateNormal];
    // 字体大小
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    // 设frame
    CGFloat w = self.frame.size.width / 3;
    btn.frame = CGRectMake(index * w, 0, w, kStatusDockHeight);
    // 文字左边会空出10的间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:btn];
    
    if (index) { // index不等于0，添加分隔线
        UIImage *img = [UIImage imageNamed:@"timeline_card_bottom_line.png"];
        UIImageView *divider = [[UIImageView alloc] initWithImage:img];
        divider.center = CGPointMake(btn.frame.origin.x, kStatusDockHeight * 0.5);
        [self addSubview:divider];
    }
    
    return btn;
}

#pragma mark 在内部固定自己的宽高
- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = kStatusDockHeight;
    
    [super setFrame:frame];
}


- (void)setStatus:(XWStatus *)status
{
    _status = status;
    
    // 1.转发
    [self setBtn:_repost title:@"转发" count:status.repostsCount];
    // 2.评论
    [self setBtn:_comment title:@"评论" count:status.commentsCount];
    // 3.赞
    [self setBtn:_attitude title:@"赞" count:status.attitudesCount];
}

#pragma mark 设置按钮文字
- (void)setBtn:(UIButton *)btn title:(NSString *)title count:(int)count
{
    if (count >= 10000) { // 上万
        CGFloat final = count / 10000.0;
        NSString *title = [NSString stringWithFormat:@"%.1f万", final];
        // 替换.0为空串
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [btn setTitle:title forState:UIControlStateNormal];
    } else if (count > 0) { // 一万以内
        NSString *title = [NSString stringWithFormat:@"%d", count];
        [btn setTitle:title forState:UIControlStateNormal];
    } else { // 没有
        [btn setTitle:title forState:UIControlStateNormal];
    }
}


@end
