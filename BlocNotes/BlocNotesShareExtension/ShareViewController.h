//
//  ShareViewController.h
//  BlocNotesShareExtension
//
//  Created by Xoi's iMac on 2015-09-23.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>


@interface ShareViewController : UIViewController


- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)tapGestureDidTap:(UITapGestureRecognizer *)sender;

@property (strong, nonatomic) IBOutlet UITextField *shareTextTitle;
@property (strong, nonatomic) IBOutlet UITextView *shareTextView;
@property (strong, nonatomic) IBOutlet UILabel *shareViewHeading;



@end
