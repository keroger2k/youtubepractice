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

- (id)initWithSnippet:(NSDictionary *)dictionary
{
    self = [self init];
    if (self)
    {
        if ([dictionary isKindOfClass:[ NSDictionary class]]) {
            _thumbnail =  [NSURL URLWithString:[dictionary valueForKeyPath:YOUTUBE_THUMBNAIL]];
            _title = [dictionary valueForKeyPath:YOUTUBE_TITLE];
            _description = [dictionary valueForKeyPath:YOUTUBE_DESCRIPTION];
            _videoId = [dictionary valueForKeyPath:YOUTUBE_VIDEO_ID];
            NSString *s = [[dictionary valueForKey:@"statistics"] valueForKey:@"viewCount"];
            _viewCount = [s integerValue];
        }
        return self;
    }
    return nil;
}
@end
