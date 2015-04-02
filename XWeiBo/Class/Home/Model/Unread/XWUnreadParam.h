//
//  XWUnreadParam.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWUidParam.h"

@interface XWUnreadParam : XWUidParam
/** false	boolean	未读数版本。0：原版未读数，1：新版未读数。默认为0。 */
@property (nonatomic, strong) NSNumber *unread_message;
@end
