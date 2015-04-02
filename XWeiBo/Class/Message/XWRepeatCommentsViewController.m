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

@interface XWRepeatCommentsViewController ()
{
    XWCommentDock *_dock;
    XWPlaceholderTextView *_textView;
}

@end

@implementation XWRepeatCommentsViewController

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
    XWPlaceholderTextView *textView = [[XWPlaceholderTextView alloc] initWithFrame:frame];
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
    self.navigationItem.rightBarButtonItem.enabled = _textView.text.length != 0;
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
    [_textView resignFirstResponder];

    [XWStatusTool repeatCommentsWithStatusID:_ownComment.status.ID commentsID:_ownComment.commentsID commentContent:_textView.text success:^(id JSON) {
        
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [self cancel];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
    }];

}

@end
