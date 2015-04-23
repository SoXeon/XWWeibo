//
//  XWOwnCommentCell.m
//  XWeiBo
//
//  Created by DP on 15/2/16.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWOwnCommentCell.h"
#import "XWIconView.h"
#import "UIImage+DP.h"
#import "XWImageListView.h"
#import "XWStatus.h"
#import "XWUser.h"
#import "XWOwnCommentsCellFrame.h"
#import "XWStatusLabel.h"

@interface XWOwnCommentCell()
{
    UILabel *_source; // 来源
    XWImageListView *_image;//配图
    
    UILabel *_statusScreenName;
    XWStatusLabel *_statusText;
    
    
}

@property (nonatomic, weak) UITableView *tableView;

@end


@implementation XWOwnCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"comments";
    XWOwnCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[XWOwnCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.tableView = tableView;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllSubViews];
        [self addStatusView];
        [self setBg];
    }
    return self;
}

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

- (void)addAllSubViews
{
    // 1.来源
    _source = [[UILabel alloc] init];
    _source.font = kSourceFont;
    _source.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_source];
    
    // 2.配图
    _image = [[XWImageListView alloc] init];
    [self.contentView addSubview:_image];

    _commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_commentsBtn];
}

- (void)addStatusView
{
    _statusScreenName = [[UILabel alloc] init];
    _statusScreenName.font = kRetweetedScreenNameFont;
    _statusScreenName.textColor = kRetweetedScreenNameColor;
    _statusScreenName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_statusScreenName];
    
    _statusText = [[XWStatusLabel alloc] init];
    [self.contentView addSubview:_statusText];
}

- (void)setCellFrame:(XWOwnCommentsCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    XWOwnComment *s = cellFrame.ownComments;
    
    _icon.frame = cellFrame.iconFrame;

    [_icon setUser: s.status.user type:kIconTypeSmall];
    
    //回复者昵称
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = s.user.screenName;
    
    //回复者是否为会员
    if (s.user.mbtype == kMBTypeNone) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    
    //回复按钮
    _commentsBtn.frame = CGRectMake(self.frame.size.width - 40 - 10, CGRectGetMinY(_screenName.frame), 40, 30);
    [_commentsBtn setTitle:@"回复" forState:UIControlStateNormal];
    [_commentsBtn setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
    _commentsBtn.layer.cornerRadius = 5.0;
    _commentsBtn.layer.masksToBounds = YES;
    _commentsBtn.layer.borderWidth = 1.0;
    _commentsBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    
    [_commentsBtn addTarget:self action:@selector(commentsWithOthers) forControlEvents:UIControlEventTouchUpInside];
    

    //回复时间
    _time.frame = cellFrame.timeFrame;
    _time.text = s.createdAt;
    
    //回复微博来源
    _source.text = s.status.source;
    CGFloat sourceX = CGRectGetMaxX(_time.frame) + kCellBorderWidth;
    CGFloat sourceY =  CGRectGetMaxY(cellFrame.screenNameFrame) + kCellBorderWidth;
    CGSize sourceSize = [_source.text sizeWithFont:kSourceFont];
    _source.frame = (CGRect) {{sourceX, sourceY}, sourceSize};
    
    //回复内容
    _text.frame = cellFrame.textFrame;
    _text.attributedText = s.attributeText;
    
#warning 富文本后，有些显示完整，有些则不行，API频次限制，明天fix
    
    //微博配图
#warning 没配图就用大号头像替代
    _image.frame = cellFrame.statusImageFrame;

    if (s.status.retweetedStatus.picUrls.count ) {
        NSArray *oneImageURL = [[NSArray alloc] initWithObjects: [s.status.retweetedStatus.picUrls objectAtIndex:0], nil];
        
        _image.imageUrls = oneImageURL;

    } else if (s.status.picUrls.count){
        NSArray *oneImageURL = [[NSArray alloc] initWithObjects: [s.status.picUrls objectAtIndex:0], nil];
        
        _image.imageUrls = oneImageURL;

    } else {

        NSDictionary *oneImageDictionary = [NSDictionary dictionaryWithObject:s.user.avatar_hd forKey:@"thumbnail_pic"];
        NSArray *oneImageURL = [[NSArray alloc] initWithObjects: oneImageDictionary, nil];
        _image.imageUrls = oneImageURL;

    }
    
    //微博发布者
    _statusScreenName.text = s.user.screenName;
    _statusScreenName.frame = cellFrame.statusScreenNameFrame;
    
    //微博内容
    _statusText.attributedText = s.status.attributeText;
    _statusText.frame = cellFrame.statusTextFrame;
    

}

- (void)commentsWithOthers
{
    if ([self.delegate respondsToSelector:@selector(commentsCell:didTapCommentsButton:)]) {
        [self.delegate performSelector:@selector(commentsCell:didTapCommentsButton:) withObject:self withObject:_commentsBtn];
    }
}
@end
