//
//  BCTodoListViewController.m
//  todolist
//
//  Created by Chathurka on 10/13/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import "BCTodoListViewController.h"
#import "BCTodoCustomCell.h"
#import "BCToDoItem.h"
#import "BCTodoService.h"
#import "BCLoginViewController.h"
#import "BCPlistReader.h"
#import <BitcasaSDK/Session.h>
#import "AppDelegate.h"

#define ADD_NEW_TODO 0

@implementation BCTodoListViewController
{
    __block NSMutableArray* _toDoItemFiles;
    __block NSMutableArray *_toDoItems;
    
    BCTodoService *_todoService;
    
    int _cellToDoListCount;
    int _uploadCellItemCount;
    
    UITapGestureRecognizer *_tapGesture;
    UIActivityIndicatorView *_activityIndicator;
    
    UIBarButtonItem *_logoutBarButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _todoService = [[BCTodoService alloc] init];
    [BCTodoService createTodoFolderWithCompletion:^(BOOL success) {
        
        [BCTodoService retrieveItemsWithCompletion:^(NSArray *items) {
            
            _toDoItemFiles = [NSMutableArray arrayWithArray:items];
            _toDoItems = [[NSMutableArray alloc] initWithCapacity:items.count + 1];
            [_toDoItems addObject:@"Add New Todo"];
            [self retrieveToDoItems];
        }];
    }];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.tableView registerClass:[BCTodoCustomCell class] forCellReuseIdentifier:@"BCTodoListCellId"];
     self.tableView.userInteractionEnabled = NO;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.center = self.view.center;
    
    _cellToDoListCount = 0;
    _uploadCellItemCount = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView.superview addSubview:_activityIndicator];
    [self.tableView.superview bringSubviewToFront:_activityIndicator];
    [_activityIndicator startAnimating];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        [self.tableView setEditing:editing animated:editing];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    else
    {
        [self disableObjects];
        [self uploadToDoItems];
    }
}

#pragma mark - Private Methods

- (void)logout: (id) sender
{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.credentialService clearAuthKey];
    [self clearUserData];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (!(viewControllers.count > 0 && [[viewControllers firstObject] isMemberOfClass:[BCLoginViewController class]]))
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BCLoginViewController *loginViewController = (BCLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
        loginViewController.credentialService = delegate.credentialService;
        
        NSMutableArray *mutableViewControllers = [NSMutableArray arrayWithArray:viewControllers];
        [mutableViewControllers insertObject:loginViewController atIndex:0];
        [self.navigationController setViewControllers: mutableViewControllers];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clearUserData
{
    NSString *todoListFolderName = @"TodoList";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *todoLocalFolderURL = [documentsURL URLByAppendingPathComponent:todoListFolderName isDirectory:YES];
    NSError *error;
    
    if ([fileManager fileExistsAtPath:todoLocalFolderURL.path] &&
        [fileManager isDeletableFileAtPath:todoLocalFolderURL.path] &&
        [fileManager removeItemAtPath:todoLocalFolderURL.path error:&error])
    {
        NSLog(@"Deleted TodoList folder.");
    }
    else
    {
        NSLog(@"Error occured while deleting - %@.",error);
    }
}

- (void)uploadToDoItems
{
    if (_uploadCellItemCount >= _toDoItems.count)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _uploadCellItemCount = 0;
            [self enableObjects];
            [self.tableView setEditing:NO animated:YES];
        });
    }
    else if (_uploadCellItemCount == ADD_NEW_TODO)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        BCTodoCustomCell *cell = (BCTodoCustomCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *todoListCellText = [cell.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
        if (todoListCellText.length > 0)
        {
            BCTodoItem *bcNewToDo = [[BCTodoItem alloc] init];
            bcNewToDo.text = todoListCellText;
            bcNewToDo.completed = NO;
            [_toDoItems insertObject:bcNewToDo atIndex:1];
            
            [BCTodoService uploadTodoItem:bcNewToDo completion:^(BCTodoItem *item, BOOL success) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                NSIndexPath *indexPathAddTodo = [NSIndexPath indexPathForRow:0 inSection:0];
                BCTodoCustomCell *cellAddTodo = (BCTodoCustomCell *)[self.tableView cellForRowAtIndexPath:indexPathAddTodo];
                
                cellAddTodo.txtField.text = @"";
                [cellAddTodo.txtField resignFirstResponder];
                _uploadCellItemCount++;
                
                [self uploadToDoItems];
            }];
        }
        else
        {
            _uploadCellItemCount++;
            [self uploadToDoItems];
        }
    }
    else
    {
        BCTodoItem *bcItem = _toDoItems[_uploadCellItemCount];
        NSString *todoListCellText = [bcItem.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ((todoListCellText.length > 0))
        {
            if (bcItem.textModified)
            {
                [BCTodoService uploadTodoItem:bcItem completion:^(BCTodoItem *item, BOOL success) {
                    
                    bcItem.text = todoListCellText;
                    _uploadCellItemCount++;
                    bcItem.textModified = NO;
                    [self uploadToDoItems];
                }];
            }
            else
            {
                _uploadCellItemCount++;
                [self uploadToDoItems];
            }
        }
        else if (_uploadCellItemCount != ADD_NEW_TODO)
        {
            [_toDoItems removeObjectAtIndex:_uploadCellItemCount];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_uploadCellItemCount inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            _uploadCellItemCount++;
            [self uploadToDoItems];
        }
    }
}

- (void)retrieveToDoItems
{
    if (_cellToDoListCount >= _toDoItemFiles.count)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _cellToDoListCount = 1;
            [self enableObjects];
            [self.tableView reloadData];
        });
    }
    else
    {
        [BCTodoService retrieveTodoItemFromFile:_toDoItemFiles[_cellToDoListCount] completion:^(BCTodoItem *item) {
            [_toDoItems addObject:item];
            _cellToDoListCount++;
            [self retrieveToDoItems];
            
        }];
    }
}

- (void)disableObjects
{
    [_activityIndicator startAnimating];
    
    _tapGesture.enabled = NO;
    self.editButtonItem.enabled = NO;
    self.tableView.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)enableObjects
{
    _tapGesture.enabled = YES;
    self.editButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.tableView.userInteractionEnabled = YES;
    
    [_activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BCKeyBoardReturnKeyDelegate

- (void)textFieldShouldReturn:(UITextField*)textField withRow:(NSInteger)row;
{
    if (row == ADD_NEW_TODO)
    {
        BCTodoItem *bcNewToDo = [[BCTodoItem alloc] init];
        bcNewToDo.text = textField.text;
        bcNewToDo.completed = NO;
        [_toDoItems insertObject:bcNewToDo atIndex:1];
        
        [self disableObjects];
        
        [BCTodoService uploadTodoItem:bcNewToDo completion:^(BCTodoItem *item, BOOL success) {
            
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            textField.text = @"";
            [textField resignFirstResponder];
            
            [self enableObjects];
        }];
    }
    else
    {
        [self setEditing:NO animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_toDoItems count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row != ADD_NEW_TODO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != ADD_NEW_TODO && (editingStyle == UITableViewCellEditingStyleDelete))
    {
        [self disableObjects];
        
        BCTodoItem *todoItem = _toDoItems[indexPath.row];
        [BCTodoService deleteTodoItem:todoItem completion:^(BCTodoItem *item, BOOL success) {
            NSLog(@"TodoItem deleted.");
            
            [self enableObjects];
            [_toDoItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BCTodoListCellId";
    BCTodoCustomCell *bitcasaCell = (BCTodoCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    bitcasaCell.row = indexPath.row;
    
    if (_toDoItems.count)
    {
        if (indexPath.row == ADD_NEW_TODO)
        {
            bitcasaCell.delegate = self;
            [bitcasaCell setEditing:YES];
            [bitcasaCell.txtField setText:nil];
            [bitcasaCell.txtField setPlaceholder:@"Add New todo"];
            
            bitcasaCell.selectionStyle = UITableViewCellSelectionStyleNone;
            bitcasaCell.accessoryType = UITableViewCellAccessoryNone;
            bitcasaCell.imageView.image = nil;
        }
        else
        {
            BCTodoItem *toDoItem = _toDoItems[indexPath.row];
            bitcasaCell.accessoryType = toDoItem.completed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            
            bitcasaCell.delegate = self;
            bitcasaCell.txtField.text = toDoItem.text;
            bitcasaCell.toDoItem = toDoItem;
            bitcasaCell.tableView = tableView;
        }
    }
    
    return bitcasaCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BCTodoCustomCell *cell = (BCTodoCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row != ADD_NEW_TODO && _toDoItems.count)
    {
        BOOL success = NO;
        
        BCTodoItem *toDoItem = _toDoItems[indexPath.row];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (cell.accessoryType == UITableViewCellAccessoryNone)
        {
            success = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        [self disableObjects];
        toDoItem.completed = success;
        [BCTodoService uploadTodoItem:toDoItem completion:^(BCTodoItem *item, BOOL success) {
            
            [self enableObjects];
        }];
    }
}

@end
