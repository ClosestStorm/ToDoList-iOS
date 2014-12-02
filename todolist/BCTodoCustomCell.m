//
//  BCTodoCustomCell.m
//  todolist
//
//  Created by Chathurka on 10/13/14.
//  Copyright (c) 2014 Bitcasa. All rights reserved.
//

#import "BCTodoCustomCell.h"
#import "BCTodoItem.h"

#define TEXT_FIELD_X 15
#define TEXT_FIELD_Y 10
#define TEXT_FIELD_WIDTH 285
#define TEXT_FIELD_HIGHT 30

#define ADD_NEW_TODO 0

@implementation BCTodoCustomCell
{
    UIView *bgColorView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.txtField = [[UITextField alloc] initWithFrame:CGRectMake(TEXT_FIELD_X, TEXT_FIELD_Y, TEXT_FIELD_WIDTH, TEXT_FIELD_HIGHT)];
        self.txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        self.txtField.delegate = self;
        
        [self.contentView addSubview:self.txtField];
    }
    
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (_row != ADD_NEW_TODO)
    {
        if (editing)
        {
            [self.txtField setEnabled:YES];
        }
        else
        {
            [self.txtField setEnabled:NO];
        }
    }
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![self.toDoItem.text isEqualToString:textField.text])
    {
        self.toDoItem.text = textField.text;
        self.toDoItem.textModified = YES;
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = self;
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:withRow:)])
    {
        [self.delegate textFieldShouldReturn:textField withRow:_row];
    }
    
    return NO;
}

@end
