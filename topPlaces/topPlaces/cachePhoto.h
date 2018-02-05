//
//  cachePhoto.h
//  topPlaces
//
//  Created by Wang Tom on 2018-02-04.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cachePhoto : NSObject
+ (void)savePhoto:(NSDictionary *)photo;
+ (NSArray *)retrieveAllPhotos;
@end
