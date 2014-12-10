//
//  BCTodoFileTransfer.m
//  TodoList
//
//  Created by Nalinda Somasundara on 10/19/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import "BCTodoFileTransfer.h"

@implementation BCTodoFileTransfer

#pragma mark - Transfer Delegate Methods
// Upload completion
- (void)file:(File *)file didCompleteUploadWithError:(NSError *)err
{
    self.uploadCompletion(self.todoItem, file, err);
}

- (void)itemAtPath:(NSString *)itemPath didCompleteDownloadToURL:(NSURL *)locationURL error:(NSError *)err
{
    self.downloadCompletion(self.file, itemPath, locationURL, NO, err);
}

@end
