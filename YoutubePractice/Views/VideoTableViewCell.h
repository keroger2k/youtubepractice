//
//  VideoTableViewCell.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/10/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"

@interface VideoTableViewCell : UITableViewCell
@property (weak,nonatomic) Video *video;
@end
