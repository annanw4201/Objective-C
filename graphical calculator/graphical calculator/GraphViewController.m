//
//  GraphViewController.m
//  graphical calculator
//
//  Created by Wang Tom on 2018-01-08.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "calculatorBrain.h"

@interface GraphViewController () <graphViewData>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *formulaLabel;
@end

@implementation GraphViewController
@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize graphView = _graphView;
@synthesize barButtonItem = _barButtonItem;
@synthesize formulaLabel = _formulaLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarButtonItem:self.splitViewController.displayModeButtonItem];
    [self.formulaLabel setText:[NSString stringWithFormat:@"y = 0"]];
    self.splitViewController.delegate = self;
    // Do any additional setup after loading the view.
}

-(CGFloat)scale {
    if (!_scale) _scale = 50.0f;
    return _scale;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    [self.graphView setNeedsDisplay];
}

- (void)setOrigin:(CGPoint)origin {
    _origin = origin;
    [self.graphView setNeedsDisplay];
}

- (void)setProgram:(id)program {
    _program = program;
    [self.formulaLabel setText:[NSString stringWithFormat:@"y = %@", [calculatorBrain descriptionOfProgram:program]]];
    [self.graphView setNeedsDisplay];
}

- (double)yValueOfx:(CGFloat)xValue {
    NSDictionary *variableDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:xValue], @"x", nil];
    return [calculatorBrain runProgram:self.program usingVariableValues:variableDict];
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    [graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    graphView.data = self;
    CGPoint center = CGPointMake(self.graphView.bounds.size.width / 2, self.graphView.bounds.size.height / 2);
    _origin = center;
    [self.graphView setNeedsDisplay];
    NSLog(@"set graph view");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBarButtonItem:(UIBarButtonItem *)barButtonItem {
    if (_barButtonItem != barButtonItem) {
        NSLog(@"set bar button item now");
        NSMutableArray *items = [self.toolBar.items mutableCopy];
        // remove the item in toolbar if it has one presented
        if (_barButtonItem) [items removeObject:_barButtonItem];
        // insert the new item in toolbar
        if (barButtonItem) [items addObject:barButtonItem];
        self.toolBar.items = items;
        _barButtonItem = barButtonItem;
    }
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        NSLog(@"hidden");
    }
    if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        NSLog(@"all visible");
    }
    if (displayMode == UISplitViewControllerDisplayModePrimaryOverlay) {
        NSLog(@"overlay");
        svc.displayModeButtonItem.title = @"Calculator";
        [self setBarButtonItem:svc.displayModeButtonItem];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
