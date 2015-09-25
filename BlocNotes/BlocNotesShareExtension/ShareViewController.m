//
//  ShareViewController.m
//  BlocNotesShareExtension
//
//  Created by Xoi's iMac on 2015-09-23.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>



@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.shareTextTitle becomeFirstResponder];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.extensionContext cancelRequestWithError:nil];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (IBAction)tapGestureDidTap:(UITapGestureRecognizer *)sender {
    [self.shareTextTitle resignFirstResponder];
    [self.shareTextView resignFirstResponder];
}


@end
