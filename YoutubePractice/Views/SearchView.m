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

    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 3;
    
    Video *firstVideo = [[self.search.searchResults allObjects] firstObject];
    [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:firstVideo.thumbUrl]]] drawInRect:CGRectMake(0, 0, 296, 223)];
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 300, 40)];
    searchLabel.text = [NSString stringWithFormat:@"  %@", self.search.query];
    searchLabel.textColor = [UIColor lightGrayColor];
    searchLabel.backgroundColor = [UIColor whiteColor];
    searchLabel.font = [UIFont fontWithName:@"Arial-Bold" size:15];
    [self addSubview:searchLabel];
}
@end
