//
//  LoginViewController.h
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
