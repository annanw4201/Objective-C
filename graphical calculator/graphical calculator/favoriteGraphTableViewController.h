//
//  favoriteGraphTableViewController.h
//  graphical calculator
//
//  Created by Wang Tom on 2018-01-27.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class favoriteGraphTableViewController;

@protocol favoriteGraphTableViewDelegate
- (void)favoriteGraphTableViewController: sender chosenProgram:(id)program;
- (void)favoriteGraphTableViewController:(id)sender deleteProgram:(NSInteger)toBeRemovedIndex;
@end

@interface favoriteGraphTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *programArray;
@property (nonatomic, weak) id<favoriteGraphTableViewDelegate>delegate;
@end
