//
//  BCToDoItem.m
//  TodoList
//
//  Created by Nalinda Somasundara on 10/16/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import "BCTodoItem.h"

@implementation BCTodoItem

- (instancetype)initWithJSON:(NSString *)json
{
    self = [super init];
    
    if (self)
    {
        NSError *jsonError;
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&jsonError];
        self.text = dictionary[@"text"];
        self.completed = [dictionary[@"completed"] boolValue];
    }
    
    return self;
}

- (NSString *)JSONRepresentation
{
    NSDictionary *dictionary = @{@"text": self.text,
                                    @"completed": @(self.completed)};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:0
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
