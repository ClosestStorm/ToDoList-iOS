//
//  BCTodoService.h
//  TodoList
//
//  Created by Nalinda Somasundara on 10/17/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BitcasaSDK/File.h>

@class BCTodoItem;

// Type definition for service completion block
typedef void(^BCServiceCompleteSuccessBlock)(BOOL success);

/**
 *  Provides an interface to create, read, update and delete Todo Items.
 */
@interface BCTodoService : NSObject

/**
 *  Creates a folder to store Todo Items on Bitcasa if it does not exist.
 *
 *  @param handler Completion handler which executes upon success or failure.
 */
+ (void)createTodoFolderWithCompletion:(BCServiceCompleteSuccessBlock)handler;

/**
 *  Uploads the Todo Item and notifies on completion.
 *
 *  @param todoItem A BCTodoItem containing the information to be uploaded.
 *  @param handler  Completion handler which executes upon success or failure.
 */
+ (void)uploadTodoItem:(BCTodoItem *)todoItem completion:(void (^)(BCTodoItem *item, BOOL success))handler;

/**
 *  Retrieves an array of Bitcasa items which can be used to retrieve Todo Items.
 *
 *  @param handler Completion handler which executes returning Item objects and status.
 */
+ (void)retrieveItemsWithCompletion:(void (^)(NSArray* items))handler;

/**
 *  Retreives BCTodoItem using an Item object.
 *
 *  @param file    Bitcasa File object which has the Todo  details.
 *  @param handler Completion handler which executes once the Todo details has been fetched.
 */
+ (void)retrieveTodoItemFromFile:(File *)file completion:(void (^)(BCTodoItem *item))handler;

/**
 *  Deletes Todo Item.
 *
 *  @param todoItem Todo Item to be deleted.
 *  @param handler Completion handler which executes upon success or failure of the deletion.
 */
+ (void)deleteTodoItem:(BCTodoItem *)todoItem completion:(void (^)(BCTodoItem *item, BOOL success))handler;

@end
