//
//  XWBaseTool.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseTool.h"
#import "XWBaseResult.h"
#import "XWBaseParam.h"
#import "MJExtension.h"

@implementation XWBaseTool

+ (void)getWithPath:(NSString *)path param:(XWBaseParam *)param success:(void (^)(id))success failure:(HttpFailureBlock)failure resultClass:(Class)resultClass
{
    [self getWithURL:XWURLWithPath(path) param:param success:success failure:failure resultClass:resultClass];
}

+ (void)postWithPath:(NSString *)path param:(XWBaseParam *)param success:(void (^)(id))success failure:(HttpFailureBlock)failure resultClass:(Class)resultClass
{
    [self postWithURL:XWURLWithPath(path) param:param success:success failure:failure resultClass:resultClass];
}

+ (void)getWithURL:(NSString *)url param:(XWBaseParam *)param success:(void (^)(id result))success failure:(HttpFailureBlock)failure resultClass:(Class)resultClass
{
    // 1.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setDictionary:param.keyValues];
    
    // 2.发送请求
    
    [HttpTool getWithpath:url params:params success:^(id JSON) {
        if (success == nil) return;
        id result = [resultClass objectWithKeyValues:JSON];
        success(result);
    } failure:failure];
}

+ (void)postWithURL:(NSString *)url param:(XWBaseParam *)param success:(void (^)(id result))success failure:(HttpFailureBlock)failure resultClass:(Class)resultClass
{
    // 1.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setDictionary:param.keyValues];
    
    // 2.发送请求
    [HttpTool postWithpath:url
                    params:params success:^(id JSON) {
                        if (success == nil) return;
                        id result = [resultClass objectWithKeyValues:JSON];
                        success(result);
                    } failure:failure];
    
}


@end
