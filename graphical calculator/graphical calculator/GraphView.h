//
//  GraphView.h
//  graphical calculator
//
//  Created by Wang Tom on 2018-01-08.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol graphViewData
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@end

@interface GraphView : UIView
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
@property (nonatomic, weak) IBOutlet id<graphViewData>data;
@end
