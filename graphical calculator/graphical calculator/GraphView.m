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
@synthesize data = _data;

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        self.data.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self];
        translation.x += self.data.origin.x;
        translation.y += self.data.origin.y;
        self.data.origin = translation;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)setUp {
    NSLog(@"setup");
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"init frame");
    self = [super initWithFrame:frame];
    if (self) [self setUp];
    return self;
}

- (void)awakeFromNib {
    NSLog(@"awake");
    [super awakeFromNib];
    [self setUp];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.data.origin scale:self.data.scale];
}


@end
