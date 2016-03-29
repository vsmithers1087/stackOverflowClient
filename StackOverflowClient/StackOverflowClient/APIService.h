//
//  APIService.h
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/29/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kNSDataCompletionHandler)(NSDictionary * _Nullable data, NSError *_Nullable error);

@interface APIService : NSObject

+(void)getRequestWithURLString:(NSString* _Nullable)url withCompletion:(kNSDataCompletionHandler _Nullable)completion;

@end
