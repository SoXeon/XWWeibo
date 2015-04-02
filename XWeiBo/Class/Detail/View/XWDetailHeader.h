//
//  XWDetailHeader.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWStatus, DetailHeader;

typedef enum {
    kDetailHeaderBtnTypeRepost, // 转发
    kDetailHeaderBtnTypeComment, // 评论
} DetailHeaderBtnType;

@protocol DetailHeaderDelegate <NSObject>
@optional
- (void)detailHeader:(XWDetailHeader *)header btnClick:(DetailHeaderBtnType)index;
@end

@interface XWDetailHeader : UIView
@property (strong, nonatomic) IBOutlet UIButton *attitude;
@property (strong, nonatomic) IBOutlet UIButton *repost;
@property (strong, nonatomic) IBOutlet UIButton *comment;
@property (strong, nonatomic) IBOutlet UIImageView *hint;
- (IBAction)btnClick:(UIButton *)sender;
+ (id)header;

@property (nonatomic, strong) XWStatus *status;
@property (nonatomic, weak) id<DetailHeaderDelegate> delegate;

@property (nonatomic, assign, readonly) DetailHeaderBtnType currentBtnType;


@end
