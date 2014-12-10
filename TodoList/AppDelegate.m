//
//  AppDelegate.m
//  todolist
//
//  Created by Chathurka on 10/13/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <BitcasaSDK/Session.h>
#import "AppDelegate.h"
#import "BCLoginViewController.h"
#import "BCPlistReader.h"
#import "BCCredentialsService.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _credentialService = [[BCCredentialsService alloc] init];
    
    if (![_credentialService isAuthenticated])
    {
        [self showLoginScreen];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Methods

/**
 * Show the Login Screen if user is still login
 */
- (void)showLoginScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BCLoginViewController *loginViewController = (BCLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    loginViewController.credentialService = _credentialService;
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:loginViewController];

    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
}

@end
