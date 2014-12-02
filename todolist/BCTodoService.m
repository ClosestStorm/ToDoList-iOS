//
//  BCTodoService.m
//  TodoList
//
//  Created by Nalinda Somasundara on 10/17/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <BitcasaSDK/BitcasaAPI.h>
#import <BitcasaSDK/Container.h>
#import <BitcasaSDK/Folder.h>
#import <BitcasaSDK/File.h>
#import "BCTodoService.h"
#import "BCTodoItem.h"
#import "BCTodoFileTransfer.h"
#import "BCPlistReader.h"

// Holds the path to TodoList local temp folder
static NSURL *_todoLocalFolderURL;

// Holds the folder reference of the Todo List folder.
static Folder *_todoRemoteFolder;

static NSMutableArray *_delegates;

@implementation BCTodoService

- (id)init
{
    if (self = [super init])
    {
        _delegates = [NSMutableArray array];
    }
    
    return self;
}

+ (void)createTodoFolderWithCompletion:(BCServiceCompleteSuccessBlock)handler
{
    NSString *todoListFolderName = @"TodoList";
    
    // Create TodoList local folder in documents dir
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    _todoLocalFolderURL = [documentsURL URLByAppendingPathComponent:todoListFolderName isDirectory:YES];
    [[NSFileManager defaultManager] createDirectoryAtURL:_todoLocalFolderURL withIntermediateDirectories:YES attributes:nil error:NULL];
    
    // Create TodoList folder on Bitcasa
    Container *rootContainer = [[Container alloc] initRootContainer];
    
    [rootContainer listItemsWithCompletion:^(NSArray *items) {
        for (Item *obj in items) {
            if ([obj.name isEqualToString:todoListFolderName]) {
                _todoRemoteFolder = (Folder *)obj;
                break;
            }
        }
        
        if (_todoRemoteFolder == nil) {
            [rootContainer createFolder:todoListFolderName completion:^(Container *newDir) {
                _todoRemoteFolder = (Folder *)newDir;
                handler (_todoRemoteFolder != nil);
            }];
        }
        else {
            handler (_todoRemoteFolder != nil);
        }
    }];
}

+ (void)uploadTodoItem:(BCTodoItem *)todoItem completion:(void (^)(BCTodoItem *, BOOL))handler
{
    NSString *jsonString = [todoItem JSONRepresentation];
    
    if (jsonString)
    {
        NSString *fileName = nil;
        if ((todoItem.file != nil) && ([todoItem.file.name length] > 0))
        {
            fileName = todoItem.file.name;
        }
        else
        {
            fileName = [[NSUUID UUID] UUIDString];
        }
        
        NSURL *tempFileURL = [_todoLocalFolderURL URLByAppendingPathComponent:fileName];
        
        NSError *error = nil;
        [jsonString writeToURL:tempFileURL
                    atomically:NO
                      encoding:NSUTF8StringEncoding
                         error:&error];
        
        BCTodoFileTransfer *fileTransferDelegate = [[BCTodoFileTransfer alloc] init];
        __weak BCTodoFileTransfer *weakFTD = fileTransferDelegate;
        [_delegates addObject:fileTransferDelegate];
        
        weakFTD.uploadCompletion = ^(BCTodoItem *todoItem, File *file, NSError *error) {
            todoItem.file = file;
            handler(todoItem, error != nil);
            [_delegates removeObject:weakFTD];
        };
        
        fileTransferDelegate.todoItem = todoItem;
        
        if (todoItem.file != nil)
        {
            [todoItem.file deleteWithCompletion:^(BOOL success) {
                [_todoRemoteFolder uploadContentsOfFile:tempFileURL delegate:fileTransferDelegate];
            }];
        }
        else
        {
            [_todoRemoteFolder uploadContentsOfFile:tempFileURL delegate:fileTransferDelegate];
        }
    }
}

+ (void)retrieveItemsWithCompletion:(void (^)(NSArray *))handler
{
    [_todoRemoteFolder listItemsWithCompletion:^(NSArray *items) {
        handler(items);
    }];
}

+ (void)retrieveTodoItemFromFile:(File *)file completion:(void (^)(BCTodoItem *))handler
{
    BCTodoFileTransfer *fileTransferDelegate = [[BCTodoFileTransfer alloc] init];
    __weak BCTodoFileTransfer *weakFTD = fileTransferDelegate;
    [_delegates addObject:fileTransferDelegate];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *destURL = [_todoLocalFolderURL URLByAppendingPathComponent:file.name];
    
    weakFTD.downloadCompletion = ^(File *file, NSString *itemPath, NSURL *locationURL, BOOL cached, NSError *error) {
        if (!cached)
        {
            [fileManager removeItemAtURL:destURL error:NULL];
            [fileManager moveItemAtURL:locationURL toURL:destURL error:NULL];
        }
        
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[destURL path]
                                                               encoding:NSUTF8StringEncoding
                                                                  error:NULL];
        
        BCTodoItem *todoItem = [[BCTodoItem alloc] initWithJSON:jsonString];
        todoItem.file = file;
        handler(todoItem);
    };
    
    if ([fileManager fileExistsAtPath:[destURL path]])
    {
        weakFTD.downloadCompletion(file, nil, destURL, YES, nil);
    }
    else
    {
        fileTransferDelegate.file = file;
        [file downloadWithDelegate:fileTransferDelegate];
    }
}

+ (void)deleteTodoItem:(BCTodoItem *)todoItem completion:(void (^)(BCTodoItem *, BOOL))handler
{
    if (todoItem.file)
    {
        [todoItem.file deleteWithCompletion:^(BOOL success) {
            NSURL *fileURL = [_todoLocalFolderURL URLByAppendingPathComponent:todoItem.file.name];
            [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
            handler(todoItem, success);
        }];
    }
    else
    {
        handler(todoItem, NO);
    }
}

@end
