//
//  YoutubeVideosTVC.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "YoutubeVideosTVC.h"
#import "YoutubeEmbedViewController.h"
#import "GoogleFetcher.h"
#import "Video.h"

@interface YoutubeVideosTVC () <UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *videos; //Videos
@end

@implementation YoutubeVideosTVC

- (NSMutableArray *)videos
{
    if(!_videos) _videos = [[NSMutableArray alloc] init];
    return _videos;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Video"]) {
                Video *video = [self.videos objectAtIndex:indexPath.item];
                YoutubeEmbedViewController *vc = segue.destinationViewController;
                vc.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://youtu.be/%@", video.videoId]];
                vc.title = video.title;
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"VIDEOS・%d", [self.videos count]];
}

- (void)viewDidLoad
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *videos = [GoogleFetcher searchVideosAndStatisticsWithQuery:self.query];
        for (int i = 0; i < [videos count]; i++) {
            Video *video = [[Video alloc] initWithSnippet:videos[i]];
            [self.videos addObject:video];
        }
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Youtube Video";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Video *video = [self.videos objectAtIndex:indexPath.item];
    
    cell.textLabel.text = video.title;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* commaString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:video.viewCount]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Views: %@・%@", commaString, video.description];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:video.thumbnail]];
    [cell.imageView setImage:image];
    return cell;
}

@end
