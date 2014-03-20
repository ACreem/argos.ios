//
//  LoginView.m
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "LoginView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat frameWidth = CGRectGetWidth(frame);
        CGFloat frameHeight = CGRectGetHeight(frame);
        
        CGFloat buttonWidth = 100;
        CGFloat mainButtonWidth = frameWidth;
        CGFloat buttonHeight = 60;
        CGFloat fieldWidth = frameWidth;
        CGFloat fieldHeight = 50;
        
        self.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0];
        
        _formView = [[UIView alloc] initWithFrame:frame];
        
        // Create buttons
        UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        signupButton.frame = CGRectMake(frameWidth - buttonWidth, frameHeight - buttonHeight, buttonWidth, buttonHeight);
        [signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
        signupButton.tintColor = [UIColor mutedColor];
        signupButton.titleLabel.font = [UIFont mediumFontForSize:12.0];
        [signupButton addTarget:_delegate action:@selector(togglePrimaryButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:signupButton];
        
        UIButton *forgotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        forgotButton.frame = CGRectMake(20, frameHeight - buttonHeight, buttonWidth, buttonHeight);
        [forgotButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
        forgotButton.tintColor = [UIColor mutedColor];
        forgotButton.titleLabel.font = [UIFont mediumFontForSize:12.0];
        [forgotButton addTarget:_delegate action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgotButton];
        
        // Use same background image as launch, but with a transparent background.
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch"]];
        logo.frame = frame;
        [_formView addSubview:logo];
        
        // Initialization code
        _primaryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _primaryButton.frame = CGRectMake(frameWidth/2 - mainButtonWidth/2, CGRectGetMinY(signupButton.frame) - signupButton.frame.size.height, mainButtonWidth, buttonHeight);
        [_primaryButton setTitle:@"Login" forState:UIControlStateNormal];
        _primaryButton.titleLabel.font = [UIFont lightFontForSize:18.0];
        _primaryButton.tintColor = [UIColor whiteColor];
        _primaryButton.backgroundColor = [UIColor secondaryColor];
        [_primaryButton addTarget:_delegate action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [_formView addSubview:_primaryButton];
        
        // Create text fields
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(frameWidth/2 - fieldWidth/2, CGRectGetMinY(_primaryButton.frame) - fieldHeight, fieldWidth, fieldHeight)];
        [_passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _passwordField.secureTextEntry = YES;
        _passwordField.font = [UIFont lightFontForSize:16.0];
        _passwordField.placeholder = @"password";
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.textAlignment = NSTextAlignmentCenter;
        [_formView addSubview:_passwordField];
        
        _emailField = [[UITextField alloc] initWithFrame:CGRectMake(frameWidth/2 - fieldWidth/2, CGRectGetMinY(_passwordField.frame) - fieldHeight - 1, fieldWidth, fieldHeight)];
        [_emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _emailField.font = [UIFont lightFontForSize:16.0];
        _emailField.placeholder = @"email";
        _emailField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailField.returnKeyType = UIReturnKeyNext;
        _emailField.textAlignment = NSTextAlignmentCenter;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, fieldHeight-1, frameWidth, 1);
        bottomBorder.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor;
        [_emailField.layer addSublayer:bottomBorder];
        [_formView addSubview:_emailField];
        
        [self addSubview:_formView];
    }
    return self;
}

@end
