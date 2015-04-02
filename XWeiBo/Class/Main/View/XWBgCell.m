//
//  XWBgCell.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBgCell.h"

@implementation XWBgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bg = [[UIImageView alloc] init];
        self.backgroundView = bg;
        
        selectedBg = [[UIImageView alloc] init];
        self.selectedBackgroundView = selectedBg;
    }
    return self;
}

@end
