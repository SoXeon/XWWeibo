//
//  XWStatusParam.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWPageParam.h"

@interface XWStatusParam : XWPageParam
/** false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。 */
@property (nonatomic, strong) NSNumber *base_app;
/**false	int	过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。 */
@property (nonatomic, strong) NSNumber *feature;
/** false	int	返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。 */
@property (nonatomic, strong) NSNumber *trim_user;
@end
