//
//  Search+Create.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/7/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "Search.h"

@interface Search (Create)

+ (Search *)searchWithString:(NSString *)query
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
