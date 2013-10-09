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

- (IBAction)done:(id)sender {
    if ([self.searchText hasText]) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Demo Document"];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [document saveToURL:url
               forSaveOperation:UIDocumentSaveForCreating
              completionHandler:^(BOOL success) {
                  if (success) {
                      [self refresh:document.managedObjectContext];
                  }
              }];
        } else if (document.documentState == UIDocumentStateClosed) {
            [document openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    [self refresh:document.managedObjectContext];
                }
            }];
        }
        
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)refresh:(NSManagedObjectContext *)context
{
     dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
     dispatch_async(fetchQ, ^{
        [context performBlock:^{
            [Search searchWithString:self.searchText.text inManagedObjectContext:context];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
    });
}

@end
