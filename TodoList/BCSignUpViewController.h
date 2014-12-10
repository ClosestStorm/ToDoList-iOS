//
//  BCSignUpViewController.h
//  TodoList
//
//  Created by Chathurka on 11/20/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCCredentialsService.h"

@protocol BCUIButtonEventTracking;

@interface BCSignUpViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *username;
//password Textfeild.
@property (strong, nonatomic) IBOutlet UITextField *password;
//first name Textfeild.
@property (strong, nonatomic) IBOutlet UITextField *firstName;
//last name Textfeild.
@property (strong, nonatomic) IBOutlet UITextField *lastName;
// Button delegate for sign up Button event.
@property (weak, nonatomic) NSObject<BCUIButtonEventTracking> *buttonDelegate;
//user credential service.
@property (strong, nonatomic) BCCredentialsService* credentialService;

@end
