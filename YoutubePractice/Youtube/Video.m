//
//  Video.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "Video.h"

#define YOUTUBE_ID @"id"
#define YOUTUBE_ID_VIDEO_ID @"videoId"
#define YOUTUBE_SNIPPET @"snippet"
#define YOUTUBE_SNIPPET_TITLE @"title"
#define YOUTUBE_SNIPPET_DESCRIPTION @"description"

@implementation Video

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self)
    {
        if ([dictionary isKindOfClass:[ NSDictionary class]]) {
            NSDictionary *snippet = [dictionary valueForKeyPath:YOUTUBE_SNIPPET];
            NSDictionary *id = [dictionary valueForKeyPath:YOUTUBE_ID];
            _title = snippet[YOUTUBE_SNIPPET_TITLE];
            _description = snippet[YOUTUBE_SNIPPET_DESCRIPTION];
            _videoId = id[YOUTUBE_ID_VIDEO_ID];
        }
        return self;
    }
    return nil;
}
@end
