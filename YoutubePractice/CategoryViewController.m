//
//  CategoryViewController.m
//  YoutubePractice
//
//  Created by Matt Luker on 10/5/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "CategoryViewController.h"
#import "ImageViewCell.h"
#import "GoogleImageFetcher.h"

@interface CategoryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *categoryInput;
@property (weak, nonatomic) IBOutlet UISearchBar *imageSearchbox;
@property (weak, nonatomic) IBOutlet UICollectionView *imageViewCollection;
@property (strong, nonatomic) NSArray *googleImageCollection;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)searchEvent
{
    [self.view endEditing:YES];
    [self loadData];
    [self.imageViewCollection reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    

    [self.spinner startAnimating];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self loadData];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.imageViewCollection reloadData];
            [self.spinner stopAnimating];
        });
    });
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)loadData
{
    NSString *query = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&imgsz=small&safe=active&rsz=8", self.imageSearchbox.text];
    
    self.googleImageCollection = [GoogleImageFetcher searchWithQuery:query];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if(!self.googleImageCollection)
        return 0;
    
    return [self.googleImageCollection count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell  *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"cellPhotoIdentifier"
                                              forIndexPath:indexPath];
    NSObject *obj = [self.googleImageCollection objectAtIndex:indexPath.item];
    [cell setVideoImageUrl: [NSString stringWithFormat:@"%@", obj]];
    return cell;
}


@end