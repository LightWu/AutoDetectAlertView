//
//  AutoDetectAlertView.h
//  AutoDetectAlertView
//
//  Created by 吳宥逵 on 2015/7/17.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef ADA_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define ADA_INSTANCETYPE instancetype
#else
#define ADA_INSTANCETYPE id
#endif
#endif

typedef NS_ENUM(NSInteger, AutoDetectAlertViewStyle) {
    ADAlertStyleDefault                 = 0,
    ADAlertStyleSecureTextInput,
    ADAlertStylePlainTextInput,
    ADAlertStyleLoginAndPasswordInput
};

typedef NS_ENUM(NSInteger, AutoDetectTextFieldIndex) {
    ADAlertLoginTextField   =0,
    ADAlertPasswordTextField=1,
};

@protocol AutoDetectAlertViewDelegate;

NS_CLASS_AVAILABLE_IOS(6_0) @interface AutoDetectAlertView : NSObject

@property (strong, nonatomic) id<AutoDetectAlertViewDelegate>delegate;

@property (assign, nonatomic) AutoDetectAlertViewStyle alertViewStyle;

@property (nonatomic) NSInteger cancelButtonIndex;

@property (nonatomic) NSInteger tag;

+ (ADA_INSTANCETYPE) initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles;
- (id) initTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles;
- (UITextField*) textFieldAtIndex:(NSInteger)index;
- (void) show;

@end


@protocol AutoDetectAlertViewDelegate <NSObject>

@optional

- (void) alertView:(AutoDetectAlertView*)alertView didClickButtonAtIndex:(NSInteger)index;

@end
