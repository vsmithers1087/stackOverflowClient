//
//  OAuthViewController.h
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/28/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OAuthWebViewControllerCompletion)();

@interface OAuthViewController : UIViewController

@property(strong, nonatomic)OAuthWebViewControllerCompletion completion;

-(id)accessTokenFromKeyChain;

@end
