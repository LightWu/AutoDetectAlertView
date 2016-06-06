//
//  AutoDetectActionSheet.m
//  AutoDetectAlertView
//
//  Created by 吳宥逵 on 2015/8/4.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "AutoDetectActionSheet.h"

AutoDetectActionSheet *_autoDetectActionSheet=nil;

@interface AutoDetectActionSheet () {
    
    UIAlertController *ADActionSheetController;
    
    UIActionSheet *ADActionSheet;
    
    __weak UIViewController *viewController;
}

@property (nonatomic, copy) AutoDetectActionSheetBlock actionSheetBlock;

@end

@implementation AutoDetectActionSheet

+ (instancetype) initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    
    return [[[self class] alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles];
}

- (id) initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    
    @autoreleasepool {
        
        self=[super init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if ([UIAlertController class]) {
                
                ADActionSheetController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
                
                for (int i = 0; i < otherButtonTitles.count; i++) {
                    UIAlertAction *act=[UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        if ([self.delegate respondsToSelector:@selector(actionSheet:didClickButtonAtIndex:withButtonTitle:)]) {
                            [self.delegate actionSheet:self didClickButtonAtIndex:i withButtonTitle:action.title];
                        }
                        _autoDetectActionSheet=nil;
                        ADActionSheetController=nil;
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ADActionSheetController addAction:act];
                    });
                }
                
                if (destructiveButtonTitle!=nil && ![destructiveButtonTitle isEqualToString:@""]) {
                    
                    self.destructiveButtonIndex=ADActionSheetController.actions.count;
                    
                    UIAlertAction *act=[UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        if ([self.delegate respondsToSelector:@selector(actionSheet:didClickButtonAtIndex:withButtonTitle:)]) {
                            [self.delegate actionSheet:self didClickButtonAtIndex:[ADActionSheetController.actions count] withButtonTitle:action.title];
                        }
                        _autoDetectActionSheet=nil;
                        ADActionSheetController=nil;
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ADActionSheetController addAction:act];
                    });
                }
                
                UIAlertAction *act=[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    if ([self.delegate respondsToSelector:@selector(actionSheet:didClickButtonAtIndex:withButtonTitle:)]) {
                        [self.delegate actionSheet:self didClickButtonAtIndex:-1 withButtonTitle:action.title];
                    }
                    _autoDetectActionSheet=nil;
                    ADActionSheetController=nil;
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ADActionSheetController addAction:act];
                });
                
                self.cancelButtonIndex=-1;
                
            } else {
                
                ADActionSheet=[[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     for (int i = 0; i < otherButtonTitles.count; i++) {
                         [ADActionSheet addButtonWithTitle:otherButtonTitles[i]];
                     }
                     
                     if (destructiveButtonTitle!=nil && ![destructiveButtonTitle isEqualToString:@""]) {
                         ADActionSheet.destructiveButtonIndex=[ADActionSheet addButtonWithTitle:destructiveButtonTitle];
                         
                     }
                     
                     ADActionSheet.cancelButtonIndex=[ADActionSheet addButtonWithTitle:cancelButtonTitle];
                     
                 });
                
                self.destructiveButtonIndex=ADActionSheet.destructiveButtonIndex;
                self.cancelButtonIndex=ADActionSheet.cancelButtonIndex;
                
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
            
            if (_autoDetectActionSheet==nil) {
                _autoDetectActionSheet=self;
            }
        });
        
        return self;
    }
}

+ (instancetype) initWithTitle:(NSString *)title message:(NSString *)message buttonAction:(AutoDetectActionSheetButtonAction)buttonActions cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    
    return [[[self class] alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles buttonAction:buttonActions];
}

- (id) initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles buttonAction:(AutoDetectActionSheetButtonAction)buttonActions {
    @autoreleasepool {
        
        self=[super init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            self.actionSheetButtonAction = buttonActions;
            
            if ([UIAlertController class]) {
                
                ADActionSheetController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
                
                for (int i = 0; i < otherButtonTitles.count; i++) {
                    UIAlertAction *act=[UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        if (self.actionSheetButtonAction) {
                            self.actionSheetButtonAction(self, i, action.title);
                        }
                        _autoDetectActionSheet=nil;
                        ADActionSheetController=nil;
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ADActionSheetController addAction:act];
                    });
                }
                
                if (destructiveButtonTitle!=nil && ![destructiveButtonTitle isEqualToString:@""]) {
                    
                    self.destructiveButtonIndex=ADActionSheetController.actions.count;
                    
                    UIAlertAction *act=[UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        
                        if (self.actionSheetButtonAction) {
                            self.actionSheetButtonAction(self, [ADActionSheetController.actions count], act.title);
                        }
                        
                        _autoDetectActionSheet=nil;
                        ADActionSheetController=nil;
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ADActionSheetController addAction:act];
                    });
                }
                
                UIAlertAction *act=[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                    if (self.actionSheetButtonAction) {
                        self.actionSheetButtonAction(self, -1, act.title);
                    }
                    _autoDetectActionSheet=nil;
                    ADActionSheetController=nil;
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ADActionSheetController addAction:act];
                });
                
                self.cancelButtonIndex=-1;
                
            } else {
                
                ADActionSheet=[[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int i = 0; i < otherButtonTitles.count; i++) {
                        [ADActionSheet addButtonWithTitle:otherButtonTitles[i]];
                    }
                    
                    if (destructiveButtonTitle!=nil && ![destructiveButtonTitle isEqualToString:@""]) {
                        ADActionSheet.destructiveButtonIndex=[ADActionSheet addButtonWithTitle:destructiveButtonTitle];
                        
                    }
                    
                    ADActionSheet.cancelButtonIndex=[ADActionSheet addButtonWithTitle:cancelButtonTitle];
                    
                });
                
                self.destructiveButtonIndex=ADActionSheet.destructiveButtonIndex;
                self.cancelButtonIndex=ADActionSheet.cancelButtonIndex;
                
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
            
            if (_autoDetectActionSheet==nil) {
                _autoDetectActionSheet=self;
            }
        });
        
        return self;
    }
}

- (void) dealloc {
    NSLog(@"dealloc");
}

- (void) show {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([UIAlertController class]) {
            
            @autoreleasepool {
                
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                    
                    // show in center, custom here when show actionsheet in another position.
                    ADActionSheetController.popoverPresentationController.sourceView = viewController.view;
                    ADActionSheetController.popoverPresentationController.sourceRect = viewController.view.bounds;
                    ADActionSheetController.popoverPresentationController.permittedArrowDirections=0;
                }
                [viewController presentViewController:ADActionSheetController animated:YES completion:^{
                    if (self.actionSheetBlock) {
                        self.actionSheetBlock();
                    }
                }];
            }
        } else {
            
            [ADActionSheet showInView:viewController.view];
            
            if (self.actionSheetBlock) {
                self.actionSheetBlock();
            }
        }
    });
}

- (void) showInBlock:(AutoDetectActionSheetBlock)block {
    
    self.actionSheetBlock=block;
    
    [self show];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(actionSheet:didClickButtonAtIndex:withButtonTitle:)]) {
            [self. delegate actionSheet:self didClickButtonAtIndex:buttonIndex withButtonTitle:[actionSheet buttonTitleAtIndex:buttonIndex]];
        } else if (self.actionSheetButtonAction) {
            self.actionSheetButtonAction(self, buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
        }
    }
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    _autoDetectActionSheet=nil;
}

@end
