//
//  XWBaseTool.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpTool.h"
@class XWBaseParam;

@interface XWBaseTool : NSObject

+ (void)getWithPath:(NSString *)path param:(XWBaseParam *)param success:(void (^)(id result))success failure:(HttpFailureBlock)failure resultClass:(Class)resultClass;
+ (void)postWithPath:(NSString *)path param:(XWBaseParam *)param success:(void (^)(id result))success failure:(HttpFailureBlock)failure resultClass:(Class)resultClass;
+ (void)getWithURL:(NSString *)url param:(XWBaseParam *)param success:(void (^)(id result))success failure:(HttpFailureBlock)failure resultClass:(Class)resultClass;
+ (void)postWithURL:(NSString *)url param:(XWBaseParam *)param success:(void (^)(id result))success failure:(HttpFailureBlock)failure resultClass:(Class)resultClass;

@end
