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

- (IBAction) test:(id)sender {
    /*
    AutoDetectAlertView *test=[[AutoDetectAlertView alloc] initTitle:@"MainTitle" message:@"subTitle" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:@[@"0", @"1", @"2"]];
    
    [test setAlertViewStyle:ADAlertStyleLoginAndPasswordInput];
    
    [test show];
     */
    
    
    AutoDetectActionSheet *test=[AutoDetectActionSheet initWithTitle:@"MainTitle" message:@"message" delegate:self cancelButtonTitle:@"ok" destructiveButtonTitle:@"des" otherButtonTitles:@[@"1",@"2",@"3"]];
    [test show];
}

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
