//
//  YoutubeVideosTVC.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "YoutubeVideosTVC.h"

@interface YoutubeVideosTVC () <UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *videos; //NSUrls
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
                    NSURL *url = [self.videos objectAtIndex:indexPath.item];
                    [segue.destinationViewController performSelector:@selector(setUrl:) withObject:url];
                    [segue.destinationViewController setTitle:[url absoluteString]];
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    [self.videos addObject:[NSURL URLWithString:@"http://youtu.be/DcdIHec8M1A"]];
    [self.videos addObject:[NSURL URLWithString:@"http://youtu.be/yIEU4_p2t9s"]];
    [self.videos addObject:[NSURL URLWithString:@"http://youtu.be/49FlB25vCvw"]];
    [self.videos addObject:[NSURL URLWithString:@"http://youtu.be/vKA3eOSyaaA"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Youtube Video";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSURL *url = [self.videos objectAtIndex:indexPath.item];
    
    cell.textLabel.text = [url absoluteString];
    
    return cell;
}

@end
