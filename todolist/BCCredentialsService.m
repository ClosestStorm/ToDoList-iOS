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

@interface BCCredentialsService ()

// User Access Token
@property (nonatomic, copy) NSString *userAccessToken;

// App Access Token
@property (nonatomic, copy) NSString *appAccessToken;

@end

@implementation BCCredentialsService
{
    Session *_session;
    NSMutableURLRequest *_userCreationRequest;
    NSMutableDictionary *_userCreationHttpBody;
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
        NSString *adminId = [plistReader appConfigValueForKey:@"BC_ADMIN_ID"];
        NSString *adminSecret = [plistReader appConfigValueForKey:@"BC_ADMIN_SECRET"];
        NSString *userRegistrationUrl = [plistReader appConfigValueForKey:@"BC_USER_REGISTRATION_URL"];
        
        _session =  [[Session alloc] initWithServerURL:apiServerUrl clientId:clientId clientSecret:secret];
        
         _userCreationRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userRegistrationUrl]];
        _userCreationRequest.HTTPMethod = @"POST";
        [_userCreationRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_userCreationRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        _userCreationHttpBody = [[NSMutableDictionary alloc] init];
        [_userCreationHttpBody setValue:apiServerUrl forKey:@"api_server"];
        [_userCreationHttpBody setValue:clientId forKey:@"client_id"];
        [_userCreationHttpBody setValue:secret forKey:@"secret_key"];
        [_userCreationHttpBody setValue:adminId forKey:@"admin_id"];
        [_userCreationHttpBody setValue:adminSecret forKey:@"admin_secret"];
    }
    
    return self;
}

- (void)signInWithUsername:(NSString *)username
               andPassword:(NSString *)password
                completion:(void (^)(BOOL))completion
{
    [_session authenticateWithUsername:username
                           andPassword:password
                            completion:^(BOOL success) {
                                completion(success);
                            }
     ];
}

- (void)signUpWithUsername:(NSString *)username
                  password:(NSString *)password
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                completion:(void (^)(BOOL success))completion
{
    [_userCreationHttpBody setValue:username forKey:@"username"];
    [_userCreationHttpBody setValue:password forKey:@"password"];
    [_userCreationHttpBody setValue:firstName forKey:@"first_name"];
    [_userCreationHttpBody setValue:lastName forKey:@"last_name"];
    
    NSError *jsonError;
    _userCreationRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:_userCreationHttpBody options:kNilOptions error:&jsonError];
    
    NSURLResponse *response;
    NSError *error;
    
    [NSURLConnection sendSynchronousRequest:_userCreationRequest returningResponse:&response error:&error];
    if ([response respondsToSelector:@selector(statusCode)])
    {
       completion([((NSHTTPURLResponse *)response) statusCode] == 201);
    }
    else
    {
        completion(NO);
    }
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
