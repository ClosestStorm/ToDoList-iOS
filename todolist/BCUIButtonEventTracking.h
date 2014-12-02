//
//  UIbuttonEventTracking.h
//  PhotoShare
//
//  Created by Chathurka on 10/24/14.
//
//

#import <Foundation/Foundation.h>
/**
 *  Identifing Button event tracking
 */
@protocol BCUIButtonEventTracking <NSObject>
@optional

/**
 *  Fire Event if sign up button is clicked.
 *
 *  @param username createdUsername.
 *  @param password password.
 */
- (void)didSelectSignUpButtonWithUsername:(NSString *)username password:(NSString *)password;

@end
