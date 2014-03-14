//
//  LoginViewController.h
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "LoginView.h"

@class IIViewDeckController;

@interface LoginViewController : UIViewController <LoginViewDelegate, UITextFieldDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IIViewDeckController* deckController;

@end
