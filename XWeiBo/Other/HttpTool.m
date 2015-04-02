//
//  HttpTool.m
//  NiuNiuWeiBo
//
//  Created by 戴鹏 on 14-4-18.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "WeiBocfg.h"
#import "XWAccountTool.h"
#import "UIImageView+WebCache.h"

@implementation HttpTool
+(void)requestWithpath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    
    if (params) {
        [allParams setDictionary:params];
    }
    
    NSString *token = [XWAccountTool sharedXWAccountTool].currentAccount.accessToken;
    
    if (token) {
        [allParams setObject:token forKey:@"access_token"];

    }
    
    NSURLRequest *post = [client requestWithMethod:method path:path parameters:allParams];
    
    NSOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:post success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (success == nil) {
            return;
        }
        
        success(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure == nil) {
            return;
        }
        failure(error);
    }];
    
    [op start];
}


+(void)postWithpath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithpath:path params:params success:success failure:failure method:@"POST"];
}

+(void)getWithpath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self  requestWithpath:path params:params success:success failure:failure method:@"GET"];
}

+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView
{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority | SDWebImageRetryFailed];
}



@end
