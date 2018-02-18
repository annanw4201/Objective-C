//
//  cachePhoto.m
//  topPlaces
//
//  Created by Wang Tom on 2018-02-04.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "cachePhoto.h"

@interface cachePhoto ()
@end

#define allPhotosPath @"cached_photo_path"

@implementation cachePhoto
+ (void)savePhoto:(NSDictionary *)photo {
    //NSLog(@"save photo, %@", photo);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *allPhotos = [[defaults objectForKey:allPhotosPath] mutableCopy];
    if (!allPhotos) {
        allPhotos = [NSMutableArray array];
    }
    NSInteger index = [allPhotos indexOfObject:photo];
    if (index == NSNotFound) {
        [allPhotos insertObject:photo atIndex:0];
    }
    if ([allPhotos count] > 20) {
        [allPhotos removeLastObject];
    }
    [defaults setObject:allPhotos forKey:allPhotosPath];
    [defaults synchronize];
}

+ (NSArray *)retrieveAllPhotos {
    //NSLog(@"retrieve all photos");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *allPhotos = [defaults objectForKey:allPhotosPath];
    //NSLog(@"%@", allPhotos);
    return allPhotos;
}
@end
