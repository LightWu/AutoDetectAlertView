//
//  ViewController.m
//  AutoDetectAlertView
//
//  Created by 吳宥逵 on 2015/7/17.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "ViewController.h"
#import "AutoDetectAlertView.h"
#import "AutoDetectActionSheet.h"

@interface ViewController () <AutoDetectAlertViewDelegate, AutoDetectActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction) showAlertWithDelegate:(id)sender {
    
    AutoDetectAlertView *test=[AutoDetectAlertView initWithTitle:@"AlertView" message:@"With Delegate" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@[@"0", @"1", @"2"]];
    
    [test setAlertViewStyle:ADAlertStyleLoginAndPasswordInput];
    
    [test showInBlock:^{
        NSLog(@"finished");
    }];
    
}

- (IBAction) showAlertWithBlock:(id)sender {
    
    [[AutoDetectAlertView initWithTitle:@"AlertView" message:@"With Block"cancelButtonTitle:@"ok" otherButtonTitles:@[@"0", @"1", @"2"] buttonActionBlock:^(AutoDetectAlertView *alertView, NSInteger index) {
        
        NSLog(@"clicked button index : %d", index);
        
        NSString *str1=[alertView textFieldAtIndex:ADAlertLoginTextField].text;
        NSString *str2=[alertView textFieldAtIndex:ADAlertPasswordTextField].text;
        
        NSLog(@"str1 :%@", str1);
        NSLog(@"str2 :%@", str2);
    }] show];
}

- (IBAction) showActionSheetWithDelegate:(id)sender {
    
    AutoDetectActionSheet *test=[AutoDetectActionSheet initWithTitle:@"ActionSheet" message:@"With Delegate" delegate:self cancelButtonTitle:@"ok" destructiveButtonTitle:@"des" otherButtonTitles:@[@"1",@"2",@"3"]];
    
    [test showInBlock:^{
        NSLog(@"finished");
    }];
}

- (IBAction) showActionSheetWithBlock:(id)sender {
    [[AutoDetectActionSheet initWithTitle:@"ActionSheet" message:@"With Block" cancelButtonTitle:@"ok" destructiveButtonTitle:@"des" otherButtonTitles:@[@"1", @"2", @"3"] buttonAction:^(AutoDetectActionSheet *actionSheet, NSInteger buttonIndex, NSString *buttonTitle) {
        
        NSLog(@"%d, %@", index, buttonTitle);
        
    }] show];
}

#pragma mark - Use Delegate

- (void) alertView:(AutoDetectAlertView*)alertView didClickButtonAtIndex:(NSInteger)index {
    NSLog(@"clicked button index : %d", index);
    
    NSString *str1=[alertView textFieldAtIndex:ADAlertLoginTextField].text;
    NSString *str2=[alertView textFieldAtIndex:ADAlertPasswordTextField].text;
    
    NSLog(@"str1 :%@", str1);
    NSLog(@"str2 :%@", str2);
}

- (void) actionSheet:(AutoDetectActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)index withButtonTitle:(NSString *)buttonTitle {
    NSLog(@"%d, %@", index, buttonTitle);
}

@end
