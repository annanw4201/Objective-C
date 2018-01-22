//
//  GraphViewController.h
//  graphical calculator
//
//  Created by Wang Tom on 2018-01-08.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "splitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <splitViewBarButtonItemPresenter, UISplitViewControllerDelegate>
@property (nonatomic, strong) id program;
@end
