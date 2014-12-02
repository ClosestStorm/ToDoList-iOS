//
//  BCLoginViewController.h
//  todolist
//
//  Created by Chathurka on 10/13/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCUIButtonEventTracking.h"
#import "BCCredentialsService.h"

@class Session;

@interface BCLoginViewController : UIViewController <UITextFieldDelegate, BCUIButtonEventTracking>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) BCCredentialsService* credentialService;

- (IBAction)signIn:(UIButton *)sender;
- (IBAction)signUp:(UIButton *)sender;

@end
