//
//  XWImageListView.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWImageListView : UIView

@property (nonatomic, strong) NSArray *imageUrls;

+ (CGSize)imageListSizeWithCount:(int)count;

@end
