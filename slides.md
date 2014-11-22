# Signaler med ReactiveCocoa

##o------o------o------x

---

^En signal är ett objekt som skickar värden.

# `RACSignal`

## En signal är ett objekt som skickar värden

---

^Den här signalen skickar ett video json-objekt från ett backend:

# `RACSignal`

```objectivec
RACSignal *getSignal = [RACSignal getRequest:@"movie/12123"];

```

---

# `RACSignal`

^Man prenumerar på en signal med metoden subscribe next.

^En signal skickar värden antingen direkt eller i framtiden. I det här exemplet skickas värdet när nätverksanropet är klart.

```objectivec
RACSignal *getSignal = [RACSignal getRequest:@"movie/12123"];

[getSignal subscribeNext:^(NSDictionary *json) {
	NSLog(@"did fetch movie: %@",json);
}];
```

---

# Map

---

# Map


^Den här signalen skickar som sagt ett json-objekt.

```objectivec
[RACSignal getRequest:@"movie/12123"]

```

---

# Map

^Vill vi istället ha en signal som skickar ett Movie-objekt kan vi använda operatorn map.

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

^Om man vill utföra flera nätverksanrop i rad kan man använda operatorn flatten map.

# Flatten map

---



^Flatten map är en operator som gör det möjligt att omvandla en signal till en ny signal som använder sig av värden som levereras av den första signalen.
^Här hämtas först en film, sedan dess regissör.

# Flatten map

```objectivec
// Get the movie
[RACSignal getMovieWithId:@1231]
     
































.
```

---


^Flatten map är en operator som gör det möjligt att omvandla en signal till en ny signal som använder sig av värden som levereras av den första signalen.
^Här hämtas först en film, sedan dess regissör.

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

^Därefter hämtas alla filmer som regissören regisserat.

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

^Sedan görs ett anrop för varje film som ger betyget på imdb.

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

^Slutligen räknas medelbetyget för filmerna ut.

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

---
# Error
# -----x

---

# Complete

---
# Operatorer

 - filter:
 - concat:
 - delay:
 - repeat
 - take:
 - merge:
 - collect:

---

1. Terms and condition visas.

1. Användaren svarar på “Know Your Customer” frågor.

1. Användaren matar in sitt personnummer.

1. Om användaren saknar bank-id appen informeras han om att detta krävs.

1. Applikationen anropar MobileBankIdIdentification/ med användarens personnummer som ett headervärde.

1. Applikationen anropar MobileBankIdIdentification/<referense_id> en gång och öppnar därefter bank-id appen.

---

1. Applikationen anropar MobileBankIdIdentification/<referense_id> varannan sekund tills den retuernerar progress code ```COMPLETE```

1. Applikationen anropar ConfigurationValues/

1. Applikationen anropar SavingApplications/ som returnerar ett saving application id.

1. Applikationen anropar POST SignOrder/ där sign order objektet som postas innehåller saving applications id:et.
1. Därefter öppnas bank id applikationen och låter användaren signera.
1. Applikationen anropar POST SignOrder/ med applkations id:et varannan sekund tills det returnerade SignOrder objektet har state COMPLETE. I sign order objektet som postas ingår target saving objektet som användaren blivit inbjuden till.
I det returnerade SignOrder objektet ingår en session samt det nu accepterade target saving objektet.


---

#Exempelkod

#### git@github.com:andersfrank/movies.git


