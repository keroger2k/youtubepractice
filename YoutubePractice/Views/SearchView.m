//
//  SearchView.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/22/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "SearchView.h"
#import "Video.h"
#import "Search.h"

@implementation SearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    Video *firstVideo = [[self.search.searchResults allObjects] firstObject];
    [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:firstVideo.thumbUrl]]] drawInRect:CGRectMake(0, 0, 200, 150)];
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 200, 50)];
    searchLabel.text = [NSString stringWithFormat:@"%@\n%d videos", self.search.query, [self.search.searchResults count]];
    searchLabel.textColor = [UIColor grayColor];
    searchLabel.font = [searchLabel.font fontWithSize:15];
    [self addSubview:searchLabel];
}
@end
