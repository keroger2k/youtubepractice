//
//  Video.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/3/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *videoId;
@property (nonatomic, readonly) NSURL *thumbnail;

@end
