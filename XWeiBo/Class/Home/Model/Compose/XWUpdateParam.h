//
//  XWUpdateParam.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseParam.h"

@interface XWUpdateParam : XWBaseParam
/**	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。 */
@property (nonatomic, copy) NSString *status;
/**	false	int	微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。 */
@property (nonatomic, strong) NSNumber *visible;
/**	false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。 */
@property (nonatomic, strong) NSNumber *list_id;
/**	false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。 */
//@property (nonatomic, strong) NSNumber *lat;
/**	false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。 */
//@property (nonatomic, strong) NSNumber *long;
@end
