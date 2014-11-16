//
//  Movie.m
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.movieId = dict[@"movie_id"];
        self.title = dict[@"title"];
        self.directorId = dict[@"director_id"];
        
    }
    return self;
}

@end
