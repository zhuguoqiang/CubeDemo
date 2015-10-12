//
//  LoginViewController.m
//  CubeDemo
//
//  Created by guoqiangzhu on 15/8/13.
//  Copyright (c) 2015年 CubeTeam. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - IBAction

- (IBAction)fireLogin:(id)sender
{
    TabBarController *tabController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:tabController animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:tabController animated:YES];
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TouchMethod

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end
