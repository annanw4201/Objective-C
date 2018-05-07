//
//  mapViewController.h
//  flickrWithMap
//
//  Created by Wang Tom on 2018-03-05.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class mapViewController;

@protocol mapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController: (mapViewController *)mapVC imageForAnnotation:(id <MKAnnotation>)annotation;
@optional - (BOOL)segueFromPlace;
@optional - (BOOL)segueFromPhotos;
@end

@interface mapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, weak) id<mapViewControllerDelegate> delegate;
@end


