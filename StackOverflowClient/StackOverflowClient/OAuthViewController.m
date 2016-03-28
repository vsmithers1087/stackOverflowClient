//
//  OAuthViewController.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/28/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "OAuthViewController.h"
@import WebKit;

NSString const *kClientID = @"6798";
NSString const *kBaseURL = @"https://stackexchange.com/oauth/dialog?";
NSString const *kRedirectURI = @"https://stackexchange.com/oauth/login_success";


@interface OAuthViewController ()<WKNavigationDelegate>

@property(strong, nonatomic)WKWebView *webView;

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpWebView];
    // Do any additional setup after loading the view.
    //vsmithers1087
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)setUpWebView{
    
    self.webView = [[WKWebView  alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:self.webView];
    
    NSString *stackURLString = [NSString stringWithFormat:@"%@client_id=%@&redirect_uri=%@", kBaseURL, kClientID, kRedirectURI];
    
    NSURL *stackURL = [NSURL URLWithString:stackURLString];
    
    self.webView.navigationDelegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:stackURL]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURLRequest *request = navigationAction.request;
    NSURL *requestURL = request.URL;
    
    NSLog(@"requestURL: %@...end", requestURL);
    
    if ([requestURL.description containsString:@"access_token"]) {
        
        NSLog(@"There is a token");
        
        [self getAndStoreAccessTokenFromURL:requestURL];
        
    }else{
        NSLog(@"No Token");
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)getAndStoreAccessTokenFromURL:(NSURL*)url{
    
    NSCharacterSet *seperatingCharacters = [NSCharacterSet characterSetWithCharactersInString:@"#&?"];
    NSArray *urlComponents = [[url description]componentsSeparatedByCharactersInSet:seperatingCharacters];
    
    for (NSString * component in urlComponents) {
        NSArray *componentArray = [component componentsSeparatedByString:@"="];
        
        if (componentArray.count >= 2) {
            
            
            
            NSString *key = componentArray[0];
            NSString *value = componentArray[1];
            
            if (key && value) {
                NSLog(@"KEY: %@, VALUE: %@", key, value);
                
                [self saveStringToUserDefaults:value forKey:key];
                
                if (self.completion) {
                    [self completion];
                }
            }
        }
    }
}



-(void)saveStringToUserDefaults:(NSString*)value forKey:(NSString*)key{
    
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}


@end
