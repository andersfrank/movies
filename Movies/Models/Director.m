//
//  Director.m
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import "Director.h"

@implementation Director

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.name = dict[@"name"];
        self.directorId = dict[@"director_id"];
        
    }
    return self;
}
@end
