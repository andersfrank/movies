//
//  Movie.h
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, copy) NSNumber *directorId;

@end
