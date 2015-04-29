//
//  XWComposeViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWComposeViewController.h"
#import "IWComposeDock.h"
#import "MBProgressHUD+Add.h"
#import "XWStatusTool.h"
#import "XWUserTool.h"
#import "XWUpdateParam.h"
#import "XWUploadParam.h"
#import "XWAccountTool.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "XWEmotionKeyboard.h"
#import "XWEmotion.h"
#import "XWEmotionTextView.h"
#import "XWUserParam.h"
#import "XWUser.h"

#import "CRToast.h"

@interface XWComposeViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IWComposeDock *_dock;
}

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign, getter=isChangingKeyboard) BOOL changingKeyboard;
@property (nonatomic, strong) XWEmotionKeyboard *keyboard;
@property (nonatomic, weak) XWEmotionTextView *textView;
@property (nonatomic, copy) NSString *userName;
@end

@implementation XWComposeViewController

- (XWEmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        self.keyboard = [XWEmotionKeyboard keyboard];
        self.keyboard.width = [UIScreen mainScreen].bounds.size.width;
        self.keyboard.height = 216;
    }
    return _keyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置导航栏的内容
    [self setupNavBar];
    
    // 2.添加文本输入控件
    [self setupTextView];
    
    // 3.添加工具条
    [self setupDock];
    
    [self setupImageView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCamera) name:@"cameraClick" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addAlbum) name:@"albumClick" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addEmotion) name:@"emotionClick" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(emotionDidSelected:) name:kXWEmotionDidSelectedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(emotionDidDeleted:) name:kXWEmotionDidDeletedNotification object:nil];
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(5, 100, 80, 80);
    [_textView addSubview:imageView];
    self.imageView = imageView;
}

- (void)addCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];

}

- (void)addAlbum
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

- (void)addEmotion
{
    self.changingKeyboard = YES;
    
    if (_textView.inputView) {
        _textView.inputView = nil;
        
        [_dock.emotionBtn setImage:[UIImage imageWithName:@"compose_emoticonbutton_background_os7"] forState:UIControlStateNormal];
        [_dock.emotionBtn setImage:[UIImage imageWithName:@"compose_emoticonbutton_background_highlighted_os7"] forState:UIControlStateHighlighted];
    } else {
        
        [_dock.emotionBtn setImage:[UIImage imageWithName:@"compose_keyboardbutton_background_os7"] forState:UIControlStateNormal];
        [_dock.emotionBtn setImage:[UIImage imageWithName:@"compose_keyboardbutton_background_highlighted_os7"] forState:UIControlStateHighlighted];
        
        _textView.inputView = self.keyboard;

    }
    
    [_textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_textView becomeFirstResponder];
    });
    
}

#pragma mark 图片选择控制器代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
}

- (void)setupDock
{
    IWComposeDock *dock = [IWComposeDock dock];
    CGRect dockF = dock.frame;
    dockF.origin.y = self.view.frame.size.height - dockF.size.height;
    dock.frame = dockF;
    [self.view addSubview:dock];
    _dock = dock;
}


- (void)setupTextView
{
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // 1.添加输入控件
    CGRect frame = self.view.bounds;
    frame.size.height = 200;
    XWEmotionTextView *textView = [[XWEmotionTextView alloc] initWithFrame:frame];
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
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
    if (self.isChangingKeyboard) {
        self.changingKeyboard = NO;
        return;
    } else {
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            _dock.transform = CGAffineTransformIdentity;
        }];

    }
    
}


#pragma mark TextView文字改了
- (void)textDidChange:(NSNotification *)note
{
    self.navigationItem.rightBarButtonItem.enabled = _textView.text.length != 0;
}


#pragma mark - 导航栏相关
- (void)setupNavBar
{
    self.userName = [[NSString alloc] init];
    
    XWUserParam *userParams = [[XWUserParam alloc] init];
    
    
    
    [XWUserTool userWithParam:userParams success:^(XWUser *user) {
        NSString *prefix = @"发微博";
        NSString *text = [NSString stringWithFormat:@"%@\n%@", prefix, user.name];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[text rangeOfString:prefix]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[text rangeOfString:user.name]];
        
        // 创建label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.attributedText = string;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.width = 100;
        titleLabel.height = 44;
        self.navigationItem.titleView = titleLabel;
    } failure:^(NSError *error) {
        
    }];
    
    self.view.backgroundColor = XWColor(232, 232, 232);
    
    // 2.取消
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    // 3.发送
    if (iOS7) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(send)];
    } else {
        UIButton *blueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        blueBtn.bounds = CGRectMake(0, 0, 50, 30);
        blueBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [blueBtn setBackgroundImage:[UIImage resizedImage:@"navigationbar_button_send_background"] forState:UIControlStateNormal];
        [blueBtn setBackgroundImage:[UIImage resizedImage:@"navigationbar_button_send_background_pushed"] forState:UIControlStateHighlighted];
        [blueBtn setBackgroundImage:[UIImage resizedImage:@"navigationbar_button_send_background_disabled"] forState:UIControlStateDisabled];
        [blueBtn setTitle:@"发送" forState:UIControlStateNormal];
        [blueBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:blueBtn];
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send
{
    // 1.退出键盘
    [_textView resignFirstResponder];
    
    // 2.弹框
//    [MBProgressHUD showMessage:@"正在发送" toView:self.view.window];
    
    NSDictionary *options = @{
                              kCRToastTextKey: @"正在发送...",
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey: [UIColor yellowColor],
                              kCRToastTextColorKey: [UIColor redColor],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom),
                              kCRToastAnimationInTimeIntervalKey : @(1.0)
                              };
    
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *options = @{
                                  kCRToastTextKey: @"发送成功",
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey: [UIColor yellowColor],
                                  kCRToastTextColorKey: [UIColor redColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionBottom),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationInTimeIntervalKey : @(1.0),
                                  };
        
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];

    });
    
    if (self.imageView.image) {
        [self sendWithImage];
    } else {
        [self setWithoutImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)sendWithImage
{
    NSURL *url = [NSURL URLWithString:@"https://upload.api.weibo.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    
    
    XWAccountTool *newTool = [[XWAccountTool alloc] init];
    
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = _textView.realText;
    params[@"access_token"] = newTool.currentAccount.accessToken;
    
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 必须在这里说明要上传哪些文件
        NSData *data = UIImageJPEGRepresentation(self.imageView.image, 0.5);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];

    }];
    
    [client.operationQueue addOperation:op];

}

- (void)setWithoutImage
{
    // 3.发送请求
    XWUpdateParam *param = [[XWUpdateParam alloc] init];
    param.status = _textView.realText;
    [XWStatusTool updateWithParam:param success:^(XWStatus *status) {
//        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [self cancel];
    } failure:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
    }];
}


#pragma mark 表情的选中与删除
- (void)emotionDidSelected:(NSNotification *)note
{
    XWEmotion *emotion = note.userInfo[kXWSelectedEmotion];
    XWLog(@"%@ %@", emotion.chs, emotion.emoji);
    
    [self.textView appendEmotion:emotion];
    
    [self textViewDidChange:self.textView];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)emotionDidDeleted:(NSNotification *)note
{
    [self.textView deleteBackward];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
