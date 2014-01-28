//
//  LoginViewController.h
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;

@end
