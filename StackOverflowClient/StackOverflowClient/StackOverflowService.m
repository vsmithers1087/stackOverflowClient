//
//  StackOverflowService.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/29/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "StackOverflowService.h"
#import "APIService.h"

NSString const *kSOAPIBaseURL = @"https://api.stackexchange.com/2.2/";

@implementation StackOverflowService


+(void)searchWithTerm:(NSString* _Nonnull)searchTerm withCompletion:(kNSDataCompletionHandler _Nonnull)completion{

    NSString *search = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *sortParam = @"activity";
    NSString *orderParam = @"desc";
    
    NSString *searchURL = [NSString stringWithFormat:@"%@search?order=%@&sort=%@&intitle=%@&site=stackoverflow", kSOAPIBaseURL, orderParam, sortParam, search];
    
    [APIService getRequestWithURLString:searchURL withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        
        if (!error) {
            
            completion(data, nil);
        }
    }];
}

@end
