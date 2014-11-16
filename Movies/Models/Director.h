//
//  Director.h
//  Movies
//
//  Created by Anders Frank on 2014-11-16.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Director : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *directorId;

@end
