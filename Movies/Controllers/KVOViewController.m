//
//  KVOViewController.m
//  Movies
//
//  Created by Anders Frank on 2014-11-23.
//  Copyright (c) 2014 Anders Frank. All rights reserved.
//

#import "KVOViewController.h"
#import "Movie.h"


@interface KVOViewController ()
@property (nonatomic) Movie *movie;
@property (nonatomic) NSString *movieTitle;
@end

@implementation KVOViewController

static void * KVOViewControllerContext = &KVOViewControllerContext;

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(movieTitle)) context:nil];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.movie = [Movie new];
        
        [self addObserver:self
               forKeyPath:NSStringFromSelector(@selector(movieTitle))
                  options:NSKeyValueObservingOptionNew
                  context:KVOViewControllerContext];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (context == KVOViewControllerContext && [keyPath isEqualToString:NSStringFromSelector(@selector(movieTitle))]) {
        self.movie.title = change[NSKeyValueChangeNewKey];
    }
         
}

@end
