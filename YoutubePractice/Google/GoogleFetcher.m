//
//  GoogleImageFetcher.m
//  YoutubePractice
//
//  Created by Matt Luker on 10/5/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "GoogleFetcher.h"
#import "YoutubeAPIKey.h"

@implementation GoogleFetcher

#define GOOGLE_IMAGES_URL @"https://ajax.googleapis.com/ajax/services/search/images"
#define GOOGLE_IMAGES_MAX_RESULT 8


+(NSArray *)searchImagesWithQuery:(NSString *)query
{
    NSDictionary *results = [self executeQueryRequest:[NSString stringWithFormat:@"%@?v=1.0&q=%@&imgsz=small&safe=active&rsz=%d", GOOGLE_IMAGES_URL, query, GOOGLE_IMAGES_MAX_RESULT]];
    return [results valueForKeyPath:@"responseData.results.url"];
}

#define GOOGLE_API_URL @"https://www.googleapis.com/youtube/v3/"
#define YOUTUBE_MAX_RESULTS 50

+ (NSArray *)searchVideosWithQuery:(NSString *)query
{
    NSDictionary *results = [self executeQueryRequest:
                             [NSString stringWithFormat:@"%@search?part=snippet&q=%@&type=video&safeSearch=strict&order=viewCount&maxResults=%d&key=%@", GOOGLE_API_URL, query, YOUTUBE_MAX_RESULTS, YoutubeAPIKey]];
    return [results valueForKeyPath:@"items"];
}

+ (NSArray *)fetchVideoStatistics:(NSArray *)videoIds
{
    NSString *appendedIds = [videoIds componentsJoinedByString:@","];
    NSDictionary *results = [self executeQueryRequest:
                             [NSString stringWithFormat:@"%@videos?id=%@&part=id,statistics&key=%@", GOOGLE_API_URL, appendedIds, YoutubeAPIKey]];
    return [results valueForKeyPath:@"items"];
}

+ (NSArray *)searchVideosAndStatisticsWithQuery:(NSString *)query
{
    NSDictionary *results = [self executeQueryRequest:
                             [NSString stringWithFormat:@"%@search?part=snippet&q=%@&type=video&safeSearch=strict&order=viewCount&maxResults=%d&key=%@", GOOGLE_API_URL, query, YOUTUBE_MAX_RESULTS, YoutubeAPIKey]];
    NSMutableArray *videos = [[NSMutableArray alloc]init];
    NSMutableArray *combined = [[NSMutableArray alloc] init];
    NSArray *items = [results valueForKeyPath:@"items"];
    for (int i = 0; i < [items count]; i++) {
        NSString *videoId = [items[i] valueForKeyPath:@"id.videoId"];
        [videos addObject:videoId];
    }
    NSArray *statistics = [self fetchVideoStatistics:videos];
    for (int i = 0; i < [items count]; i++) {
        NSString *videoId = [items[i] valueForKeyPath:@"id.videoId"];
        NSString *statisticsVideoId = [statistics[i] valueForKeyPath:@"id"];
        if ([videoId isEqualToString:statisticsVideoId] ) { //They seem to come back in correct order but verifying.
            NSDictionary *d = @{ @"id" : [items[i] valueForKeyPath:@"id"], @"snippet" : [items[i] valueForKeyPath:@"snippet"], @"statistics" : [statistics[i] valueForKeyPath:@"statistics"] };
            [combined addObject:d];
        }
    }
    return combined;
}


+ (NSDictionary *)executeQueryRequest:urlString
{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    return jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
}

@end
