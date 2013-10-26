//
//  VideoTableViewCell.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/10/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "VideoTableViewCell.h"

@interface VideoTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *content;
@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@end

@implementation VideoTableViewCell

- (void)setVideo:(Video *)video
{
    _video = video;
    [self updateUI];
}

- (void)updateUI
{
    self.videoTitle.text = self.video.title;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video.thumbUrl]]];
    self.videoImageView.image = image;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(15.0f, 75.0f, 290, 1.0f);
    bottomBorder.backgroundColor = [[UIColor colorWithRed:0.0f
                                                   green:0.0f
                                                    blue:0.0f
                                                   alpha:.1f] CGColor];
    [self.layer addSublayer:bottomBorder];
}

@end
