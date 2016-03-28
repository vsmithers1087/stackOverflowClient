//
//  AppDelegate.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/28/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "AppDelegate.h"
#import "OAuthViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self checkForAccessToken];
    
    return YES;
}


-(void)checkForAccessToken {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *accessToken = [userDefaults stringForKey:@"access_token"];
    
    if (!accessToken) {
        
        //Get access token
        [self fetchAccessToken];
    }
}

-(void)fetchAccessToken {
    
    UIViewController *rootViewController = self.window.rootViewController;
    
    OAuthViewController *oAuthViewcontroller = [[OAuthViewController alloc]init];
    
    __weak typeof (oAuthViewcontroller) weakOAuth = oAuthViewcontroller;
    
    oAuthViewcontroller.completion = ^() {
        
        [weakOAuth.view removeFromSuperview];
         [weakOAuth removeFromParentViewController];
    };
    
    
    
    
    [rootViewController addChildViewController:oAuthViewcontroller];
    [rootViewController.view addSubview:oAuthViewcontroller.view];
    
    [oAuthViewcontroller didMoveToParentViewController:rootViewController];
    
}

@end
