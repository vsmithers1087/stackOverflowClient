//
//  KeyChainWrapper.h
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/28/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Security;

@interface KeyChainWrapper : NSObject

@property(strong, nonatomic)NSMutableDictionary *keyChainStore;


@end
