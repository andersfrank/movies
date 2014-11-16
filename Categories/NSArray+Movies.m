//
//  NSArray+Movies.m
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import "NSArray+Movies.h"

@implementation NSArray (Movies)

- (NSArray *)arrayByMappingWithBlock:(MapBlock)block {
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity: [self count]];
    
    for (id value in self) {
        id o = block(value);
        if (o)
            [ret addObject:o];
    }
    
    return [NSArray arrayWithArray: ret];
}


@end
