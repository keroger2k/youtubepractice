//
//  VideosCDTVC.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/8/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Search.h"
#import "Video.h"

@interface VideosCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Search *search;

@end
