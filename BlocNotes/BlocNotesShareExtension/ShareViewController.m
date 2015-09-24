//
//  ShareViewController.m
//  BlocNotesShareExtension
//
//  Created by Xoi's iMac on 2015-09-23.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    
    NSLog(@"Did call");
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.xahBlocNotes"];
    [shared setObject:self.contentText forKey:@"noteKey"];
    [shared synchronize];
    
    id value = [shared valueForKey:@"noteKey"];
    NSLog(@"%@",value);
    
    
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
}


@end
