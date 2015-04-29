//
//  UIButton+TitleColor.m
//  UIButton+TitleColor
//
//  Copyright (c) 2015 Draveness. All rights reserved.

#import "UIButton+titleColor.h"
#import "DKNightVersionManager.h"
#import "objc/runtime.h"

@interface UIButton ()

@property (nonatomic, strong) UIColor *normalTitleColor;

@end

@implementation UIButton (TitleColor)

static char *nightTitleColorKey;
static char *normalTitleColorKey;

#pragma mark - Hook

+ (void)load {
    static dispatch_once_t onceToken;                                              
    dispatch_once(&onceToken, ^{                                                   
        Class class = [self class];                                                
        SEL originalSelector = @selector(setTitleColor:forState:);
        SEL swizzledSelector = @selector(hook_setTitleColor:forState:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);  
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);  
        BOOL didAddMethod =                                                        
        class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));                   
        if (didAddMethod){
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));           
        } else {                                                                   
            method_exchangeImplementations(originalMethod, swizzledMethod);        
        }
    });
}

- (void)hook_setTitleColor:(UIColor *)titleColor forState:(UIControlState)state {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal) {
        self.normalTitleColor = titleColor;
    }
    [self hook_setTitleColor:titleColor forState:state];
}

#pragma mark - TitleColor

- (UIColor *)normalTitleColor {
    return objc_getAssociatedObject(self, &normalTitleColorKey);
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    objc_setAssociatedObject(self, &normalTitleColorKey, normalTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)nightTitleColor {
    return objc_getAssociatedObject(self, &nightTitleColorKey) ? : self.currentTitleColor;
}

- (void)setNightTitleColor:(UIColor *)nightTitleColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        [self setTitleColor:nightTitleColor forState:UIControlStateNormal];
    }
    objc_setAssociatedObject(self, &nightTitleColorKey, nightTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

