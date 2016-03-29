//
//  JSONParser.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/29/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "JSONParser.h"
#import "User.h"
#import "Question.h"

@implementation JSONParser

+(NSMutableArray*_Nullable)questionsArrayFromDictionary:(NSDictionary* _Nullable)dicitonary{
    
    NSMutableArray *result = [NSMutableArray new];
    
    if (dicitonary != nil) {
        
        NSMutableArray *items = dicitonary[@"items"];
        
        if (items) {
            
            for (NSDictionary *questionDictionary in items) {
                Question *newQuestion = [self questionFromDictionary:questionDictionary];
                
                if (newQuestion != nil) {
                    [result addObject:newQuestion];
                }
            }
        }
    }
    return result;
}

+(Question* _Nullable)questionFromDictionary:(NSDictionary*)questionDictinary{
    
    NSString *title = questionDictinary[@"title"];
    NSNumber *questionID = questionDictinary[@"question_id"];
    NSNumber *score = questionDictinary[@"score"];
    BOOL isAnswered = [questionDictinary[@"is_answered"]isEqualToNumber:@1];
    
    NSDictionary *ownerDictionary = questionDictinary[@"owner"];
    
    User *owner = [self userFromDictionary:ownerDictionary];
    
    return [[Question alloc]initWithTitle:title owner:owner questionID:questionID.intValue score:score.intValue isAnswered:isAnswered];
}


+(User* _Nullable)userFromDictionary:(NSDictionary*)userDictionary{
    
    NSString *displayName = userDictionary[@"display_name"];
    NSString *profileImageURLString = userDictionary[@"profile_image"];
    NSString *linkURLString = userDictionary[@"link"];
//    NSNumber *reputation = userDictionary[@"reputation"];
    NSNumber *userID = userDictionary[@"user_id"];
    
    NSURL *profileImageURL = [NSURL URLWithString:profileImageURLString];
    NSURL *link = [NSURL URLWithString:linkURLString];
    
    return [[User alloc]initWithDisplayName:displayName profileImageURL:profileImageURL link:link userID:userID.intValue];
    
}

@end
