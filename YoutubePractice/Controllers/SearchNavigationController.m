//
//  SearchNavigationController.m
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/30/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "SearchNavigationController.h"

@interface SearchNavigationController ()

@end

@implementation SearchNavigationController

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}


@end
