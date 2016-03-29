//
//  User.h
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/29/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

@import UIKit;

@interface User : NSObject

@property(strong, nonatomic)NSString *displayName;
@property(strong, nonatomic)NSURL *profileImageURL;
@property(strong, nonatomic)UIImage *profileImage;
@property(strong, nonatomic)NSURL *link;
@property(nonatomic) int userID;

-(instancetype)initWithDisplayName:(NSString*)displayName profileImageURL:(NSURL*)profileImageURL link:(NSURL*)link userID:(int)userID;

@end
