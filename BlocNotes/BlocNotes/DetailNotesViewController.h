//
//  DetailNotesViewController.h
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-21.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DetailNotesViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextView *myTextView;


- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;


@property (nonatomic, strong) NSManagedObject *selectedNote;

@end
