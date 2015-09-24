//
//  BlocNotes.h
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-24.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BlocNotes : NSManagedObject

@property (nonatomic, retain) NSDate * noteCreatedDate;
@property (nonatomic, retain) NSDate * noteLastModifiedDate;
@property (nonatomic, retain) NSString * noteText;
@property (nonatomic, retain) NSString * noteTitle;

@end
