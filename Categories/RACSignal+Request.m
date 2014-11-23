//
//  RACSignal+AFNetworking.m
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "RACSignal+Request.h"

#import "NSArray+Helpers.h"
#import "Movie.h"
#import "Director.h"

@implementation RACSignal (Request)

+ (RACSignal *)getRequest:(NSString *)path {
    
    NSString *fullPath = [NSString stringWithFormat:@"http://www.example.com/%@",path];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fullPath]];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!connectionError) {
                
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [subscriber sendNext:json];
                [subscriber sendCompleted];
                
            } else {
                [subscriber sendError:connectionError];
            }
            
        }];

        return [RACDisposable disposableWithBlock:^{
        // If we were using AFNetworking, we would cancel the operation here.
        }];
        
    }];
    
}

+ (RACSignal *)getMovieWithId:(NSNumber *)movieId {
    
    NSString *path = [NSString stringWithFormat:@"movie/%@",movieId];
    return [[self getRequest:path] map:^id(NSDictionary *json) {
        return [[Movie alloc] initWithDictionary:json];
    }];
    
}

+ (RACSignal *)getDirectorWithId:(NSNumber *)directorId {
    
    NSString *path = [NSString stringWithFormat:@"director/%@",directorId];
    return [[self getRequest:path] map:^id(NSDictionary *json) {
        return [[Director alloc] initWithDictionary:json];
    }];
    
}

+ (RACSignal *)getMoviesWithDirector:(NSNumber *)directorId {
    
    NSString *path = [NSString stringWithFormat:@"movies/director/%@",directorId];
    return [[self getRequest:path] map:^id(NSArray *json) {
        return [json arrayByMappingWithBlock:^id(NSDictionary *json) {
            return [[Movie alloc] initWithDictionary:json];
        }];
    }];
    
}

+ (RACSignal *)getImdbRatingForMovieWithId:(NSNumber *)movieId {
    
    NSString *path = [NSString stringWithFormat:@"imdb_rating/%@",movieId];
    return [[self getRequest:path] map:^id(NSDictionary *json) {
        return json[@"rating"];
    }];
    
}



@end
