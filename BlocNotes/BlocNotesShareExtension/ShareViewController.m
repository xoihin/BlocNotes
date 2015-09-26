//
//  ShareViewController.m
//  BlocNotesShareExtension
//
//  Created by Xoi's iMac on 2015-09-23.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "myShareManager.h"
#import "BlocNotes.h"


@interface ShareViewController ()


@end

@implementation ShareViewController


- (void)loadView {
    [super loadView];
    
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *jsDict, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *jsPreprocessingResults = jsDict[NSExtensionJavaScriptPreprocessingResultsKey];
                        NSString *selectedText = jsPreprocessingResults[@"selection"];
                        NSString *pageTitle = jsPreprocessingResults[@"title"];

                        if ([selectedText length] > 0) {
                            self.shareTextView.text = selectedText;
                        }
                        if ([pageTitle length] > 0) {
                            self.shareTextTitle.text = pageTitle;
                        }
                    });
                }];
                break;
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.shareTextView becomeFirstResponder];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.extensionContext cancelRequestWithError:nil];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    NSManagedObjectContext *context = [[myShareManager sharedManager] createManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
    
    BlocNotes *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"BlocNotes" inManagedObjectContext:context];
    [newNote setValue:self.shareTextTitle.text forKey:@"noteTitle"];
    [newNote setValue:self.shareTextView.text forKey:@"noteText"];
    [newNote setValue:[NSDate date] forKey:@"noteCreatedDate"];
    
    [[myShareManager sharedManager] saveManagedObject:context error:nil];
    
    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

- (IBAction)tapGestureDidTap:(UITapGestureRecognizer *)sender {
    [self.shareTextTitle resignFirstResponder];
    [self.shareTextView resignFirstResponder];
}


@end
