//
//  LoginView.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

@protocol LoginViewDelegate
- (void)login:(id)sender;
- (void)togglePrimaryButton:(id)sender;
@end

@interface LoginView : UIView

@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *primaryButton;
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, weak) id <LoginViewDelegate> delegate;

@end
