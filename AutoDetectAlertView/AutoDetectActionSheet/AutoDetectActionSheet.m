//
//  AutoDetectActionSheet.m
//  AutoDetectAlertView
//
//  Created by 吳宥逵 on 2015/8/4.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "AutoDetectActionSheet.h"

#define upIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) ? YES : NO

AutoDetectActionSheet *_autoDetectActionSheet=nil;

@interface AutoDetectActionSheet () {
    
    UIAlertController *ADActionSheetController;
    
    UIActionSheet *ADActionSheet;
    
    __weak UIViewController *viewController;
}

@end

@implementation AutoDetectActionSheet

+ (instancetype) initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    
    return [[[self class] alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles];
}

- (id) initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    
    @autoreleasepool {
        
        self=[super init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if (upIOS8) {
                
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
                if ([viewController isKindOfClass:[UINavigationController class]]) {
                    viewController = [(UINavigationController*) viewController visibleViewController];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (upIOS8) {
            [self performSelector:@selector(presentViewController) withObject:nil afterDelay:0.0];
        } else {
            [ADActionSheet showInView:viewController.view];
        }
    });
}

- (void) presentViewController {
    @autoreleasepool {
        [viewController presentViewController:ADActionSheetController animated:YES completion:nil];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:didClickButtonAtIndex:withButtonTitle:)]) {
        [self. delegate actionSheet:self didClickButtonAtIndex:buttonIndex withButtonTitle:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    if (_autoDetectActionSheet==nil) {
        _autoDetectActionSheet=self;
    }
}

@end
