//
//  myShareManager.m
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-25.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "myShareManager.h"


static NSString *const kFilename = @"BlocNotes.sqlite";

@interface myShareManager ()

@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation myShareManager


+ (instancetype)sharedManager
{
    static myShareManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[myShareManager alloc] init];
    });
    return sharedManager;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"BlocNotes" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.xahBlocNotes"];
        NSURL *persistentStoreURL = [groupURL URLByAppendingPathComponent:kFilename];
        
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:persistentStoreURL
                                                             options:@{ NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES}
                                                               error:&error]) {
            NSLog(@"Error creating persistent store at %@: %@", persistentStoreURL, [error localizedDescription]);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    return context;
}


- (BOOL)saveManagedObject:(NSManagedObjectContext *)context error:(NSError **)error
{
    NSError *saveError = nil;
    BOOL success = [context save:&saveError];
    if (!success) {
        NSLog(@"Core Data save error: %@", [saveError localizedDescription]);
        if (error != nil) {
            *error = saveError;
        }
    }
    return success;
}



@end
