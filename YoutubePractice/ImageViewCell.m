//
//  ImageViewCell.m
//  YoutubePractice
//
//  Created by Matt Luker on 10/5/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "ImageViewCell.h"

@interface ImageViewCell()
@property (nonatomic, weak) IBOutlet UIImageView *cellImage;

@end

@implementation ImageViewCell

-(void)awakeFromNib
{
    self.layer.borderWidth=1.0f;
    self.layer.borderColor=[UIColor blackColor].CGColor;
}

-(void)setVideoImageUrl:(NSString *)videoImageUrl
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:videoImageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        dispatch_async( dispatch_get_main_queue(), ^{
            self.cellImage.image = img;
        });
    });
    
   
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
