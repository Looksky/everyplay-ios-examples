/*
 * Copyright 2013 Applifier
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "ERAppDelegate.h"
#import "ERViewController.h"
#import "Config.h"

@implementation ERAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ERViewController alloc] initWithNibName:@"ERViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ERViewController alloc] initWithNibName:@"ERViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

#if USE_EVERYPLAY
    // Initialize Everyplay SDK with our client id and secret.
    // These can be created at https://developers.everyplay.com
    [Everyplay setClientId:@"b459897317dc88c80b4515e380e1378022f874d2" clientSecret:@"f1a162969efb1c27aac6977f35b34127e68ee163" redirectURI:@"https://m.everyplay.com/auth"];

    // Tell Everyplay to use our rootViewController for presenting views and for delegate calls.
    [Everyplay initWithDelegate:self.viewController andParentViewController:self.window.rootViewController];
#endif

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
#if USE_EVERYPLAY && TEST_MANUAL_PAUSE_RESUME
    ELOG;
    [[[Everyplay sharedInstance] capture] pauseRecording];
#endif

    [self.viewController stopAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#if USE_EVERYPLAY && TEST_MANUAL_PAUSE_RESUME
    ELOG;
    [[[Everyplay sharedInstance] capture] resumeRecording];
#endif
    [self.viewController startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.viewController stopAnimation];
}

@end
