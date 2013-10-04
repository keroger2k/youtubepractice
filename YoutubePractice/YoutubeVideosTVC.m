//
//  YoutubeVideosTVC.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "YoutubeVideosTVC.h"
#import "YoutubeFetcher.h"
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
                if ([segue.destinationViewController respondsToSelector:@selector(setUrl:)]) {
                    Video *video = [self.videos objectAtIndex:indexPath.item];
                    [segue.destinationViewController performSelector:@selector(setUrl:) withObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://youtu.be/%@", video.videoId]]];
                    [segue.destinationViewController setTitle:video.title];
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    NSArray *videos = [YoutubeFetcher searchWithQuery:@""];
    for (int i = 0; i < [videos count]; i++) {
        Video *video = [[Video alloc] initWithDictionary:videos[i]];
        [self.videos addObject:video];
    }
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
    cell.detailTextLabel.text = video.description;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:video.thumbnail]];
    [cell.imageView setImage:image];
    [cell.imageView setFrame:CGRectMake(0, 0, 30, 30)];
    return cell;
}

@end
