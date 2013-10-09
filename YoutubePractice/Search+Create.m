//
//  Search+Create.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/7/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "Search+Create.h"

@implementation Search (Create)

+ (Search *)searchWithString:(NSString *)query
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    Search *search = nil;
    
    if (query.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Search"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"query"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"query = %@", query];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            search = [NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:context];
            search.query = query;
            //[context save:nil];
        } else {
            search = [matches lastObject];
        }
    }
    
    return search;
}

@end
