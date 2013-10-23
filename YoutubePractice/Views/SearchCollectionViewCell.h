//
//  SearchCollectionViewCell.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/22/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"

@interface SearchCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet SearchView *searchView;

@end