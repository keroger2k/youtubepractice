//
//  YoutubeFetcher.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//  https://www.googleapis.com/youtube/v3/search?part=snippet&q=crossfit&type=video&order=viewCount&maxResults=20&key=AIzaSyDUgamgeWGnWAaD8q1xTs4RDu89PnMYkxM

#import <Foundation/Foundation.h>

#define YOUTUBE_VIDEO_ID @"videoId"

@interface YoutubeFetcher : NSObject

+ (NSArray *)searchWithQuery:(NSString *)string;

@end
