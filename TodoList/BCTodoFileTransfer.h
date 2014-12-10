//
//  BCTodoFileTransfer.h
//  TodoList
//
//  Created by Nalinda Somasundara on 10/19/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BitcasaSDK/BitcasaAPI.h>
@class BCTodoItem;
@class File;

/**
 *  Implementation of TransferDelegate methods which is called when an upload or download
 *  is completed from/to Bitcasa.
 */
@interface BCTodoFileTransfer : NSObject <TransferDelegate>

/**
 *  Reference to completion block to be excuted when the upload is completed.
 */
@property (nonatomic, copy) void (^uploadCompletion)(BCTodoItem *todoItem, File *file, NSError *error);

/**
 *  Reference to completion block to be executed when the download is completed.
 */
@property (nonatomic, copy) void (^downloadCompletion)(File *file, NSString *itemPath, NSURL *locationURL, BOOL cached, NSError *error);

/**
 *  The To Do item associated with upload process.
 */
@property (nonatomic, strong) BCTodoItem *todoItem;

/**
 *  The File assocaited with the download process.
 */
@property (nonatomic, strong) File *file;

@end
