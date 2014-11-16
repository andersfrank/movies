//
//  RACSignal+AFNetworking.m
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "RACSignal+AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"

#import "NSArray+Movies.h"
#import "Movie.h"
#import "Director.h"

@implementation RACSignal (AFNetworking)

+ (RACSignal *)getRequest:(NSString *)path {
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.example.com/"]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        AFHTTPRequestOperation *operation =[manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
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
