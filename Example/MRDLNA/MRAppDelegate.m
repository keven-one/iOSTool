//
//  MRAppDelegate.m
//  MRDLNA
//
//  Created by MQL9011 on 05/04/2018.
//  Copyright (c) 2018 MQL9011. All rights reserved.
//

#import "MRAppDelegate.h"
#import <NetworkExtension/NEHotspotConfigurationManager.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import <Toast.h>
@implementation MRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.scheme isEqualToString:@"kingtool"]) {
        NSString *relativePath = [url relativePath];
        NSLog(@"relative path: %@", relativePath);
        NSString *host = [url host];
        NSLog(@"host: %@", host);
        NSString *path = [url path];
        NSLog(@"path: %@", path);
        
        
        NSString *encodeURLStr = [url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:encodeURLStr];
        [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"name: %@  value: %@", obj.name, obj.value);
        }];
        NSLog(@"%@-%@",components.queryItems[0].name,components.queryItems[1].name);
        if (![components.queryItems[0].name isEqualToString:@"name"]||![components.queryItems[1].name isEqualToString:@"password"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"参数不合法" preferredStyle:UIAlertControllerStyleAlert];
            [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:2];
            return YES;
        }
        if (@available(iOS 11.0, *)) {
            NSLog(@"%@",components.queryItems[1].value);
            NEHotspotConfiguration * hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:components.queryItems[0].value passphrase:components.queryItems[1].value isWEP:NO];
            //调用此方法系统会自动弹窗确认)

            [[NEHotspotConfigurationManager sharedManager]  applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
                
                
            }];
        }
        
    }
    return YES;
}

-(void)dismissAlert:(UIAlertController *)object{
    [object dismissViewControllerAnimated:YES completion:NULL];
}


@end
