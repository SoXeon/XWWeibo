//
//  XWImageItemView.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWImageItemView.h"
#import "HttpTool.h"

@interface XWImageItemView()
{
    UIImageView *_gifView;
}
@end

@implementation XWImageItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif.png"]];
        [self addSubview:gifView];
        _gifView = gifView;
    }
    return self;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
#warning gif图片重叠好多
    [HttpTool downloadImage:url place:[UIImage imageNamed:@"timeline_image_loading.png"] imageView:self];
    
    _gifView.hidden = ![url.lowercaseString hasSuffix:@"gif"];
}

- (void)setFrame:(CGRect)frame
{
    CGRect gifFrame = _gifView.frame;
    gifFrame.origin.x = frame.size.width - gifFrame.size.width;
    gifFrame.origin.y = frame.size.height - gifFrame.size.height;
    _gifView.frame = gifFrame;
    
    [super setFrame:frame];
}

@end
