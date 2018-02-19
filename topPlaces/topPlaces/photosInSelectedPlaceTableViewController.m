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

#define maxPhotos 20

@interface photosInSelectedPlaceTableViewController ()
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
    if (_place) {
        self.photos = [FlickrFetcher photosInPlace:self.place maxResults:maxPhotos];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPhotos:(NSArray *)photos {
    //NSLog(@"setPhotos %@", photos);
    _photos = photos;
    [self.tableView reloadData];
}

- (void)setPlace:(NSDictionary *)place {
    //NSLog(@"setPlace %@", place);
    _place = place;
    //[self.tableView reloadData];
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
    [self performSegueWithIdentifier:@"showPhotoImage" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
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
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSDictionary *photo = [self.photos objectAtIndex:[indexPath row]];
            [segue.destinationViewController setPhoto:photo];
            [segue.destinationViewController setTitle:[cell.textLabel text]];
        }
    }
}


@end
