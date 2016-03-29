//
//  OAuthViewController.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/28/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "OAuthViewController.h"
#import "KeyChainWrapper.h"

@import WebKit;

NSString const *kAccessToken = @"kAccessToken";
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

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction

decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
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

            NSString *value = componentArray[1];
            
            if (value) {
                NSLog(@"VALUE: %@", value);
                
                [self saveTokenToKeyChain:value];
                
                if (self.completion) {
                    self.completion();
                }
            }
        }
    }
}

-(BOOL)saveTokenToKeyChain:(NSString*)token{
    
  NSMutableDictionary *keyChainStore = [self getKeyChainQuery: (NSString*)kAccessToken];
    
    [keyChainStore setObject:[NSKeyedArchiver archivedDataWithRootObject:token] forKey:(NSString*)kSecValueData];
    
    CFDictionaryRef newDict = (__bridge CFDictionaryRef)(keyChainStore);
    
    SecItemDelete(newDict);
    SecItemAdd(newDict, nil);
    
    return YES;
}

-(id)accessTokenFromKeyChain{
    
    NSMutableDictionary *tempDict = [self getKeyChainQuery:(NSString*)kAccessToken];
    
    id token = nil;
    

    [tempDict setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [tempDict setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    
    id object = NULL;
    
    if (tempDict, object) {
        token = [NSKeyedUnarchiver unarchiveObjectWithData:object];
        return token;
    }
    
    return token;
    
}

-(NSMutableDictionary*)getKeyChainQuery:(NSString*)query{
    
    NSMutableDictionary *returnValue = [[NSMutableDictionary alloc]init];

    [returnValue setObject:(id)kSecClassGenericPassword forKey:(NSString*)kSecClass];
    [returnValue setObject:query forKey:(NSString*)kSecAttrService];
    [returnValue setObject:query forKey:(NSString*)kSecAttrAccount];
    [returnValue setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(NSString*) kSecAttrAccessible];
    
    return returnValue;
}


-(NSString*)getAccessToken{
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:kAccessToken];
    
    if (!accessToken) {
        accessToken = [self getAccessToken];
    }
    return accessToken;
}

-(void)saveStringToUserDefaults:(NSString*)value forKey:(NSString*)key{
    
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}



@end
