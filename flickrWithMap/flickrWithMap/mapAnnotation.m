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

@synthesize data = _data;

+ (mapAnnotation *)annotationForPlaceAndPhoto:(NSDictionary *)data {
    mapAnnotation *annotation = [[mapAnnotation alloc] init];
    annotation.data = data;
    return annotation;
}

- (NSString *)title {
    NSString *title = [self.data objectForKey:FLICKR_PHOTO_TITLE];
    NSString *cityName = [self.data objectForKey:FLICKR_CITYNAME];
    return title ? title : cityName;
}

- (NSString *)subtitle {
    return [self.data valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.data objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.data objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end

