//
//  BCCredentialsService.m
//  todolist
//
//  Created by Nalinda Somasundara on 11/1/14.
//
//

#import <BitcasaSDK/Credentials.h>
#import <BitcasaSDK/Session.h>
#import "BCCredentialsService.h"
#import "BCPlistReader.h"

@implementation BCCredentialsService
{
    Session *_session;
    
    NSMutableURLRequest *_userCreationRequest;
    NSMutableDictionary *_userCreationHttpBody;
    
    NSMutableURLRequest *_userAuthRequest;
    NSMutableDictionary *_userAuthHttpBody;
}

// Key used to store username in User Defaults
static NSString *const usernameKey = @"Username Key";

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        BCPlistReader *plistReader = [[BCPlistReader alloc] initWithFileName:@"BitcasaConfig"];
        
        NSString *apiServerUrl = [plistReader appConfigValueForKey:@"BC_API_SERVER_URL"];
        NSString *clientId = [plistReader appConfigValueForKey:@"BC_CLIENT_ID"];
        NSString *secret = [plistReader appConfigValueForKey:@"BC_SECRET"];
        NSString *userRegistrationUrl = [plistReader appConfigValueForKey:@"BC_USER_REGISTRATION_URL"];
        NSString *userAuthUrl = [plistReader appConfigValueForKey:@"BC_USER_AUTH_URL"];
        
        _session =  [[Session alloc] initWithServerURL:apiServerUrl clientId:clientId clientSecret:secret];
        
        // User Creation HTTP Request & HTTP Body
        _userCreationRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userRegistrationUrl]];
        _userCreationRequest.HTTPMethod = @"POST";
        [_userCreationRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_userCreationRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _userCreationHttpBody = [NSMutableDictionary dictionary];
        
        // User Auth HTTP Request & HTTP Body
        _userAuthRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userAuthUrl]];
        _userAuthRequest.HTTPMethod = @"POST";
        [_userAuthRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_userAuthRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _userAuthHttpBody = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)signInWithUsername:(NSString *)username
               andPassword:(NSString *)password
                completion:(void (^)(BOOL))completion
{
    _userAuthHttpBody[@"username"] = username;
    _userAuthHttpBody[@"password"] = password;
    
    NSError *jsonError = nil;
    _userAuthRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:_userAuthHttpBody options:kNilOptions error:&jsonError];
    
    [NSURLConnection sendAsynchronousRequest:_userAuthRequest
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([response respondsToSelector:@selector(statusCode)]) {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   if (httpResponse.statusCode == 200) {
                                       NSError *jsonError = nil;
                                       NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:kNilOptions
                                                                                                        error:&jsonError];
                                       if (!jsonError) {
                                           NSString *authToken = dataDictionary[@"auth_token"];
                                           [[Credentials sharedInstance] setAccessToken:authToken];
                                           completion(YES);
                                       }
                                       else {
                                           completion(NO);
                                       }

                                   }
                                   else {
                                       completion(NO);
                                   }
                               }
                               else {
                                   completion(NO);
                               }
                           }];
}

- (void)signUpWithUsername:(NSString *)username
                  password:(NSString *)password
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                completion:(void (^)(BOOL success))completion
{
    _userCreationHttpBody[@"username"] = username;
    _userCreationHttpBody[@"password"] = password;
    _userCreationHttpBody[@"first_name"] = firstName;
    _userCreationHttpBody[@"last_name"] = lastName;
    
    NSError *jsonError;
    _userCreationRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:_userCreationHttpBody options:kNilOptions error:&jsonError];
    
    [NSURLConnection sendAsynchronousRequest:_userCreationRequest
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([response respondsToSelector:@selector(statusCode)]) {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   if (httpResponse.statusCode == 201) {
                                       completion(YES);
                                   }
                                   else {
                                       completion(NO);
                                   }
                               }
                               else {
                                   completion(NO);
                               }
                           }];
}

- (BOOL)isAuthenticated
{
    return [_session isLinked];
}

- (void)clearAuthKey
{
    [_session unlink];
}

@end
