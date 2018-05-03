//
//  recentPhotoTableViewController.m
//  topPlaces
//
//  Created by Wang Tom on 2018-01-28.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "recentViewedTableViewController.h"
#import "FlickrFetcher.h"
#import "cachePhoto.h"
#import "photoImageViewController.h"
#import "mapViewController.h"

@interface recentViewedTableViewController ()
@property (nonatomic, weak) NSArray *photos;
@end

@implementation recentViewedTableViewController
@synthesize photos = _photos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setTitle:@"Recent Viewed"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("retrieve recent viewed photos", NULL);
    dispatch_async(downloadQueue, ^{
        self.photos = [cachePhoto retrieveAllPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = NULL;
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentViewedCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = [self.photos objectAtIndex:[indexPath row]];
    NSString *detailText = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        id navigationVC = [[self.splitViewController viewControllers] lastObject];
        if ([navigationVC isKindOfClass:[UINavigationController class]]) {
            id detialMapVC = [navigationVC topViewController];
            if ([detialMapVC isKindOfClass:[mapViewController class]]) {
                [detialMapVC performSegueWithIdentifier:@"showPhotoImage" sender:[self.photos objectAtIndex:[indexPath row]]];
                NSLog(@"show image");
            }
            else if ([detialMapVC isKindOfClass:[photoImageViewController class]]) {
                [detialMapVC setPhoto:[self.photos objectAtIndex:[indexPath row]]];
                NSLog(@"detial view image");
            }
        }
    }
    else {
        [self performSegueWithIdentifier:@"showPhotoImage" sender:[tableView cellForRowAtIndexPath:indexPath]];
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
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = sender;
            NSInteger row = [[self.tableView indexPathForCell:cell] row];
            NSDictionary *photo = [self.photos objectAtIndex:row];
            [segue.destinationViewController setPhoto:photo];
            //[segue.destinationViewController setTitle:[cell.textLabel text]];
        }
    }
}

@end
