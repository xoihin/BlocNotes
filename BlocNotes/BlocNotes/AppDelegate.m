//
//  AppDelegate.m
//  BlocNotes
//
//  Created by Xoi's iMac on 2015-09-20.
//  Copyright (c) 2015 XoiAHin. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate () <UIAlertViewDelegate>

#define kStorageOption NSLocalizedString(@"Choose Storage Option", @"Choose Storage Option")
#define kStorageMessage NSLocalizedString(@"Should notes be stored in iCloud and available on all your devices?", @"Storage message")
#define kLocalOnly NSLocalizedString(@"Local Only", @"Local Only")
#define kUseiCloud NSLocalizedString(@"Use iCloud", @"Use iCloud")


@property (nonatomic, strong) id currentiCloudToken;
@property (nonatomic, assign) BOOL firstLaunchWithiCloudAvailable;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Obtain the iCloud token
    NSFileManager* fileManager = [NSFileManager defaultManager];
    _currentiCloudToken = fileManager.ubiquityIdentityToken;
    
    // Archiving iCloud availability in the user defaults database
    if (_currentiCloudToken) {
        NSData *newTokenData =
        [NSKeyedArchiver archivedDataWithRootObject: _currentiCloudToken];
        [[NSUserDefaults standardUserDefaults] setObject: newTokenData forKey: @"com.xah.BlocNote.UbiquityIdentityToken"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"com.xah.BlocNote.UbiquityIdentityToken"];
    }
    
    // Invite the user to use iCloud - one time offer only.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *useiCloud = [ud objectForKey:@"useiCloud"];
    
    if (!useiCloud) {
        _firstLaunchWithiCloudAvailable = true;
    } else {
        _firstLaunchWithiCloudAvailable = false;
    }
    
    if (_currentiCloudToken && _firstLaunchWithiCloudAvailable) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: kStorageOption
                              message: kStorageMessage
                              delegate: self
                              cancelButtonTitle: kLocalOnly
                              otherButtonTitles: kUseiCloud, nil];
        [alert show];
    }
    return YES;
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    NSString *useicloud = [[NSString alloc]init];
    if (buttonIndex == 0) {
        // Local only
        useicloud = @"NO";
    } else {
        // Use icloud
        useicloud = @"YES";
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:useicloud forKey:@"useiCloud"];
    [ud synchronize];
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


@end
