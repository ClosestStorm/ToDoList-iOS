//
//  BCPlistReader.h
//  TodoList
//
//  Created by Chathurka on 10/14/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCPlistReader : NSObject

/**
 *  Inisialization with Plist File name.
 *
 *  @param fileName Plist File name

 *  @return BCPlistReader type object
 */

- (id)initWithFileName:(NSString *) fileName;


/**
 *  Get App config plist value for key.
 *
 *  @param key Plist key.
 *
 *  @return Value for key
 */

- (id)appConfigValueForKey:(NSString *)key;

@end
