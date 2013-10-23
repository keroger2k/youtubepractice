//
//  SearchCollectionViewCell.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/22/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.2;
}

@end
