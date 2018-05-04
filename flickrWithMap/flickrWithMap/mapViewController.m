//
//  mapViewController.m
//  flickrWithMap
//
//  Created by Wang Tom on 2018-03-05.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "mapViewController.h"
#import <MapKit/MapKit.h>
#import "photoImageViewController.h"

@interface mapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation mapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    // Do any additional setup after loading the view.
    [self updateMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations {
    _annotations = annotations;
    [self updateMapView];
}

- (void)updateMapView {
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *aview = [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapVC"];
    if (!aview) {
        aview = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapVC"];
        aview.canShowCallout = YES;
        aview.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aview.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    aview.annotation = annotation;
    return aview;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"select annotation");
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:view.annotation];
    [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showPhotoImage"]) {
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *photo = sender;
            [segue.destinationViewController setPhoto:photo];
        }
    }
}


@end
