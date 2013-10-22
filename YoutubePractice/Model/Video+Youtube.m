//
//  Video+Youtube.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/7/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "Video+Youtube.h"
#import "Search+Create.h"

@implementation Video (Youtube)

#define YOUTUBE_VIDEO_ID @"id.videoId"
#define YOUTUBE_TITLE @"snippet.title"
#define YOUTUBE_DESCRIPTION @"snippet.description"
#define YOUTUBE_THUMBNAIL @"snippet.thumbnails.default.url"


+ (Video *)videoWithYoutubeInfo:(NSDictionary *)videoDictionary
                      forSearch:query
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    Video *video = nil;
    
    // Build a fetch request to see if we can find this Flickr photo in the database.
    // The "unique" attribute in Photo is Flickr's "id" which is guaranteed by Flickr to be unique.
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSString *v = videoDictionary[@"id"][@"videoId"];
    request.predicate = [NSPredicate predicateWithFormat:@"videoId = %@", v];
    
    // Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check what happened in the fetch
    
    if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
        // handle error
    } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
        video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:context];
        video.videoId = videoDictionary[@"id"][@"videoId"];
        video.title = videoDictionary[@"snippet"][@"title"];
        video.subtitle = videoDictionary[@"snippet"][@"description"];
        video.thumbUrl = videoDictionary[@"snippet"][@"thumbnails"][@"default"][@"url"];
        video.banned = [NSNumber numberWithBool:NO];
        NSString *s = videoDictionary[@"statistics"][@"viewCount"];
        video.viewCount = [NSNumber numberWithInt:[s integerValue]];
        Search *searchEntity = [Search searchWithString:query inManagedObjectContext:context];
        video.search = searchEntity;
    } else { // found the Photo, just return it from the list of matches (which there will only be one of)
        video = [matches lastObject];
    }
    return video;
}

@end
