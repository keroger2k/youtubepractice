//
//  VideosCDTVC.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/8/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "VideosCDTVC.h"
#import "YoutubeEmbedViewController.h"
#import "VideoTableViewCell.h"
#import "GoogleFetcher.h"
#import "Video+Youtube.h"
#import "Search.h"

@interface VideosCDTVC()
@end

@implementation VideosCDTVC

- (void)viewDidLoad
{
    [self refresh];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Hide";
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
        video.banned = [NSNumber numberWithBool:YES];
    }
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    [self setupFetchedResultsControllerAll];
//}

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
    reqest.predicate = [NSPredicate predicateWithFormat:@"search.query = %@ and banned = 0", self.search.query];
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

- (void)setupFetchedResultsControllerAll
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
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Youtube Video"];
    Video *video = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.video = video;
//    cell.textLabel.text = video.title;
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    NSString* commaString = [numberFormatter stringFromNumber:video.viewCount];
//    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Views: %@・%@", commaString, video.subtitle];
//    cell.imageView [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:video.thumbUrl]]];
//    [cell.imageView setImage:image];
    
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
                vc.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://youtu.be/%@?rel=0&controls=0", video.videoId]];
                vc.title = video.title;
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 5)];
    [view setBackgroundColor:[UIColor colorWithRed:0.0f
                                              green:0.0f
                                               blue:0.0f
                                              alpha:.1f]]; //your background color...
    return view;
}


@end
