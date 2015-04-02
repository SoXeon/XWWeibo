//
//  UIImageView+DP.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "UIImageView+DP.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (DP)
- (void)setImageWithURL:(NSString *)url place:(UIImage *)place
{
    [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageRetryFailed | SDWebImageLowPriority];
}
@end
