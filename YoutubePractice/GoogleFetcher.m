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

+(NSArray *)searchImagesWithQuery:(NSString *)query
{
    NSDictionary *results = [self executeQueryRequest:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&imgsz=small&safe=active&rsz=8", query]];
    return [results valueForKeyPath:@"responseData.results.url"];
}

+ (NSArray *)searchVideosWithQuery:(NSString *)query
{
    NSDictionary *results = [self executeQueryRequest:[NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&type=video&order=viewCount&maxResults=20&key=%@", query, YoutubeAPIKey]];
    return [results valueForKeyPath:@"items"];
}

+ (NSDictionary *)executeQueryRequest:urlString
{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    return jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
}

@end
