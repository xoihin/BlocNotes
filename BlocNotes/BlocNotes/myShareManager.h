//
//  myShareManager.h
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-25.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface myShareManager : NSObject


+ (instancetype)sharedManager;

- (NSManagedObjectContext *)createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

- (BOOL)saveManagedObject:(NSManagedObjectContext *)context error:(NSError **)error;



@end
