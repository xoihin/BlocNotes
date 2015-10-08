//
//  DetailNotesViewController.m
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-21.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "DetailNotesViewController.h"
#import "BlocNotes.h"


@interface DetailNotesViewController () <UITextFieldDelegate, UITextViewDelegate>;

#define kNoTitle NSLocalizedString(@"No title", @"No title")
#define kNoNoteDetail NSLocalizedString(@"No note detail", @"No note detail")
#define kInputError NSLocalizedString(@"Input Error", @"Input Error")

@end


@implementation DetailNotesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set up right bar buttons
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveBarButtonItem, shareBarButtonItem, editBarButtonItem , nil];
    
    self.myTextView.delegate = self;
    self.myNoteTitle.delegate = self;
    
    if (self.selectedNote) {
        [self.myNoteTitle setText:[self.selectedNote valueForKey:@"noteTitle"]];
        [self.myTextView setText:[self.selectedNote valueForKey:@"noteText"]];
        self.navigationItem.title = @"Update Note";
        shareBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.title = @"New Note";
        self.myTextView.editable = YES;
        self.myTextView.backgroundColor = [UIColor lightGrayColor];
        [self.myNoteTitle becomeFirstResponder];
        editBarButtonItem.enabled = NO;
        shareBarButtonItem.enabled = NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Button Actions and Gesture Recognizer

-(void)editAction {
    
    if (self.myTextView.editable == NO) {
        self.myTextView.editable = YES;
        self.myTextView.backgroundColor = [UIColor lightGrayColor];
        [self.myTextView becomeFirstResponder];
    } else {
        self.myTextView.editable = NO;
        self.myTextView.backgroundColor = [UIColor clearColor];
        [self.myTextView resignFirstResponder];
    }
    
}



-(void)shareAction {
    
    // Share note content with other apps
    NSMutableArray *noteToShare = [NSMutableArray array];
    
    if (self.myNoteTitle.text.length > 0) {
        [noteToShare addObject:self.myNoteTitle.text];
    }
    
    if (self.myTextView.text.length) {
        [noteToShare addObject:self.myTextView.text];
    }
    
    if (noteToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:noteToShare applicationActivities:nil];
        //if iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:activityVC animated:YES completion:nil];
        }
        //if iPad
        else {
            // Change Rect to position Popover
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}


-(void)saveAction {
    
    // Title cannot be blank
    if ([self.myNoteTitle.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:kInputError
                              message:kNoTitle
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // Note text cannot be blank
    if ([self.myTextView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:kInputError
                              message:kNoNoteDetail
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    // Update / add note
    NSManagedObjectContext *context = [[MyShareManager sharedManager] managedObjectContext];
    
    if (self.selectedNote) {
        // Update
        [self.selectedNote setValue:self.myNoteTitle.text forKey:@"noteTitle"];
        [self.selectedNote setValue:self.myTextView.text forKey:@"noteText"];
        [self.selectedNote setValue:[NSDate date] forKey:@"noteLastModifiedDate"];
        
    } else {
        // Create new note
        BlocNotes *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"BlocNotes" inManagedObjectContext:context];
        [newNote setValue:self.myNoteTitle.text forKey:@"noteTitle"];
        [newNote setValue:self.myTextView.text forKey:@"noteText"];
        [newNote setValue:[NSDate date] forKey:@"noteCreatedDate"];
    }
   
    [[MyShareManager sharedManager] saveManagedObject:context error:nil];
    
    // Return
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)tapGestureDidFired:(UITapGestureRecognizer *)sender {
    [self.myTextView resignFirstResponder];
    [self.myNoteTitle resignFirstResponder];
}




#pragma mark - Text View Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.myTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.myTextView resignFirstResponder];
}



#pragma mark - Text Field Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.myNoteTitle resignFirstResponder];
    return YES;
}



@end
