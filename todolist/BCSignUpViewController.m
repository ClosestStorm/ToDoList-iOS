//
//  BCSignUpViewController.m
//  TodoList
//
//  Created by Chathurka on 11/20/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import "BCSignUpViewController.h"
#import "BCTodoService.h"
#import "BCUIButtonEventTracking.h"

@implementation BCSignUpViewController
{
    UIActivityIndicatorView *_activityIndicator;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.username.delegate = self;
    self.password.delegate = self;
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.backgroundColor = [UIColor whiteColor];
    _activityIndicator.hidden = YES;
    
    [self.view addSubview:_activityIndicator];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(cancel:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Registration"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(signUp:)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cancel:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUp:(UIButton *)sender
{
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [_credentialService signUpWithUsername:self.username.text
                                  password:self.password.text
                                 firstName:self.firstName.text
                                  lastName:self.lastName.text
                                completion:^(BOOL success) {
                                    
                                if(success)
                                {
                                    [self.buttonDelegate didSelectSignUpButtonWithUsername:self.username.text password:self.password.text];
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                        
                                }
                                else
                                {
                                    [self showAlertWithMessage:@"Registration up Error."];
                                }
                                    
            [_activityIndicator stopAnimating];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TodoList"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder)
    {
        [nextResponder becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self performSelector:@selector(signUp:)withObject:nil];
    }
    
    return NO;
}

@end
