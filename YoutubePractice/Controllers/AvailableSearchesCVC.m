//
//  AvailableSearches.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/22/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "AvailableSearchesCVC.h"
#import "Search.h"
#import "Video.h"
#import "SearchCollectionViewCell.h"

@interface AvailableSearchesCVC () <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *searches;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;

@end

@implementation AvailableSearchesCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.managedObjectContext) [self useDemoDocument];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
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
    [self refresh];
}

- (void)refresh
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Search"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"query"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = nil; // all searches
    self.searches = [_managedObjectContext executeFetchRequest:request error:nil];
    [self.searchCollectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Search Results"]) {
        NSIndexPath *indexPath = [self.searchCollectionView indexPathForCell:sender];
        Search *search = [self.searches objectAtIndex:indexPath.item];
        
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

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.searches count];
}

- (UICollectionViewCell * )collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = (SearchCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Search" forIndexPath:indexPath];
    Search *search = [self.searches objectAtIndex:indexPath.item];
    cell.searchView.search = search;
    return cell;
}

@end
