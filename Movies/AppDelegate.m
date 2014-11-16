//
//  AppDelegate.m
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import "AppDelegate.h"
#import "RACSignal+AFNetworking.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NSArray+Movies.h"

#import "Movie.h"
#import "Director.h"
#import "Stubs.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Stubs setup];
    

    //* En signal är ett objekt som skickar värden.

    //* Den här signalen skickar ett video json-objekt från ett backend:
    RACSignal *getSignal = [RACSignal getRequest:@"movie/12123"];

    //* Man prenumerar på en signal genom metoden subscribe
    [getSignal subscribeNext:^(NSDictionary *json) {
        NSLog(@"did fetch movie: %@",json);
    }];
    
    //* En signal skickar värden antingen direkt eller i framtiden. I exemplet ovan skickas värdet när nätverksanropet utförts.
    
    //* Vill vi istället att signalen ska skicka ett Movie-objekt kan vi använda operatorn map.
    RACSignal *getMovieSignal = [getSignal map:^id(NSDictionary *json) {
        return [[Movie alloc] initWithDictionary:json];
    }];

    [getMovieSignal subscribeNext:^(Movie *movie) {
        NSLog(@"did fetch movie with title: %@",movie.title);
    }];
    
    
    
    //* Om man vill utföra flera nätverksanrop i rad kan man använda operatorn flatten map.
    //* Här hämtas först en film, sedan dess regissör.
    
    [[[RACSignal getMovieWithId:@1231]
    // Get director
    flattenMap:^RACStream *(Movie *movie) {
        return [RACSignal getDirectorWithId:movie.directorId];
    }]
    subscribeNext:^(Director *director) {
        NSLog(@"The name of the director is: %@",director.name);
    }];
    

    
    //* Vi kan kedja ihop ytterligare anrop. När vi har regissören hämtar vi alla regisserade filmer.
    //* Därefter görs ett anrop för varje film och hämtar betyget från imdb.
    //* Slutligen räknar vi ut regissörens medelbetyg på imdb.
    
    // Get the movie
    [[[[[[RACSignal getMovieWithId:@1231]
     
    // Get the director
    flattenMap:^RACStream *(Movie *movie) {
        return [RACSignal getDirectorWithId:movie.directorId];
    }]
    
    // Get the directed movies
    flattenMap:^RACStream *(Director *director) {
        return [RACSignal getMoviesWithDirector:director.directorId];
    }]
    
    // Get imdb ratings for all movies
    flattenMap:^RACStream *(NSArray *movies) {
       
        NSArray *signals = [movies arrayByMappingWithBlock:^id(Movie *movie) {
            return [RACSignal getImdbRatingForMovieWithId:movie.movieId];
        }];
        return [[RACSignal merge:signals] collect];
        
    }]
      
    // Calculate the avarage rating
    map:^id(NSArray *ratings) {
        
        __block CGFloat sum = 0;
        [ratings enumerateObjectsUsingBlock:^(NSNumber *rating, NSUInteger idx, BOOL *stop) {
            sum += rating.floatValue;
        }];
        return @(sum / ratings.count);
    }]
     
    subscribeNext:^(NSNumber *directorRating) {
        NSLog(@"The director's average rating on imdb is: %@",directorRating);
    }];
    
    
    return YES;
}



@end
