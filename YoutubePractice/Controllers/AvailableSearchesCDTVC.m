//
//  AvailableSearchesCDTVC.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/24/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "AvailableSearchesCDTVC.h"
#import "Search.h"
#import "SearchTableViewCell.h"

@interface AvailableSearchesCDTVC () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) UIActionSheet *searchControlActionSheet;
@property (nonatomic, strong) Search *selectedSearch;
@property (nonatomic) BOOL setBackground;
@end

@implementation AvailableSearchesCDTVC

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Action Sheet

#define SEARCH_CANCEL @"Cancel"
#define SEARCH_DELETE @"Delete Search"

- (IBAction)options:(UIButton *)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    self.selectedSearch = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if (!self.searchControlActionSheet) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:SEARCH_CANCEL
                                                   destructiveButtonTitle:SEARCH_DELETE
                                                        otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
        self.searchControlActionSheet = actionSheet;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        NSLog(@"Delete %@", self.selectedSearch.query);
        for (NSManagedObject *vid in [self.selectedSearch.searchResults allObjects]) {
            [self.managedObjectContext deleteObject:vid];
        }
        [self.managedObjectContext deleteObject:self.selectedSearch];
        self.selectedSearch = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useDemoDocument];
    [self.tableView reloadData];
    //Need to figure out how to make entire window this color?
    if(!self.setBackground) {
        CGRect frame = self.tableView.bounds;
        frame.origin.y = -frame.size.height;
        UIView* grayView = [[UIView alloc] initWithFrame:CGRectMake(0, -frame.size.height, frame.size.width, 9000)];
        grayView.backgroundColor = [UIColor colorWithRed:0.0f
                                                    green:0.0f
                                                     blue:0.0f
                                                    alpha:.1f];
        [self.tableView insertSubview:grayView atIndex:0];
        self.setBackground = YES;
    }
}

- (void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Search"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"query"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil; // all searches
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Search Results"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Search *search = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if ([segue.destinationViewController respondsToSelector:@selector(setSearch:)]) {
            [segue.destinationViewController performSelector:@selector(setSearch:) withObject:search];
        }
    }
    if ([segue.identifier isEqualToString:@"Add Search"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
            [segue.destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    Search *search = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.search = search;
    return cell;
}
@end
