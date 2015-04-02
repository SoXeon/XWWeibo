//
//  XWUser.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseModel.h"

typedef enum {
    kVerifiedTypeNone = - 1, // 没有认证
    kVerifiedTypePersonal = 0, // 个人认证
    kVerifiedTypeOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    kVerifiedTypeOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    kVerifiedTypeOrgWebsite = 5, // 网站官方：猫扑
    kVerifiedTypeDaren = 220 // 微博达人
} VerifiedType;

typedef enum {
    kMBTypeNone = 0, // 没有
    kMBTypeNormal, // 普通
    kMBTypeYear // 年费
} MBType;
@class XWStatus;
@interface XWUser : XWBaseModel

@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profileImageUrl;
/** string	用户头像地址（大图），180×180像素 */
@property (nonatomic, copy) NSString *avatar_large;
/** string	用户头像地址（高清），高清头像原图 */
@property (nonatomic, copy) NSString *avatar_hd;
@property (nonatomic, assign) BOOL verified; //是否是微博认证用户，即加V用户
@property (nonatomic, assign) VerifiedType verifiedType; // 认证类型
@property (nonatomic, assign) int mbrank; // 会员等级
@property (nonatomic, assign) MBType mbtype; // 会员类型
@property (nonatomic, copy) NSString *desc;
// 认证类型
@property (nonatomic, assign) VerifiedType verified_type;


/** string 	认证原因 */
@property (nonatomic, copy) NSString *verified_reason;
/** string	性别，m：男、f：女、n：未知 */
@property (nonatomic, copy) NSString *gender;
/**	object	用户的最近一条微博信息字段 详细 */
@property (nonatomic, strong) XWStatus *status;

/**	boolean	该用户是否关注当前登录用户，true：是，false：否 */
@property (nonatomic, assign) BOOL follow_me;

/** 当前登录用户是否关注他 */
@property (nonatomic, assign) BOOL following;

/**	int	粉丝数 */
@property (nonatomic, assign) int followers_count;
/**	int	关注数 */
@property (nonatomic, assign) int friends_count;
/**	int	微博数 */
@property (nonatomic, assign) int statuses_count;

@end
