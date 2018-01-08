//
//  GraphView.m
//  graphical calculator
//
//  Created by Wang Tom on 2018-01-08.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "GraphView.h"
#import "../AxesDrawer/AxesDrawer.h"

@implementation GraphView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat scale = 1.0f;
    [AxesDrawer drawAxesInRect:rect originAtPoint:CGPointMake(100, 200) scale:scale];
}


@end
