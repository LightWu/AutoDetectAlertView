//
//  AutoDetectActionSheet.h
//  AutoDetectAlertView
//
//  Created by 吳宥逵 on 2015/8/4.
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

@protocol AutoDetectActionSheetDelegate;

NS_CLASS_AVAILABLE_IOS(6_0) @interface AutoDetectActionSheet : NSObject <UIActionSheetDelegate>

@property (assign, nonatomic) id <AutoDetectActionSheetDelegate> delegate;

@property (nonatomic) NSInteger cancelButtonIndex;

@property (nonatomic) NSInteger destructiveButtonIndex;

@property (nonatomic) NSInteger tag;

+ (ADA_INSTANCETYPE) initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles;
- (id) initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitles:(NSArray*)otherButtonTitles;

- (void) show;

@end

@protocol AutoDetectActionSheetDelegate <NSObject>

@required
- (void) actionSheet:(AutoDetectActionSheet*)actionSheet didClickButtonAtIndex:(NSInteger)index withButtonTitle:(NSString*)buttonTitle;

@end
