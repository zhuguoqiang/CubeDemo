//
//  LoginViewController.h
//  CubeDemo
//
//  Created by guoqiangzhu on 15/8/13.
//  Copyright (c) 2015年 CubeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *tfDisplayName;
@property (strong, nonatomic) IBOutlet UITextField *tfAcount;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

@end
