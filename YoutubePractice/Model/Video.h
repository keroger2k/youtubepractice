//
//  Video.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/10/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Search;

@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * thumbUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) NSNumber * viewCount;
@property (nonatomic, retain) NSNumber * watchCount;
@property (nonatomic, retain) NSNumber * banned;
@property (nonatomic, retain) Search *search;

@end
