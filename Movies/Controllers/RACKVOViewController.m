//
//  RACKVOViewController.m
//  Movies
//
//  Created by Anders Frank on 2014-11-23.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import "RACKVOViewController.h"
#import "Movie.h"

@interface RACKVOViewController ()
@property (nonatomic) Movie *movie;
@property (nonatomic) NSString *movieTitle;
@end

@implementation RACKVOViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.movie = [Movie new];
        
        RAC(self.movie,title) = RACObserve(self, movieTitle);
        
    }
    return self;
}

@end
