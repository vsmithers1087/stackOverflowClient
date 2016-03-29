//
//  Question.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/29/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "Question.h"

@implementation Question

-(instancetype)initWithTitle:(NSString*)title owner:(User*)owner questionID:(int)questionID
                       score:(int)score isAnswered:(BOOL)isAnswered{
    
    if (self = [super init ]) {
        
        self.title = title;
        self.owner = owner;
        self.questionID = questionID;
        self.score = score;
        self.isAnswered = isAnswered;
    }
    
    return self;
}

@end
