//
//  YoutubeVideosTVC.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "YoutubeVideosTVC.h"
#import "YoutubeEmbedViewController.h"
//#import "GoogleFetcher.h"
#import "Video+Youtube.h"
#import "Search+Create.h"

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
    
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  [self loadVideosWithContext:document.managedObjectContext];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self loadVideosWithContext:document.managedObjectContext];
            }
        }];
    } else {
        [self loadVideosWithContext:document.managedObjectContext];
    }
}

- (void)loadVideosWithContext:(NSManagedObjectContext *)context
{
    //NSArray *videos = [GoogleFetcher searchVideosAndStatisticsWithQuery:self.query];
    [context performBlock:^{
        Search *search = [Search searchWithString:self.query inManagedObjectContext:context];
        for (int i = 0; i < [search.searchResults count]; i++) {
            [self.videos addObject:[search.searchResults allObjects][i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];    
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
    NSString* commaString = [numberFormatter stringFromNumber:video.viewCount];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Views: %@・%@", commaString, video.subtitle];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:video.thumbUrl]]];
    [cell.imageView setImage:image];
    return cell;
}

@end
