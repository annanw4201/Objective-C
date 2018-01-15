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

- (CGFloat)yPointToPixel:(double)yPoint withOrigin:(CGPoint)origin usingScale:(CGFloat)scale {
    return origin.y - yPoint * scale;
}

- (CGFloat)xPixelToPoint:(CGFloat)xPixel withOrigin:(CGPoint)origin usingScale:(CGFloat)scale {
    return (xPixel - origin.x) / scale;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGPoint origin = self.data.origin;
    CGFloat scale = self.data.scale;
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:origin scale:scale];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextStrokePath(context);
    [[UIColor redColor] setFill];
    CGFloat widthPixels = rect.size.width;
    for (CGFloat xPixel = 0.0f; xPixel < widthPixels; xPixel += 1 / self.contentScaleFactor) {
        double yValue = [self.data yValueOfx:[self xPixelToPoint:xPixel withOrigin:origin usingScale:scale]];
        CGFloat yPixel = [self yPointToPixel:yValue withOrigin:origin usingScale:scale];
        //NSLog(@"x and y: %f, %f", [self xPixelToPoint:xPixel withOrigin:origin usingScale:scale], yPixel);
        CGContextFillRect(context, CGRectMake(xPixel, yPixel, 1.0, 1.0));
    }
}


@end
