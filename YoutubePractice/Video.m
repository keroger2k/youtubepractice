//
//  Video.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "Video.h"

#define YOUTUBE_VIDEO_ID @"id.videoId"
#define YOUTUBE_TITLE @"snippet.title"
#define YOUTUBE_DESCRIPTION @"snippet.description"
#define YOUTUBE_THUMBNAIL @"snippet.thumbnails.default.url"

@implementation Video

- (id)initWithSnippet:(NSDictionary *)snippet andStatistics:(NSDictionary *)statistics
{
    self = [self init];
    if (self)
    {
        if ([snippet isKindOfClass:[ NSDictionary class]]) {
            _thumbnail =  [NSURL URLWithString:[snippet valueForKeyPath:YOUTUBE_THUMBNAIL]];
            _title = [snippet valueForKeyPath:YOUTUBE_TITLE];
            _description = [snippet valueForKeyPath:YOUTUBE_DESCRIPTION];
            _videoId = [snippet valueForKeyPath:YOUTUBE_VIDEO_ID];
        }
        if ([statistics isKindOfClass:[ NSDictionary class]]) {
            NSString *s = [[statistics valueForKey:@"statistics"] valueForKey:@"viewCount"];
            _viewCount = [s integerValue];
        }
        return self;
    }
    return nil;
}
@end
