# Datahämtning med signaler

##|------o------o------x

---

# `RACSignal`
## En signal är ett objekt som skickar värden

---

```objectivec
RACSignal *getSignal = [RACSignal getRequest:@"movie/12123"];

```

---

```objectivec
RACSignal *getSignal = [RACSignal getRequest:@"movie/12123"];

[getSignal subscribeNext:^(NSDictionary *json) {
	NSLog(@"did fetch movie: %@",json);
}];
```

---

# Map
```objectivec
[RACSignal getRequest:@"movie/12123"]

```

---

# Map

```objectivec
[[RACSignal getRequest:@"movie/12123"] 
// Map json to Video
map:^id(NSDictionary *json) {
	return [[Movie alloc] initWithDictionary:json];
}]

```

---

# Map

```objectivec
[[[RACSignal getRequest:@"movie/12123"] 
// Map json to Video
map:^id(NSDictionary *json) {
	return [[Movie alloc] initWithDictionary:json];
}] subscribeNext:^(Movie *movie) {
	NSLog(@"did fetch movie with title: %@",movie.title);
}];

```

---

# Flatten map

```objectivec
// Get the movie
[[RACSignal getMovieWithId:@1231]
     
// Get the director
flattenMap:^RACStream *(Movie *movie) {
	return [RACSignal getDirectorWithId:movie.directorId];
}]




























.
```

---

# Flatten map

```objectivec
// Get the movie
[[[RACSignal getMovieWithId:@1231]
     
// Get the director
flattenMap:^RACStream *(Movie *movie) {
	return [RACSignal getDirectorWithId:movie.directorId];
}]
    
// Get the directed movies
flattenMap:^RACStream *(Director *director) {
	return [RACSignal getMoviesWithDirector:director.directorId];
}]























.
```

---

# Flatten map

```objectivec
// Get the movie
[[[[RACSignal getMovieWithId:@1231]
     
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













.
``` 

---

# Flatten map

```objectivec
// Get the movie
[[[[[RACSignal getMovieWithId:@1231]
     
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



.
``` 

---

# Flatten map

```objectivec
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
``` 


