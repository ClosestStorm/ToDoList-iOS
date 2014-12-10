//
//  BCCredentialsService.h
//  todolist
//
//  Created by Nalinda Somasundara on 11/1/14.
//
//

#import <Foundation/Foundation.h>

@interface BCCredentialsService : NSObject

// Username
@property (readonly) NSString *username;

/**
 *  Authenticates user on Bitcasa and updates PhotoShare user database.
 *
 *  @param username   Login username.
 *  @param password   Login password.
 *  @param completion Executes upon success or failure with the status.
 */
- (void)signInWithUsername:(NSString *)username
               andPassword:(NSString *)password
                completion:(void (^)(BOOL success))completion;

/**
 *  Whether user is authenticated
 *
 *  @return Returns YES, if the user is authenticated; otherwise NO.
 */
@property (nonatomic, getter=isAuthenticated, readonly) BOOL authenticated;

/**
 *  Clear Authunticated user data
 */
- (void)clearAuthKey;

/**
 *  User registration.
 *
 *  @param username   Login username.
 *  @param password   Login password.
 *  @param firstName  User first name.
 *  @param lastName   User last name.
 *  @param completion Executes upon success or failure with the status.
 */
- (void)signUpWithUsername:(NSString *)username
                  password:(NSString *)password
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                completion:(void (^)(BOOL success))completion;

@end
