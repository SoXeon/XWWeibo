//
//  DetailHeader.h
//  新浪微博
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  第1组头部控件

#import <UIKit/UIKit.h>

@class XWStatus, DetailHeader;

typedef enum {
    kDetailHeaderBtnTypeRepost, // 转发
    kDetailHeaderBtnTypeComment, // 评论
} DetailHeaderBtnType;

@protocol DetailHeaderDelegate <NSObject>
@optional
- (void)detailHeader:(DetailHeader *)header btnClick:(DetailHeaderBtnType)index;
@end

@interface DetailHeader : UIView

@property (weak, nonatomic) IBOutlet UIButton *attitude;
@property (weak, nonatomic) IBOutlet UIButton *repost;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIImageView *hint;

- (IBAction)btnClick:(UIButton *)sender;
+ (id)header;

@property (nonatomic, strong) XWStatus *status;
@property (nonatomic, weak) id<DetailHeaderDelegate> delegate;

@property (nonatomic, assign, readonly) DetailHeaderBtnType currentBtnType;
@end
