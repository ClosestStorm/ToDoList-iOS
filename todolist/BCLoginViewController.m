//
//  BCLoginViewController.m
//  todolist
//
//  Created by Chathurka on 10/13/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <BitcasaSDK/Session.h>
#import "BCLoginViewController.h"
#import "BCTodoListViewController.h"
#import "BCPlistReader.h"
#import "AppDelegate.h"
#import "BCTodoItem.h"
#import "BCSignUpViewController.h"

@implementation BCLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userName.delegate = self;
    self.password.delegate = self;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)signIn:(UIButton *)sender
{
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    
    if (_userName.text.length > 0 && _password.text.length > 0)
    {
        [_credentialService signInWithUsername:_userName.text
                                   andPassword:_password.text
                                    completion:^(BOOL success)
        {
             if (success)
             {
                 _userName.text = @"";
                 _password.text = @"";
                 
                 [self navigateToTodoList];
             }
             else
             {
                 [self showalertWithMessage:@"Login Error."];
             }
         }];

    }
    else
    {
         [self showalertWithMessage:@"Empty username or password."];
    }
}

- (IBAction)signUp:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BCSignUpViewController *signUpViewController = (BCSignUpViewController *)[storyboard instantiateViewControllerWithIdentifier:@"signUpScreen"];
    signUpViewController.credentialService = _credentialService;
    signUpViewController.buttonDelegate = self;
    
    UINavigationController *signUpNavigationController = [[UINavigationController alloc] initWithRootViewController:signUpViewController];
    [self presentViewController:signUpNavigationController animated:YES completion:nil];
}

#pragma mark - BCUIButtonEventTracking

- (void)didSelectSignUpButtonWithUsername:(NSString *)username password:(NSString *)password
{
    self.userName.text = username;
    self.password.text = password;
    
    [self signIn:nil];
}

#pragma mark - private methods

/**
 *  Navigates to ToDoList View.
 */
- (void)navigateToTodoList
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BCTodoListViewController *todoListViewController = (BCTodoListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"todoListScreen"];
    
    [self.navigationController pushViewController:todoListViewController animated:YES];
}

/**
 *  Shows the alert according to given message.
 *
 *  @param message The message to show.
 */
- (void)showalertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TodoList"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

/**
 *  This gets triggered when the keyboard is shown or hidden.
 *
 *  @param notification An UIKeyboardWillChangeFrameNotification object.
 */
- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    newFrame.origin.y += 100;
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
}

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
        [self performSelector:@selector(signIn:)withObject:nil];
    }
    
    return NO;
}

@end
