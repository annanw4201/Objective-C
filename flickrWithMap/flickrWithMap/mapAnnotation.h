//
//  mapAnnotation.h
//  flickrWithMap
//
//  Created by Wang Tom on 2018-05-03.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface mapAnnotation : NSObject <MKAnnotation>
+ (mapAnnotation *)annotationForPlaceAndPhoto:(NSDictionary *)data;
@property (nonatomic, strong) NSDictionary *data;
@end
