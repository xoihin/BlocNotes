//
//  DetailNotesViewController.h
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-21.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShareManager.h"


@interface DetailNotesViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) IBOutlet UITextField *myNoteTitle;

@property (nonatomic, strong) NSManagedObject *selectedNote;
@property (readwrite, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)tapGestureDidFired:(UITapGestureRecognizer *)sender;


@end
