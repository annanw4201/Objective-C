//
//  mapAnnotation.m
//  flickrWithMap
//
//  Created by Wang Tom on 2018-05-03.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "mapAnnotation.h"
#import "FlickrFetcher.h"

@implementation mapAnnotation

@synthesize photo = _photo;

+ (mapAnnotation *)annotationForPhoto:(NSDictionary *)photo {
    mapAnnotation *annotation = [[mapAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

- (NSString *)title {
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitle {
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end

