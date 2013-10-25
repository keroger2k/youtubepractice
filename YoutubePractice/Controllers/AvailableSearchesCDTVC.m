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

@interface AvailableSearchesCDTVC () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation AvailableSearchesCDTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useDemoDocument];
    [self.tableView reloadData];
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView* grayView = [[UIView alloc] initWithFrame:frame];
    grayView.backgroundColor = [UIColor colorWithRed:0.0f
                                                green:0.0f
                                                 blue:0.0f
                                                alpha:.1f];
    [self.tableView addSubview:grayView];
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
