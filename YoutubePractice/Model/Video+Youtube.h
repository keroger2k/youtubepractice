//
//  Video+Youtube.h
//  YoutubePractice
//
//  Created by Kyle Rogers on 10/7/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "Video.h"

@interface Video (Youtube)

+ (Video *)videoWithYoutubeInfo:(NSDictionary *)videoDictionary
                      forSearch:query
         inManagedObjectContext:(NSManagedObjectContext *)context;

@end
