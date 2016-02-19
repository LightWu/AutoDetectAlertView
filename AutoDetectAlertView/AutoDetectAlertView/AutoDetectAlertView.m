//
//  AutoDetectAlertView.m
//  AutoDetectAlertView
//
//  Created by 吳宥逵 on 2015/7/17.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "AutoDetectAlertView.h"
#import "AppDelegate.h"

AutoDetectAlertView *_autoDetectAlert=nil;

@interface AutoDetectAlertView () <UIAlertViewDelegate> {
    
//#ifdef __IPHONE_8_0 
    
    UIAlertController *ADAlertController;
    
//#else
    
    UIAlertView *ADAlertView;
    
//#endif
    
    __weak UIViewController *viewController;
    
}

@end

@implementation AutoDetectAlertView

@synthesize alertViewStyle=_alertViewStyle;

+ (instancetype) initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    NSMutableArray *btnTitles = [NSMutableArray array];
    va_list args;
    va_start(args, otherButtonTitles);
    
    while (otherButtonTitles != nil) {
        [btnTitles addObject:otherButtonTitles];
        
        otherButtonTitles = va_arg(args, NSString*);
    }
    
    return [[[self class] alloc] initTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:btnTitles];
}
 
- (id) initTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles {
    
    @autoreleasepool {
        
        self=[super init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if ([UIAlertController class]) {
                
                ADAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                for (int i = 0; i < otherButtonTitles.count; i++) {
                    UIAlertAction *act=[UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        if ([self.delegate respondsToSelector:@selector(alertView:didClickButtonAtIndex:)]) {
                            [self.delegate alertView:self didClickButtonAtIndex:i];
                        }
                        _autoDetectAlert=nil;
                        ADAlertController=nil;
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ADAlertController addAction:act];
                    });
                    
                }
                
                UIAlertAction *act=[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    if ([self.delegate respondsToSelector:@selector(alertView:didClickButtonAtIndex:)]) {
                        [self.delegate alertView:self didClickButtonAtIndex:-1];
                    }
                    _autoDetectAlert=nil;
                    ADAlertController=nil;
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ADAlertController addAction:act];
                });
                
                
                self.cancelButtonIndex=-1;
                
            } else {
                
                ADAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                
                for (int i = 0; i < otherButtonTitles.count; i++) {
                    [ADAlertView addButtonWithTitle:otherButtonTitles[i]];
                }
                
                ADAlertView.cancelButtonIndex=[ADAlertView addButtonWithTitle:cancelButtonTitle];
                
                self.cancelButtonIndex=ADAlertView.cancelButtonIndex;
                
            }
            
            self.delegate=delegate;
            
            if (delegate!=nil && [delegate isKindOfClass:[UIViewController class]]) {
                viewController=delegate;
            } else {
                viewController=[[UIApplication sharedApplication] keyWindow].rootViewController;
                
                while ([viewController isKindOfClass:[UINavigationController class]] || [viewController isKindOfClass:[UITabBarController class]]) {
                    if ([viewController isKindOfClass:[UINavigationController class]]) {
                        viewController=[(UINavigationController*) viewController visibleViewController];
                    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
                        viewController=[(UITabBarController*)viewController selectedViewController];
                    }
                }
            }
            
            if (_autoDetectAlert==nil) {
                _autoDetectAlert=self;
            }
        });
        
        return self;
    }
}

+ (instancetype) initWithTitle:(NSString *)title message:(NSString *)message buttonActionBlock:(AutoDetectAlertViewButtonAction)buttonActions cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    NSMutableArray *btnTitles = [NSMutableArray array];
    va_list args;
    va_start(args, otherButtonTitles);
    
    while (otherButtonTitles != nil) {
        [btnTitles addObject:otherButtonTitles];
        
        otherButtonTitles = va_arg(args, NSString*);
    }
    
    return [[[self class] alloc] initTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:btnTitles buttonActionBlock:buttonActions];
}

- (id) initTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles buttonActionBlock:(AutoDetectAlertViewButtonAction)buttonActions {
    
    
    @autoreleasepool {
        
        self=[super init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            self.alertViewButtonAction = buttonActions;
            
            if ([UIAlertController class]) {
                
                ADAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                for (int i = 0; i < otherButtonTitles.count; i++) {
                    UIAlertAction *act=[UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        if (self.alertViewButtonAction) {
                            self.alertViewButtonAction(self, i);
                        }
                        _autoDetectAlert=nil;
                        ADAlertController=nil;
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ADAlertController addAction:act];
                    });
                    
                }
                
                UIAlertAction *act=[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                    if (self.alertViewButtonAction) {
                        self.alertViewButtonAction(self, -1);
                    }
                    _autoDetectAlert=nil;
                    ADAlertController=nil;
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ADAlertController addAction:act];
                });
                
                
                self.cancelButtonIndex=-1;
                
            } else {
                
                ADAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                
                for (int i = 0; i < otherButtonTitles.count; i++) {
                    [ADAlertView addButtonWithTitle:otherButtonTitles[i]];
                }
                
                ADAlertView.cancelButtonIndex=[ADAlertView addButtonWithTitle:cancelButtonTitle];
                
                self.cancelButtonIndex=ADAlertView.cancelButtonIndex;
                
            }
            
            self.delegate=nil;
            
            viewController=[[UIApplication sharedApplication] keyWindow].rootViewController;
            
            while ([viewController isKindOfClass:[UINavigationController class]] || [viewController isKindOfClass:[UITabBarController class]]) {
                if ([viewController isKindOfClass:[UINavigationController class]]) {
                    viewController=[(UINavigationController*) viewController visibleViewController];
                } else if ([viewController isKindOfClass:[UITabBarController class]]) {
                    viewController=[(UITabBarController*)viewController selectedViewController];
                }
            }
            
            if (_autoDetectAlert==nil) {
                _autoDetectAlert=self;
            }
        });
        
    }
    
    return self;
}

- (void) setAlertViewStyle:(AutoDetectAlertViewStyle)alertViewStyle {
    
    _alertViewStyle=alertViewStyle;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([UIAlertController class]) {
            
            switch (alertViewStyle) {
                    
                case ADAlertStyleDefault:
                    
                    break;
                case ADAlertStylePlainTextInput: {
                    [ADAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.tag=ADAlertLoginTextField;
                    }];
                }
                    break;
                case ADAlertStyleSecureTextInput: {
                    [ADAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.tag=ADAlertLoginTextField;
                    }];
                }
                    break;
                case ADAlertStyleLoginAndPasswordInput: {
                    [ADAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = NSLocalizedString(@"Login", @"Login");
                        textField.tag=ADAlertLoginTextField;
                    }];
                    
                    [ADAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = NSLocalizedString(@"Password", @"Password");
                        textField.secureTextEntry = YES;
                        textField.tag=ADAlertPasswordTextField;
                    }];
                }
                    break;
                default:
                    break;
            }
        } else {
            
            ADAlertView.alertViewStyle = (UIAlertViewStyle)alertViewStyle;
        }
    });
    
}

- (UITextField*) textFieldAtIndex:(NSInteger)index {
    
    if ([UIAlertController class]) {
        
        switch (_alertViewStyle) {
                
            case ADAlertStyleDefault:
                
                break;
            case ADAlertStylePlainTextInput: {
                if (index==ADAlertLoginTextField) {
                    return ADAlertController.textFields[index];
                } else {
                    return nil;
                }
            }
                break;
            case ADAlertStyleSecureTextInput: {
                if (index==ADAlertLoginTextField) {
                    return ADAlertController.textFields[index];
                } else {
                    return nil;
                }
            }
                break;
            case ADAlertStyleLoginAndPasswordInput: {
                if (index<=ADAlertPasswordTextField) {
                    return ADAlertController.textFields[index];
                } else {
                    return nil;
                }
            }
                break;
            default:
                break;
        }
    } else {
        switch (_alertViewStyle) {
                
            case ADAlertStyleDefault:
                
                break;
            case ADAlertStylePlainTextInput: {
                if (index==ADAlertLoginTextField) {
                    return [ADAlertView textFieldAtIndex:index];
                } else {
                    return nil;
                }
            }
                break;
            case ADAlertStyleSecureTextInput: {
                if (index==ADAlertLoginTextField) {
                    return [ADAlertView textFieldAtIndex:index];
                } else {
                    return nil;
                }
            }
                break;
            case ADAlertStyleLoginAndPasswordInput: {
                if (index<=ADAlertPasswordTextField) {
                    return [ADAlertView textFieldAtIndex:index];
                } else {
                    return nil;
                }
            }
                break;
            default:
                break;
        }
    }
    
    return nil;
}

- (void) show {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([UIAlertController class]) {
            
            @autoreleasepool {
                
                [viewController presentViewController:ADAlertController animated:YES completion:nil];
                
            }
        } else {
            
            [ADAlertView show];
        }
        
    });
}

- (void) showInBlock:(AutoDetectAlertViewBlock)block {
    
    [self show];
    
    block();
}

- (void) dealloc {
//    NSLog(@"dealloc");
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([self.delegate respondsToSelector:@selector(alertView:didClickButtonAtIndex:)]) {
        
        [self.delegate alertView:self didClickButtonAtIndex:buttonIndex];
    } else if (self.alertViewButtonAction) {
        
        self.alertViewButtonAction(self, buttonIndex);
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    _autoDetectAlert=nil;
}

@end
