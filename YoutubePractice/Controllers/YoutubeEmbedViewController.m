//
//  YoutubeEmbedViewController.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "YoutubeEmbedViewController.h"

@interface YoutubeEmbedViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *videoView;
@end

@implementation YoutubeEmbedViewController

- (void)setUrl:(NSURL *)url
{
    _url = url;
    //[self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    [self embedVideoYoutubeWithURL:[self.url absoluteString] andFrame:self.view.frame];
    //NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    //[self.videoView loadRequest:request];
}

- (void)embedVideoYoutubeWithURL:(NSString *)urlString andFrame:(CGRect)frame
{
    NSString *videoID = [self extractYoutubeVideoID:urlString];
    
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"http://www.youtube.com/v/%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, videoID, frame.size.width, frame.size.height];
    //self.videoView = [[UIWebView alloc] initWithFrame:frame];
    [self.videoView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.google.com"]];
}

- (NSString *)extractYoutubeVideoID:(NSString *)urlYoutube {
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:urlYoutube options:0 range:NSMakeRange(0, [urlYoutube length])];
    
    if(!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString *substringForFirstMatch = [urlYoutube substringWithRange:rangeOfFirstMatch];
        
        return substringForFirstMatch;
    }
    
    return nil;
}


- (NSUInteger)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationLandscapeLeft;
}



@end
