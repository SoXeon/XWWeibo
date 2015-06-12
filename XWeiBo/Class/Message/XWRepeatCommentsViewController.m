//
//  XWRepeatCommentsViewController.m
//  XWeiBo
//
//  Created by DP on 15/2/25.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWRepeatCommentsViewController.h"
#import "XWCommentDock.h"
#import "XWPlaceholderTextView.h"
#import "MBProgressHUD+Add.h"
#import "XWStatusTool.h"
#import "XWEmotionKeyboard.h"
#import "XWEmotion.h"
#import "XWEmotionTextView.h"

#import "CRToast.h"

@interface XWRepeatCommentsViewController ()
{
    XWCommentDock *_dock;
}

@property (nonatomic, assign, getter=isChangingKeyboard) BOOL changingKeyboard;
@property (nonatomic, strong) XWEmotionKeyboard *keyboard;
@property (nonatomic, weak) XWEmotionTextView *textView;


@end

@implementation XWRepeatCommentsViewController

- (XWEmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        self.keyboard = [XWEmotionKeyboard keyboard];
        self.keyboard.width = [UIScreen mainScreen].bounds.size.width;
        self.keyboard.height = 216;
    }
    return _keyboard;
}

- (id)init
{
    if (self = [super init]) {
        _ownComment = [[XWOwnComment alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavBar];
    
    [self setupTextView];
    
    [self setupDock];
    
}


- (void)setupDock
{
    XWCommentDock *dock = [XWCommentDock dock];
    CGRect dockF = dock.frame;
    dockF.origin.y = self.view.frame.size.height - dockF.size.height;
    dock.frame = dockF;
    [self.view addSubview:dock];
    _dock = dock;
}

- (void)setupTextView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 1.添加输入控件
    CGRect frame = self.view.bounds;
    frame.size.height = 200;
    XWEmotionTextView *textView = [[XWEmotionTextView alloc] initWithFrame:frame];
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"回复小伙伴...";
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    self.view.backgroundColor = textView.backgroundColor;
    _textView = textView;
    
    // 2.监听键盘通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:textView];
    [center addObserver:self selector:@selector(addEmotion) name:@"emotionClick" object:nil];
    [center addObserver:self selector:@selector(addTopic) name:@"topicClick" object:nil];
    [center addObserver:self selector:@selector(addAt) name:@"atClick" object:nil];
    
    [center addObserver:self selector:@selector(emotionDidSelected:) name:kXWEmotionDidSelectedNotification object:nil];
    [center addObserver:self selector:@selector(emotionDidDeleted:) name:kXWEmotionDidDeletedNotification object:nil];
}

- (void)addTopic
{
    NSString * tex = self.textView.text;
    
    tex = [tex stringByAppendingString: @"##"];
    
    self.textView.text = tex;
    
    NSRange range;
    range.location = self.textView.text.length - 1;
    range.length = 0;
    self.textView.selectedRange = range;
    
}

- (void)addAt
{
    NSString *tex = self.textView.text;
    
    tex = [tex stringByAppendingString: @"@"];
    
    self.textView.text = tex;
}


#pragma mark 表情的选中与删除
- (void)emotionDidSelected:(NSNotification *)note
{
    XWEmotion *emotion = note.userInfo[kXWSelectedEmotion];
    XWLog(@"%@ %@", emotion.chs, emotion.emoji);
    
    [self.textView appendEmotion:emotion];
    
    [self textViewDidChange:self.textView];
    
}

- (void)emotionDidDeleted:(NSNotification *)note
{
    [self.textView deleteBackward];
}


- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}



- (void)addEmotion
{
    self.changingKeyboard = YES;
    
    if (_textView.inputView) {
        _textView.inputView = nil;
        
        [_dock.emjoy setImage:[UIImage imageWithName:@"compose_emoticonbutton_background_os7"] forState:UIControlStateNormal];
        [_dock.emjoy setImage:[UIImage imageWithName:@"compose_emoticonbutton_background_highlighted_os7"] forState:UIControlStateHighlighted];
    } else {
        
        [_dock.emjoy setImage:[UIImage imageWithName:@"compose_keyboardbutton_background_os7"] forState:UIControlStateNormal];
        [_dock.emjoy setImage:[UIImage imageWithName:@"compose_keyboardbutton_background_highlighted_os7"] forState:UIControlStateHighlighted];
        
        _textView.inputView = self.keyboard;
        
    }
    
    [_textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_textView becomeFirstResponder];
    });

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 显示键盘就会调用
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取出键盘的高度
    CGFloat keyboardH = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // 2.键盘的动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 3.动画
    [UIView animateWithDuration:duration animations:^{
        _dock.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }];
}

#pragma mark 隐藏键盘就会调用
- (void)keyboardWillHide:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        _dock.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark TextView文字改了
- (void)textDidChange:(NSNotification *)note
{
    self.navigationItem.rightBarButtonItem.enabled = _textView.realText.length != 0;
}

- (void)setupNavBar
{
    self.title = @"回复微博";
    self.view.backgroundColor = XWColor(232, 232, 232);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(send)];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
    
    NSDictionary *options = @{
                              kCRToastTextKey: @"正在回复...",
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey: [UIColor yellowColor],
                              kCRToastTextColorKey: [UIColor redColor],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom),
                              kCRToastAnimationInTimeIntervalKey : @(0.5)
                              };
    
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *options = @{
                                  kCRToastTextKey: @"回复成功",
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey: [UIColor yellowColor],
                                  kCRToastTextColorKey: [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionBottom),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationInTimeIntervalKey : @(0.5),
                                  };
        
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
        
    });

    
    
    [_textView resignFirstResponder];

    [XWStatusTool repeatCommentsWithStatusID:_ownComment.status.ID commentsID:_ownComment.commentsID commentContent:_textView.realText success:^(id JSON) {
        
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [self cancel];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
    }];

}

@end
