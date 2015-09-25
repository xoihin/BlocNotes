//
//  ShareViewController.h
//  BlocNotesShareExtension
//
//  Created by Xoi's iMac on 2015-09-23.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

//@interface ShareViewController : SLComposeServiceViewController
@interface ShareViewController : UIViewController

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UITextField *shareTextTitle;
@property (strong, nonatomic) IBOutlet UITextView *shareTextView;

- (IBAction)tapGestureDidTap:(UITapGestureRecognizer *)sender;




@end
