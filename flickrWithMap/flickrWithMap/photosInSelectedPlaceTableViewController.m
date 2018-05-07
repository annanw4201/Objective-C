//
//  photosInSelectedPlaceTableViewController.m
//  topPlaces
//
//  Created by Wang Tom on 2018-01-29.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "photosInSelectedPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "photoImageViewController.h"
#import "cachePhoto.h"
#import "mapViewController.h"
#import "mapAnnotation.h"

#define maxPhotos 20

@interface photosInSelectedPlaceTableViewController () <mapViewControllerDelegate>
@property (nonatomic, strong)NSArray *photos;
@end

@implementation photosInSelectedPlaceTableViewController
@synthesize place = _place;
@synthesize photos = _photos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePhotos {
    if (self.place) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("download photos in a place", NULL);
        dispatch_async(downloadQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photos = [FlickrFetcher photosInPlace:self.place maxResults:maxPhotos];
                self.navigationItem.rightBarButtonItem = NULL;
            });
        });
    }
}

- (void)updateDetailVC {
    id navigationVC = [[self.splitViewController viewControllers] lastObject];
    if ([navigationVC isKindOfClass:[UINavigationController class]]) {
        id detailVC = [navigationVC topViewController];
        if ([detailVC isKindOfClass:[mapViewController class]]) {
            [(mapViewController *)detailVC setDelegate:self];
            [(mapViewController *)detailVC setAnnotations:[self mapAnnotations]];
        }
    }
}

- (void)setPhotos:(NSArray *)photos {
    //NSLog(@"setPhotos %@", photos);
    _photos = photos;
    [self.tableView reloadData];
    [self updateDetailVC];
}

- (void)setPlace:(NSDictionary *)place {
    //NSLog(@"setPlace %@", place);
    _place = place;
    [self updatePhotos];
    [self updateDetailVC];
    //[self.tableView reloadData];
}

- (NSArray *)mapAnnotations {
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos) {
        mapAnnotation *annotation = [mapAnnotation annotationForPlaceAndPhoto:photo];
        [annotations addObject:annotation];
    }
    return annotations;
}

- (UIImage *)mapViewController:(mapViewController *)mapVC imageForAnnotation:(id<MKAnnotation>)annotation {
    mapAnnotation *anno = (mapAnnotation *)annotation;
    NSURL *imgURL = [FlickrFetcher urlForPhoto:anno.data format:FlickrPhotoFormatSquare];
    NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
    return imgData ? [UIImage imageWithData:imgData] : nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photosInSelectedPlaceCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = [self.photos objectAtIndex:[indexPath row]];
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *detailText =[photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
    if (title == nil && detailText != nil) {
        [cell.textLabel setText:detailText];
    }
    else if (title == nil && detailText == nil) {
        [cell.textLabel setText:@"Unknown"];
    }
    else {
        [cell.textLabel setText:title];
        [cell.detailTextLabel setText:detailText];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [cachePhoto savePhoto:[self.photos objectAtIndex:[indexPath row]]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        id navigationVC = [[self.splitViewController viewControllers] lastObject];
        if ([navigationVC isKindOfClass:[UINavigationController class]]) {
            id detailMapVC = [navigationVC topViewController];
            if ([detailMapVC isKindOfClass:[mapViewController class]]) {
                [detailMapVC performSegueWithIdentifier:@"showPhotoImage" sender:[self.photos objectAtIndex:[indexPath row]]];
            }
            else if ([detailMapVC isKindOfClass:[photoImageViewController class]]) {
                [detailMapVC setPhoto:[self.photos objectAtIndex:[indexPath row]]];
            }
        }
    }
    else {
        [self performSegueWithIdentifier:@"showPhotoImage" sender:[self.photos objectAtIndex:[indexPath row]]];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showPhotoImage"]) {
        if ([sender isKindOfClass:[NSDictionary class]]) {
            NSDictionary *photo = sender;
            [segue.destinationViewController setPhoto:photo];
            //[segue.destinationViewController setTitle:[cell.textLabel text]];
        }
    }
}

@end
