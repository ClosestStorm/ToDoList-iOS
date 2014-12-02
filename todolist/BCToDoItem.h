//
//  BCToDoItem.h
//  TodoList
//
//  Created by Nalinda Somasundara on 10/16/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class File;

/**
 *  Represents a To Do Item in the list.
 */
@interface BCTodoItem : NSObject

// Description of the ToDo.
@property (nonatomic, copy) NSString *text;

// A Boolean value which determines the completed state of this item.
@property (nonatomic, assign) BOOL completed;

// The file which the todo details are stored.
@property (nonatomic, strong) File *file;

// Indicates whether the text has been modified and needs to be uploaded.
@property (nonatomic, assign) BOOL textModified;

/**
 *  Initializes BCTodoItem from given JSON formatted string.
 *
 *  @param json A string in JSON format.
 *
 *  @return Initialized BCTodoItem object.
 */
- (id)initWithJSON:(NSString *)json;

/**
 *  Returns JSON Representation of the defined properties.
 *
 *  @return A string in JSON format.
 */
- (NSString *)JSONRepresentation;

@end
