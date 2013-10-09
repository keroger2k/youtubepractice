//
//  Search.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/7/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Video;

@interface Search : NSManagedObject

@property (nonatomic, retain) NSString * query;
@property (nonatomic, retain) NSSet *searchResults;
@end

@interface Search (CoreDataGeneratedAccessors)

- (void)addSearchResultsObject:(Video *)value;
- (void)removeSearchResultsObject:(Video *)value;
- (void)addSearchResults:(NSSet *)values;
- (void)removeSearchResults:(NSSet *)values;

@end
