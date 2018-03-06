//
//  mapViewController.m
//  flickrWithMap
//
//  Created by Wang Tom on 2018-03-05.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "mapViewController.h"
#import <MapKit/MapKit.h>

@interface mapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation mapViewController
@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
