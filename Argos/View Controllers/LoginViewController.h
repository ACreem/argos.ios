//
//  LoginViewController.h
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "LoginView.h"

@interface LoginViewController : UIViewController <LoginViewDelegate, UITextFieldDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
