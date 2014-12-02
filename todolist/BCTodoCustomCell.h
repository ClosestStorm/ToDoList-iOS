//
//  BCTodoCustomCell.h
//  todolist
//
//  Created by Chathurka on 10/13/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BCTodoItem;

@protocol BCKeyBoardReturnKeyDelegate<NSObject>

- (void)textFieldShouldReturn:(UITextField*)textField withRow:(NSInteger)row;

@end

/**
 *  Custom Table View Cell with a Text Field.
 */
@interface BCTodoCustomCell : UITableViewCell <UITextFieldDelegate>

// The textfield which shows the description of the ToDo Item.
@property (nonatomic) UITextField *txtField;

// The ToDo Item associated with the cell.
@property (nonatomic) BCTodoItem *toDoItem;

// The Table View which this cell is displayed.
@property (nonatomic, weak) UITableView *tableView;

//Delegate object for textfield return key
@property (nonatomic ,weak) NSObject<BCKeyBoardReturnKeyDelegate> *delegate;

//Row number of Tablew view
@property (nonatomic ,assign) NSInteger row;

@end
