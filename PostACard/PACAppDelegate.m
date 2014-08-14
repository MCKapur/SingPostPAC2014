//
//  AppDelegate.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import <FacebookSDK/FBAppCall.h>

#import "PACCardSelectViewController.h"
#import "PACSocialAuthFacebookClient.h"
#import "PACUser.h"
#import "PACDataStore.h"
#import "PACAppDelegate.h"
#import "PACProfileViewController.h"
#import "PACComposeViewController.h"
#import "PACLoginViewController.h"

@interface PACAppDelegate ()
@end

@implementation PACAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedIn) name:PACNotificationLoggedIn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggingIn) name:PACNotificationLoggingIn object:nil];
    [self setTabBarController:[[UITabBarController alloc] init]];
    [self.tabBarController setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:[[PACComposeViewController alloc] init]], [[UINavigationController alloc] initWithRootViewController:[[PACProfileViewController alloc] init]]]];
    if ([[PACDataStore sharedStore] isLoggedIn]) {
        if ([[PACDataStore sharedStore] loggedInUser].loginProvider == PACLoginProviderTypeFacebook) {
            [[PACSocialAuthFacebookClient sharedClient] reviveCachedSessionWithCompletionHandler:^(NSError *error) {
            }];
        }
        [self.window setRootViewController:self.tabBarController];
    }
    else {
        [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:[[PACLoginViewController alloc] init]]];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loggingIn {
}

- (void)loggedIn {
    [self.window setRootViewController:self.tabBarController];
}

- (void)loggedOut {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[PACDataStore sharedStore] persist];
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
    [[PACDataStore sharedStore] loadFromPersistedDump];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PACDataStore sharedStore] clear];
}

@end
