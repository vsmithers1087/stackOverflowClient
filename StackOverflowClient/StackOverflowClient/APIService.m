//
//  APIService.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/29/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "APIService.h"
#import "AFNetworking.h"

@implementation APIService

+(void)getRequestWithURLString:(NSString* _Nullable)url withCompletion:(kNSDataCompletionHandler _Nullable)completion{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(responseObject, nil);
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(nil, error);
        });
    }];
}

@end
