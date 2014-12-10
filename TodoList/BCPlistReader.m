//
//  BCPlistReader.m
//  TodoList
//
//  Created by Chathurka on 10/14/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import "BCPlistReader.h"

@implementation BCPlistReader
{
    NSString *_fileName;
}

- (instancetype)initWithFileName:(NSString *) fileName
{
    if (self = [super init])
    {
        _fileName = fileName;
    }
    
    return self;
}

- (id)appConfigValueForKey:(NSString *)key
{
    if (key.length > 0)
    {
        return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_fileName ofType:@"plist"]][key];
    }
    
    return nil;
}

@end
