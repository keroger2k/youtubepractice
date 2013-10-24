//
//  SearchCollectionViewCell.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/22/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import "Search.h"
#import "video.h"

@interface SearchCollectionViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UILabel *searchTitle;
@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;

@end

@implementation SearchCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SearchCollectionViewCell" owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.layer.masksToBounds = NO;
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowRadius = 1.0f;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
    return self;
}

- (void)setSearch:(Search *)search
{
    _search = search;
    [self updateUI];
}

- (void)updateUI
{
    self.videoCountLabel.text = [NSString stringWithFormat:@"%d・videos", [self.search.searchResults count]];
    self.searchTitle.text = self.search.query;
    Video *firstVideo = [[self.search.searchResults allObjects] firstObject];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:firstVideo.thumbUrl]]];
    UIImageView *view = [[UIImageView alloc] initWithFrame:self.searchImageView.frame];
    view.image = image;
    [self addSubview:view];
}


@end
