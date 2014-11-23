//
//  NSArray+Movies.h
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^MapBlock)(id object);

@interface NSArray (Movies)

- (NSArray *)arrayByMappingWithBlock:(MapBlock)block;

@end
