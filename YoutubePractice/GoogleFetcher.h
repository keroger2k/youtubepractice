//
//  GoogleImageFetcher.h
//  YoutubePractice
//
//  Created by Matt Luker on 10/5/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleFetcher : NSObject
+ (NSArray *)searchImagesWithQuery:(NSString *)query;
+ (NSArray *)searchVideosWithQuery:(NSString *)query;
@end
