//
//  AppDelegate.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/28/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "AppDelegate.h"
#import "OAuthViewController.h"
#import "KeyChainWrapper.h"
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self fetchAccessToken];
    
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        sleep(4);
//        NSLog(@"now block");
//    });
//    
//    
//    NSLog(@"now outside");
    
    
    return YES;
}

-(void)fetchAccessToken {
    
    UIViewController *rootViewController = self.window.rootViewController;
    
    OAuthViewController *oAuthViewcontroller = [[OAuthViewController alloc]init];
    
    if (![oAuthViewcontroller accessTokenFromKeyChain]) {
        __weak typeof (oAuthViewcontroller) weakOAuth = oAuthViewcontroller;
        
        oAuthViewcontroller.completion = ^() {
            
            [weakOAuth.view removeFromSuperview];
            [weakOAuth removeFromParentViewController];
        };
        
        [rootViewController addChildViewController:oAuthViewcontroller];
        [rootViewController.view addSubview:oAuthViewcontroller.view];
        
        [oAuthViewcontroller didMoveToParentViewController:rootViewController];
    }
    
}

@end
