//
//  JSONParser.h
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/29/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+(NSMutableArray*_Nullable)questionsArrayFromDictionary:(NSDictionary* _Nullable)dicitonary;


@end
