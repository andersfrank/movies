//
//  RACSignal+AFNetworking.h
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import "RACSignal.h"

@interface RACSignal (AFNetworking)

+ (RACSignal *)getRequest:(NSString *)path;

+ (RACSignal *)getMovieWithId:(NSNumber *)movieId;

+ (RACSignal *)getDirectorWithId:(NSNumber *)directorId;

+ (RACSignal *)getMoviesWithDirector:(NSNumber *)directorId;

+ (RACSignal *)getImdbRatingForMovieWithId:(NSNumber *)movieId;

@end
