//
//  XWCommentDock.m
//  XWeiBo
//
//  Created by DP on 15/2/25.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWCommentDock.h"

@interface XWCommentDock()



@end

@implementation XWCommentDock

+ (instancetype)dock
{
    return [[NSBundle mainBundle] loadNibNamed:@"XWCommentDock" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"compose_toolbar_background"]];
    
    [self setupBtn:_repeatOther icon:@"compose_mentionbutton_background"];
    [self setupBtn:_topic icon:@"compose_trendbutton_background"];
    [self setupBtn:_emjoy icon:@"compose_emoticonbutton_background"];
}

- (void)setupBtn:(UIButton *)btn icon:(NSString *)icon
{
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageWithName:[icon stringByAppendingString:@"_highlighted"]] forState:UIControlStateHighlighted];
}

- (IBAction)clickRepeatAtion:(id)sender {
    
}

- (IBAction)clickTopicAction:(id)sender {
}

- (IBAction)clickEmjoyAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emotionClick" object:nil];
}


@end
