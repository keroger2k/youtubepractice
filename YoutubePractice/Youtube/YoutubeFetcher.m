//
//  YoutubeFetcher.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "YoutubeFetcher.h"
#import "YoutubeAPIKey.h"

@implementation YoutubeFetcher

+ (NSArray *)searchWithQuery:(NSString *)string
{
    NSString *query = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&type=video&order=viewCount&maxResults=20&key=%@", string, YoutubeAPIKey];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    return [results valueForKeyPath:@"items"];
}

@end
