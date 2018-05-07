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
#import "mapAnnotation.h"
#import "photosInSelectedPlaceTableViewController.h"
#import "topPlacesTableViewController.h"
#import "FlickrFetcher.h"

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
    [self zoomMap];
}

- (void) zoomMap {
    MKMapRect mapRect = MKMapRectNull;
    for (id<MKAnnotation> annotation in self.annotations) {
        MKMapPoint point = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect mapRectForAnnotation = MKMapRectMake(point.x, point.y, 0.3, 0.3);
        mapRect = MKMapRectUnion(mapRect, mapRectForAnnotation);
    }
    [self.mapView setVisibleMapRect:mapRect animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *aview = [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapVC"];
    if (!aview) {
        aview = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapVC"];
        aview.canShowCallout = YES;
        aview.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    aview.annotation = annotation;
    return aview;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"select annotation");
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    view.leftCalloutAccessoryView = spinner;
    
    __block UIImage *image = nil;
    dispatch_queue_t downloadQueue = dispatch_queue_create("download thumbnails", NULL);
    dispatch_async(downloadQueue, ^{
        image = [self.delegate mapViewController:self imageForAnnotation:view.annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!image) view.leftCalloutAccessoryView = nil;
            else {
                view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
            }
        });
    });
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"callout tapped");
    id tabVC = [[self.splitViewController viewControllers] firstObject];
    mapAnnotation *anno = view.annotation;
    if ([tabVC isKindOfClass:[UITabBarController class]]) {
        id firstNavigationVC = [[(UITabBarController *)tabVC viewControllers] firstObject];
        id topVC = [firstNavigationVC topViewController];
        if ([topVC isKindOfClass:[topPlacesTableViewController class]]) {
            [(topPlacesTableViewController *)topVC performSegueWithIdentifier:@"showPhotosInSelectedPlace" sender:anno.data];
        }
        else if ([topVC isKindOfClass:[photosInSelectedPlaceTableViewController class]]) {
            [self performSegueWithIdentifier:@"showPhotoImage" sender:anno.data];
        }
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([self.delegate segueFromPlace] == YES) {
            [self performSegueWithIdentifier:@"showPhotosInSelectedPlace" sender:anno.data];
        }
        else if ([self.delegate segueFromPhotos] == YES) {
            [self performSegueWithIdentifier:@"showPhotoImage" sender:anno.data];
        }
    }
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
            [segue.destinationViewController setTitle:[photo objectForKey:FLICKR_PHOTO_TITLE]];
        }
    }
    else if ([segue.identifier isEqualToString:@"showPhotosInSelectedPlace"]) {
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSLog(@"show photos in that place");
            NSDictionary *photoPlace = sender;
            [segue.destinationViewController setPlace: photoPlace];
            [segue.destinationViewController setTitle:[photoPlace objectForKey:FLICKR_CITYNAME]];
        }
    }
}


@end
