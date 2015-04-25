//
//  XWProfileHeaderView.m
//  XWeiBo
//
//  Created by DP on 15/4/25.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWProfileHeaderView.h"
#import "IWNumberBtn.h"

@implementation XWProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self configureBar];
    }
    return self;
}

- (void)configureBar
{
    self.maximumBarHeight = 200.0;
    self.minimumBarHeight = 65.0;
    self.backgroundColor = [UIColor greenColor];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = kTextFont;
    self.nameLabel.textColor =[UIColor whiteColor];
    self.nameLabel.text = @"盛夏SoXeon";
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialNameLabelLayoutAttributes.size = [_nameLabel sizeThatFits:CGSizeZero];
    initialNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, self.maximumBarHeight-50.0);
    [_nameLabel addLayoutAttributes:initialNameLabelLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *midwayNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialNameLabelLayoutAttributes];
    midwayNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, (self.maximumBarHeight-self.minimumBarHeight)*0.4+self.minimumBarHeight-50.0);
    [_nameLabel addLayoutAttributes:midwayNameLabelLayoutAttributes forProgress:0.6];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:midwayNameLabelLayoutAttributes];
    finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, self.minimumBarHeight-25.0);
    [_nameLabel addLayoutAttributes:finalNameLabelLayoutAttributes forProgress:1.0];
    
    [self addSubview:self.nameLabel];
    
    self.profileImageView = [UIImageView new];
    self.profileImageView.contentMode = UIViewContentModeScaleToFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 35.0;
    self.profileImageView.layer.borderWidth = 2.0;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialProfileImageViewLayoutAttributes.size = CGSizeMake(70.0, 70.0);
    initialProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, self.maximumBarHeight-110.0);
    [_profileImageView addLayoutAttributes:initialProfileImageViewLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *midwayProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialProfileImageViewLayoutAttributes];
    midwayProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, (self.maximumBarHeight-self.minimumBarHeight)*0.8+self.minimumBarHeight-110.0);
    [_profileImageView addLayoutAttributes:midwayProfileImageViewLayoutAttributes forProgress:0.2];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:midwayProfileImageViewLayoutAttributes];
    finalProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, (self.maximumBarHeight-self.minimumBarHeight)*0.64+self.minimumBarHeight-110.0);
    finalProfileImageViewLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5);
    finalProfileImageViewLayoutAttributes.alpha = 0.0;
    [_profileImageView addLayoutAttributes:finalProfileImageViewLayoutAttributes forProgress:0.5];
    
    
    [self addSubview:self.profileImageView];
    
}

@end
