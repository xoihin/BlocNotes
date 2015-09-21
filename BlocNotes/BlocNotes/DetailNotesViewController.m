//
//  DetailNotesViewController.m
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-21.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "DetailNotesViewController.h"



@interface DetailNotesViewController () <UITextFieldDelegate>;

@end

@implementation DetailNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = NSLocalizedString(@"Update Note", @"View Title");   
    
    if (self.selectedNote) {
        [self.myTextView setText:[self.selectedNote valueForKey:@"noteText"]];
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



#pragma mark - Button Actions


- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.selectedNote) {
        // Update
        [self.selectedNote setValue:self.myTextView.text forKey:@"noteText"];
        
    } else {
        // Create new note
        NSManagedObject *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"BlocNotes" inManagedObjectContext:context];
        [newNote setValue:self.myTextView.text forKey:@"noteText"];
    }
    

    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    // Return
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
