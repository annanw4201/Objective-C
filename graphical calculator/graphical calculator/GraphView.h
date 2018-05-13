//
//  GraphView.h
//  graphical calculator
//
//  Created by Wang Tom on 2018-01-08.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol graphViewDelegate
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
- (double)yValueOfx:(CGFloat)xValue;
@end

@interface GraphView : UIView
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
@property (nonatomic, weak) IBOutlet id<graphViewDelegate>delegate;
@end
