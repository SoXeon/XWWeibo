//
//  XWNumberBtn.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "IWNumberBtn.h"

@implementation IWNumberBtn

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _title = [self titleForState:UIControlStateNormal];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setNumber:(int)number
{
    _number = number;
    
    if (_title == nil) {
        _title = [self titleForState:UIControlStateNormal];
    }
    
    NSString *numStr = [NSString stringWithFormat:@"%d", number];
    NSString *original = [NSString stringWithFormat:@"%@\n%@", numStr, _title];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:original];
    [str addAttribute:NSForegroundColorAttributeName value:XWColor(64, 105, 159) range:NSMakeRange(0, numStr.length)];
    [self setAttributedTitle:str forState:UIControlStateNormal];

}
@end
