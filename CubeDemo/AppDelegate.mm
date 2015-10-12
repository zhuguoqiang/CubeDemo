//
//  AppDelegate.m
//  CubeDemo
//
//  Created by Ambrose Xu on 14-10-8.
//  Copyright (c) 2014年 Cube Team. All rights reserved.
//

#import "AppDelegate.h"
#import "Cube.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 真机测试时保存日志
    
    if (!SIMULATOR)
    {
//        [self redirectNSLogToDocumentFolder];
    }
    
    NSString *appId = @"";
    NSString *appKey = @"";
    [[CubeEngine sharedSingleton] startup:appId appKey:appKey];

    CubeConfig *config = [[CubeConfig alloc] init];
    config.videoSize = CubeVideoSizeSmart;
    [[CubeEngine sharedSingleton] configure:config];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    [[CubeEngine sharedSingleton] pause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [[CubeEngine sharedSingleton] enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    [[CubeEngine sharedSingleton] enterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [[CubeEngine sharedSingleton] resume];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    [[CubeEngine sharedSingleton] unregisterAccount];
    [[CubeEngine sharedSingleton] shutdown];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
}

#pragma mark - RedirectLog
- (void)redirectNSLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"CubeDemo-%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}


@end
