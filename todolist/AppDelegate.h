//
//  AppDelegate.h
//  todolist
//
//  Created by Chathurka on 10/13/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCCredentialsService.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BCCredentialsService *credentialService;

@end

