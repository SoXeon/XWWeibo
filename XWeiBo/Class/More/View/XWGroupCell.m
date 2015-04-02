//
//  XWGroupCell.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWGroupCell.h"
#import "UIImage+DP.h"

@interface XWGroupCell()
{
    UIImageView *_rightArrow;
}
@end


@implementation XWGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 2.清空label的背景色
        self.textLabel.backgroundColor = [UIColor whiteColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark 设置Cell的类型
- (void)setCellType:(CellType)cellType
{
    _cellType = cellType;
    
    if (cellType == kCellTypeArrow) {
        if (_rightArrow == nil) {
            _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow.png"]];
        }
        self.accessoryView = _rightArrow;
    } else if (cellType == kCellTypeLabel) {
        if (_rightLabel == nil) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor grayColor];
            label.bounds = CGRectMake(0, 0, 80, 44);
            label.font = [UIFont systemFontOfSize:12];
            _rightLabel = label;
        }
        self.accessoryView = _rightLabel;
    } else if (cellType == kCellTypeNone) {
        self.accessoryView = nil;
    } else if (cellType == kCellTypeSwitch) {
        if (_rightSwitch == nil) {
            _rightSwitch = [[UISwitch alloc] init];
        }
        self.accessoryView = _rightSwitch;
    }
}

#pragma mark 设置Cell所在的行号
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    int count = (int)[_myTableView numberOfRowsInSection:indexPath.section];
    if (count == 1) { // 这组只有1行
        _bg.image = [UIImage resizedImage:@"common_card_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_background_highlighted.png"];
    } else if (indexPath.row == 0) { // 当前组的首行
        _bg.image = [UIImage resizedImage:@"common_card_top_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_top_background_highlighted.png"];
    } else if (indexPath.row == count - 1) { // 当前组的末行
        _bg.image = [UIImage resizedImage:@"common_card_bottom_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted.png"];
    } else { // 当前组的中间行
        _bg.image = [UIImage resizedImage:@"common_card_middle_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_middle_background_highlighted.png"];
    }}


@end
