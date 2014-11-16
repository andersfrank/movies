//
//  Stub.m
//  Dplay
//
//  Created by Anders Frank on 2014-10-06.
//  Copyright (c) 2014 Monterosa. All rights reserved.
//

#import "Stubs.h"
#import "OHHTTPStubsResponse+JSON.h"

@implementation Stubs

+ (void)setup {

    // video/<id>
    {
        [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            
            NSMutableArray *comp = [NSMutableArray arrayWithArray:request.URL.pathComponents];
            [comp removeLastObject];
            NSString *secondLastComponent = [comp lastObject];
            return [secondLastComponent isEqualToString:@"movie"];
            
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"movie.json",nil) statusCode:200 headers:@{@"Content-Type":@"text/json"}];
        }];
    }
    

    // director/<id>
    {
        [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            
            NSMutableArray *comp = [NSMutableArray arrayWithArray:request.URL.pathComponents];
            [comp removeLastObject];
            NSString *secondLastComponent = [comp lastObject];
            return [secondLastComponent isEqualToString:@"director"];
            
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"director.json",nil) statusCode:200 headers:@{@"Content-Type":@"text/json"}];
        }];
    }
    
    // movies/director/<id>
    {
        [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            
            NSMutableArray *comp = [NSMutableArray arrayWithArray:request.URL.pathComponents];
            [comp removeLastObject];
            NSString *secondLastComponent = [comp lastObject];
            [comp removeLastObject];
            NSString *thirdLastComponent = [comp lastObject];
            return [secondLastComponent isEqualToString:@"director"] && [thirdLastComponent isEqualToString:@"movies"];
            
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"movies_director.json",nil) statusCode:200 headers:@{@"Content-Type":@"text/json"}];
        }];
    }
    
    // imdb_grade/<id>
    {
        [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            
            NSMutableArray *comp = [NSMutableArray arrayWithArray:request.URL.pathComponents];
            [comp removeLastObject];
            NSString *secondLastComponent = [comp lastObject];
            return [secondLastComponent isEqualToString:@"imdb_rating"];
            
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            
            NSNumber *rating = @0;
            
            // Interstellar
            if ([request.URL.lastPathComponent longLongValue] == 1234567891231) {
                rating = @9;
            }
            // The dark knight
            else if ([request.URL.lastPathComponent longLongValue] == 5555121231123) {
                rating = @9;
            }
            // Inception
            else if ([request.URL.lastPathComponent longLongValue] == 129429123123) {
                rating = @8.8;
            }

            return [OHHTTPStubsResponse responseWithJSONObject:@{@"rating": rating} statusCode:200 headers:@{@"Content-Type":@"text/json"}];
        }];
    }
    
}



@end
