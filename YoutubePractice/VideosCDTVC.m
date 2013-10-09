//
//  VideosCDTVC.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/8/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "VideosCDTVC.h"
#import "YoutubeEmbedViewController.h"
#import "GoogleFetcher.h"
#import "Video+Youtube.h"
#import "Search.h"

@implementation VideosCDTVC

- (void)viewDidLoad
{
    [self refresh];
}


- (IBAction)refresh
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [GoogleFetcher searchVideosAndStatisticsWithQuery:self.search.query];
        // put the photos in Core Data
        [self.search.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos) {
                [Video videoWithYoutubeInfo:photo forSearch:self.search.query inManagedObjectContext:self.search.managedObjectContext];
            }
        }];
    });
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *reqest = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
    reqest.predicate = [NSPredicate predicateWithFormat:@"search.query = %@", self.search.query];
    reqest.sortDescriptors = [NSArray arrayWithObject:
                              [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                            ascending:YES
                                                             selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:reqest
                                     managedObjectContext:self.search.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}

- (void)setSearch:(Search *)search
{
    if (_search == search) return;
    _search = search;
    self.title = search.query;
    [self setupFetchedResultsController];
}


#pragma mark - Live cycle

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Youtube Video";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:CellIdentifier];
    
    Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = video.title;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString* commaString = [numberFormatter stringFromNumber:video.viewCount];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Views: %@・%@", commaString, video.subtitle];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:video.thumbUrl]]];
    [cell.imageView setImage:image];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Video"]) {
                Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
                YoutubeEmbedViewController *vc = segue.destinationViewController;
                vc.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://youtu.be/%@", video.videoId]];
                vc.title = video.title;
            }
        }
    }
}


@end
