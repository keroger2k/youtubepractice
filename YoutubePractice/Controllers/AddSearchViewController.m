//
//  AddSearchViewController.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/8/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "AddSearchViewController.h"
#import "Search+Create.h"

@interface AddSearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchText;

@end

@implementation AddSearchViewController

- (IBAction)cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        [self.managedObjectContext performBlock:^{
            [Search searchWithString:self.searchText.text inManagedObjectContext:self.managedObjectContext];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
    });
}

@end
