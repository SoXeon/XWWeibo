//
//  XWBaseStatusCell.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseStatusCell.h"
#import "XWIconView.h"
#import "UIImage+DP.h"
#import "XWImageListView.h"
#import "XWBaseStatusCellFrame.h"
#import "XWStatus.h"
#import "XWUser.h"
//#import "IWIconView.h"

@interface XWBaseStatusCell()
{
    UILabel *_source; // 来源
    XWImageListView *_image; // 配图
    
    UILabel *_retweetedScreenName; // 被转发微博作者的昵称
    UILabel *_retweetedText; // 被转发微博的内容
    XWImageListView *_retweetedImage; // 被转发微博的配图
}

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation XWBaseStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    XWBaseStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XWBaseStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.tableView = tableView;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllSubviews];
        [self addReweetedAllSubviews];
        [self setBg];
    }
    return self;
}

#pragma mark 设置背景
- (void)setBg
{
    // 1.默认背景
    _bg.image = [UIImage resizedImage:@"common_card_background.png"];
    
    // 2.长按背景
    _selectedBg.image = [UIImage resizedImage:@"common_card_background_highlighted.png"];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 0;
    frame.origin.y += kTableBorderWidth;
    frame.size.width -= 0;
    frame.size.height -= kCellMargin;
    
    [super setFrame:frame];
}

#pragma mark 添加微博本身的子控件
- (void)addAllSubviews
{
    // 1.来源
    _source = [[UILabel alloc] init];
    _source.font = kSourceFont;
    _source.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_source];
    
    // 2.配图
    _image = [[XWImageListView alloc] init];
    [self.contentView addSubview:_image];
}

#pragma mark 被转发微博的子控件
- (void)addReweetedAllSubviews
{
    // 1.被转发微博的父控件
    _retweeted = [[UIImageView alloc] init];
    _retweeted.image = [UIImage resizedImage:@"timeline_retweet_background.png" leftScale:0.9 topScale:0.5];
    _retweeted.userInteractionEnabled = YES;
    [self.contentView addSubview:_retweeted];
    
    // 2.被转发微博的昵称
    _retweetedScreenName = [[UILabel alloc] init];
    _retweetedScreenName.font = kRetweetedScreenNameFont;
    _retweetedScreenName.textColor = kRetweetedScreenNameColor;
    _retweetedScreenName.backgroundColor = [UIColor clearColor];
    [_retweeted addSubview:_retweetedScreenName];
    
    // 3.被转发微博的内容
    _retweetedText = [[UILabel alloc] init];
    _retweetedText.numberOfLines = 0;
    _retweetedText.font = kRetweetedTextFont;
    _retweetedText.backgroundColor = [UIColor clearColor];
    [_retweeted addSubview:_retweetedText];
    
    // 4.被转发微博的配图
    _retweetedImage = [[XWImageListView alloc] init];
    [_retweeted addSubview:_retweetedImage];
}

- (void)setCellFrame:(XWBaseStatusCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    XWStatus *s = cellFrame.status;
    
    // 1.头像
    _icon.frame = cellFrame.iconFrame;
    //[_icon setUser:s.user iconType:IWIconTypeSmall];
    [_icon setUser:s.user type:kIconTypeSmall];
    
    // 2.昵称
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = s.user.screenName;
    // 判断是不是会员
    if (s.user.mbtype == kMBTypeNone) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    // 3.时间
    _time.text = s.createdAt;
    CGFloat timeX = cellFrame.screenNameFrame.origin.x;
    CGFloat timeY = CGRectGetMaxY(cellFrame.screenNameFrame) + kCellBorderWidth;
    CGSize timeSize = [_time.text sizeWithFont:kTimeFont];
    _time.frame = (CGRect){{timeX, timeY}, timeSize};
    
    // 4.来源
    _source.text = s.source;
    CGFloat sourceX = CGRectGetMaxX(_time.frame) + kCellBorderWidth;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [_source.text sizeWithFont:kSourceFont];
    _source.frame = (CGRect) {{sourceX, sourceY}, sourceSize};
    
    // 5.内容
    _text.frame = cellFrame.textFrame;
    _text.attributedText = s.attributeText;
    
    // 6.配图
    if (s.picUrls.count) {
        _image.hidden = NO;
        _image.frame = cellFrame.imageFrame;
        _image.imageUrls = s.picUrls;
    } else {
        _image.hidden = YES;
    }
    
    // 7.被转发微博
    if (s.retweetedStatus) {
        _retweeted.hidden = NO;
        
        _retweeted.frame = cellFrame.retweetedFrame;
        
        // 8.昵称
        _retweetedScreenName.frame = cellFrame.retweetedScreenNameFrame;
        _retweetedScreenName.text = [NSString stringWithFormat:@"@%@", s.retweetedStatus.user.screenName];
        
        // 9.内容
        _retweetedText.frame = cellFrame.retweetedTextFrame;
        _retweetedText.attributedText = s.retweetedStatus.attributeText;
        
        // 10.配图
        if (s.retweetedStatus.picUrls.count) {
            _retweetedImage.hidden = NO;
            
            _retweetedImage.frame = cellFrame.retweetedImageFrame;
            
            _retweetedImage.imageUrls = s.retweetedStatus.picUrls;
        } else {
            _retweetedImage.hidden = YES;
        }
    } else {
        _retweeted.hidden = YES;
    }
}

@end
