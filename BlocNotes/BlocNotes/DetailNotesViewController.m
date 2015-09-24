//
//  DetailNotesViewController.m
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-21.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "DetailNotesViewController.h"



@interface DetailNotesViewController () <UITextFieldDelegate, UITextViewDelegate>;

#define kDefaultTextTitle NSLocalizedString(@"Title of this note", @"Default text")
#define kDefaultTextBody NSLocalizedString(@"Write your note...", @"Default text")
#define kNoTitle NSLocalizedString(@"No title", @"No title")
#define kNoNoteDetail NSLocalizedString(@"No note detail", @"No note detail")


@end

@implementation DetailNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set up right bar buttons
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:saveBarButtonItem, shareBarButtonItem, nil];
    
    self.myTextView.delegate = self;
    self.myNoteTitle.delegate = self;
    
    if (self.selectedNote) {
        [self.myNoteTitle setText:[self.selectedNote valueForKey:@"noteTitle"]];
        [self.myTextView setText:[self.selectedNote valueForKey:@"noteText"]];
        self.navigationItem.title = @"Update Note";
        shareBarButtonItem.enabled = YES;
    } else {
        self.myTextView.text = kDefaultTextBody;
        self.myNoteTitle.placeholder = kDefaultTextTitle;
        self.navigationItem.title = @"New Note";
        shareBarButtonItem.enabled = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - CoreData

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



/*
 #pragma mark - Navigation
 
 In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 Get the new view controller using [segue destinationViewController].
 Pass the selected object to the new view controller.
 }
 */



#pragma mark - Button Actions and Gesture Recognizer

-(void)shareAction
{
    //    NSLog(@"share button clicked");
    
    NSMutableArray *noteToShare = [NSMutableArray array];
    
    if (self.myNoteTitle.text.length > 0) {
        [noteToShare addObject:self.myNoteTitle.text];
    }
    
    if (self.myTextView.text.length) {
        [noteToShare addObject:self.myTextView.text];
    }
    
    if (noteToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:noteToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
}

-(void)saveAction
{
    //    NSLog(@"save button clicked");
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.selectedNote) {
        // Update
        [self SetDefaultForBlankNote];
        [self.selectedNote setValue:self.myNoteTitle.text forKey:@"noteTitle"];
        [self.selectedNote setValue:self.myTextView.text forKey:@"noteText"];
        [self.selectedNote setValue:[NSDate date] forKey:@"noteLastModifiedDate"];
        
    } else {
        // Create new note
        NSManagedObject *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"BlocNotes" inManagedObjectContext:context];
        [self SetDefaultForBlankNote];
        [newNote setValue:self.myNoteTitle.text forKey:@"noteTitle"];
        [newNote setValue:self.myTextView.text forKey:@"noteText"];
        [newNote setValue:[NSDate date] forKey:@"noteCreatedDate"];
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    // Return
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)tapGestureDidFired:(UITapGestureRecognizer *)sender {
    [self.myTextView resignFirstResponder];
    [self.myNoteTitle resignFirstResponder];
}


- (void) SetDefaultForBlankNote {
    
    if ([self.myNoteTitle.text isEqualToString:@""]) {
        self.myNoteTitle.text = kNoTitle;
    }
    if ([self.myTextView.text isEqualToString:kDefaultTextBody]) {
        self.myTextView.text = kNoNoteDetail;
    }
    
}



#pragma mark - Text View Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.myTextView.text isEqualToString:kDefaultTextBody]) {
        self.myTextView.text = @"";
    }
    [self.myTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.myTextView.text isEqualToString:@""]) {
        self.myTextView.text = kDefaultTextBody;
    }
    [self.myTextView resignFirstResponder];
}



#pragma mark - Text Field Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.myNoteTitle resignFirstResponder];
    return YES;
}










@end
