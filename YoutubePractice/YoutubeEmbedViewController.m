//
//  YoutubeEmbedViewController.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "YoutubeEmbedViewController.h"

@interface YoutubeEmbedViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *videoView;
@end

@implementation YoutubeEmbedViewController

- (void)setUrl:(NSURL *)url
{
    _url = url;
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.videoView loadRequest:request];
}


@end
