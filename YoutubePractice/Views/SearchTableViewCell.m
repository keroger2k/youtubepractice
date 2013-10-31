//
//  SearchTableViewCell.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/25/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "Search.h"
#import "video.h"

@interface SearchTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *content;
@property (strong, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UILabel *searchTitle;
@end

@implementation SearchTableViewCell

- (void)setSearch:(Search *)search
{
    _search = search;
    [self updateUI];
}

- (void)updateUI
{
    // border radius
    [self.content.layer setCornerRadius:1.0f];
    
    // border
    [self.content.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.content.layer setBorderWidth:1.0f];
    
    // drop shadow
    [self.content.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.content.layer setShadowOpacity:0.9];
    [self.content.layer setShadowRadius:1.0];
    [self.content.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    self.searchTitle.text = self.search.query;
    Video *firstVideo = [[self.search.searchResults allObjects] firstObject];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:firstVideo.thumbUrl]]];
    self.searchImageView.image = image;
}

@end
