//
//  FixedSearchTVC.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/4/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "FixedSearchTVC.h"
#import "YoutubeVideosTVC.h"

@interface FixedSearchTVC () <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *searches;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation FixedSearchTVC

- (NSMutableArray *)searches
{
    if(!_searches) _searches = [[NSMutableArray alloc] init];
    return _searches;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Search Results"]) {
                NSString *query = [self.searches objectAtIndex:indexPath.item];
                YoutubeVideosTVC *vc = segue.destinationViewController;
                vc.query = query;
                vc.title = query;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searches addObject:@"Trains"];
    [self.searches addObject:@"Planes"];
    [self.searches addObject:@"Monster Trucks"];
    [self.searches addObject:@"keroger2k"];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Search Query";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *search = [self.searches objectAtIndex:indexPath.item];
    cell.textLabel.text = search;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.searches removeObjectAtIndex:indexPath.item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
