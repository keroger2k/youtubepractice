//
//  AddSearchViewController.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/8/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "AddSearchViewController.h"
#import "Search+Create.h"
#import "Video+Youtube.h"
#import "GoogleFetcher.h"

@interface AddSearchViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@end

@implementation AddSearchViewController

- (void)viewDidLoad
{
    self.searchText.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchText becomeFirstResponder];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self create];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self create];
    return YES;
}

- (void)create
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        [self.managedObjectContext performBlock:^{
            NSArray *searchResults = [GoogleFetcher searchVideosAndStatisticsWithQuery:self.searchText.text];
            for (int i = 0; i <[searchResults count]; i++) {
                [Video videoWithYoutubeInfo:searchResults[i]
                                  forSearch:self.searchText.text
                     inManagedObjectContext:self.managedObjectContext];
            }
        }];
    });
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
