//
//  UIView+TintColor.m
//  UIView+TintColor
//
//  Copyright (c) 2015 Draveness. All rights reserved.

#import "UIView+tintColor.h"
#import "DKNightVersionManager.h"
#import "objc/runtime.h"

@interface UIView ()

@property (nonatomic, strong) UIColor *normalTintColor;

@end

@implementation UIView (TintColor)

static char *nightTintColorKey;
static char *normalTintColorKey;

#pragma mark - Hook

+ (void)load {
    static dispatch_once_t onceToken;                                              
    dispatch_once(&onceToken, ^{                                                   
        Class class = [self class];                                                
        SEL originalSelector = @selector(setTintColor:);                                  
        SEL swizzledSelector = @selector(hook_setTintColor:);                                 
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

- (void)hook_setTintColor:(UIColor *)tintColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal) {
        self.normalTintColor = tintColor;
    }
    [self hook_setTintColor:tintColor];
}

#pragma mark - TintColor

- (UIColor *)normalTintColor {
    return objc_getAssociatedObject(self, &normalTintColorKey);
}

- (void)setNormalTintColor:(UIColor *)normalTintColor {
    objc_setAssociatedObject(self, &normalTintColorKey, normalTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)nightTintColor {
    return objc_getAssociatedObject(self, &nightTintColorKey) ? : self.tintColor;
}

- (void)setNightTintColor:(UIColor *)nightTintColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
        self.tintColor = nightTintColor;
    }
    objc_setAssociatedObject(self, &nightTintColorKey, nightTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

