//
//  AutoDetectAlertView.m
//  AutoDetectAlertView
//
//  Created by 吳宥逵 on 2015/7/17.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "AutoDetectAlertView.h"
#import "AppDelegate.h"

#define upIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) ? YES : NO

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


+ (instancetype) initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles {
    
    return [[[self class] alloc] initTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}
 
- (id) initTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles {
    
    @autoreleasepool {
        
        self=[super init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if (upIOS8) {
                
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (int i = 0; i < otherButtonTitles.count; i++) {
                        [ADAlertView addButtonWithTitle:otherButtonTitles[i]];
                    }
                    
                    ADAlertView.cancelButtonIndex=[ADAlertView addButtonWithTitle:cancelButtonTitle];
                });
                
                self.cancelButtonIndex=ADAlertView.cancelButtonIndex;
                
            }
            
            self.delegate=delegate;
            
            if (delegate!=nil && [delegate isKindOfClass:[UIViewController class]]) {
                viewController=delegate;
            } else {
                if (upIOS8) {
                    viewController=[[UIApplication sharedApplication] keyWindow].rootViewController;
                }
            }
            
            if (_autoDetectAlert==nil) {
                _autoDetectAlert=self;
            }
            
            
            
        });
        
        return self;
    }
}

- (void) setAlertViewStyle:(AutoDetectAlertViewStyle)alertViewStyle {
    
    _alertViewStyle=alertViewStyle;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (upIOS8) {
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
            switch (alertViewStyle) {
                case ADAlertStyleDefault:
                    ADAlertView.alertViewStyle=UIAlertViewStyleDefault;
                    break;
                case ADAlertStylePlainTextInput:
                    ADAlertView.alertViewStyle=UIAlertViewStylePlainTextInput;
                    break;
                case ADAlertStyleSecureTextInput:
                    ADAlertView.alertViewStyle=UIAlertViewStyleSecureTextInput;
                    break;
                case ADAlertStyleLoginAndPasswordInput:
                    ADAlertView.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
                    break;
                default:
                    break;
            }
        }
    });
}

- (UITextField*) textFieldAtIndex:(NSInteger)index {
    
    if (upIOS8) {
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (upIOS8) {
            @autoreleasepool {
                
                [viewController presentViewController:ADAlertController animated:YES completion:nil];
                
            }
        } else {
            [ADAlertView show];
        }
        
    });
}

- (void) dealloc {
    NSLog(@"dealloc");
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.delegate respondsToSelector:@selector(alertView:didClickButtonAtIndex:)]) {
        [self.delegate alertView:self didClickButtonAtIndex:buttonIndex];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    _autoDetectAlert=nil;
}

@end
