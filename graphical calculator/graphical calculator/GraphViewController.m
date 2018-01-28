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
@end

@implementation GraphViewController
@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize graphView = _graphView;
@synthesize navigationItem = _navigationItem;
@synthesize formulaBarButtonItem = _formulaBarButtonItem;
@synthesize favoriteBarButtonItem = _favoriteBarButtonItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem:self.splitViewController.displayModeButtonItem];
    [self setFormulaBarButtonItem:self.formulaBarButtonItem];
    self.favoriteBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Favorite" style:UIBarButtonItemStylePlain target:self action:@selector(favoritePressed:)];
    NSMutableArray *toolBarItems = [self.toolBar.items mutableCopy];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolBarItems addObjectsFromArray:[[NSArray alloc] initWithObjects:_navigationItem, flexibleSpace, _formulaBarButtonItem, flexibleSpace, _favoriteBarButtonItem, nil]];
    [self.toolBar setItems:toolBarItems];
    [self setTitle:@"Graph"];
    self.splitViewController.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)savePreference {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setFloat:self.scale forKey:@"scale"];
        [standardUserDefaults setFloat:self.origin.x forKey:@"origin.x"];
        [standardUserDefaults setFloat:self.origin.y forKey:@"origin.y"];
        [standardUserDefaults synchronize];
    }
}

-(CGFloat)scale {
    if (!_scale) _scale = 50.0f;
    return _scale;
}

-(CGPoint)origin {
    return _origin;
}

- (void)setScale:(CGFloat)scale {
    //NSLog(@"set scale");
    _scale = scale;
    [self.graphView setNeedsDisplay];
    [self savePreference];
}

- (void)setOrigin:(CGPoint)origin {
    //NSLog(@"set origin");
    _origin = origin;
    [self.graphView setNeedsDisplay];
    [self savePreference];
}

- (void)setProgram:(id)program {
    _program = program;
    NSString *formulaStr = [NSString stringWithFormat:@"y = %@", [calculatorBrain descriptionOfProgram:program]];
    if (![formulaStr isEqualToString:@""]) {
        UIBarButtonItem *formulaButton = [[UIBarButtonItem alloc] init];
        [formulaButton setTitle:formulaStr];
        [self setFormulaBarButtonItem:formulaButton];
    }
    [self.graphView setNeedsDisplay];
}

- (double)yValueOfx:(CGFloat)xValue {
    NSDictionary *variableDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:xValue], @"x", nil];
    return [calculatorBrain runProgram:self.program usingVariableValues:variableDict];
}

- (void)setGraphView:(GraphView *)graphView {
    NSLog(@"set graph view");
    _graphView = graphView;
    [graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    graphView.data = self;
    
    id originX = [[NSUserDefaults standardUserDefaults] valueForKey:@"origin.x"];
    id originY = [[NSUserDefaults standardUserDefaults] valueForKey:@"origin.y"];
    id scale = [[NSUserDefaults standardUserDefaults] valueForKey:@"scale"];
    if (!originX && !originY) {
        _origin.x = self.graphView.bounds.size.width / 2;
        _origin.y = self.graphView.bounds.size.height / 2;
    }
    if (originX) {
        _origin.x = [[[NSUserDefaults standardUserDefaults] valueForKey:@"origin.x"] floatValue];
    }
    if (originY) {
        _origin.y = [[[NSUserDefaults standardUserDefaults] valueForKey:@"origin.y"] floatValue];
    }
    if (scale) {
        self.scale = [scale floatValue];
    }
    [self.graphView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)formulaBarButtonItem {
    if (!_formulaBarButtonItem) {
        _formulaBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Graph" style:UIBarButtonItemStylePlain target:self action:nil];
    }
    return _formulaBarButtonItem;
}

- (void)setFormulaBarButtonItem:(UIBarButtonItem *)formulaBarButtonItem {
    if (_formulaBarButtonItem != formulaBarButtonItem) {
        NSLog(@"set formula");
        NSMutableArray *items = [self.toolBar.items mutableCopy];
        NSUInteger index = [items indexOfObject:_formulaBarButtonItem];
        if (index == NSNotFound) NSLog(@"fefe");
        NSLog(@"%lu", (unsigned long)index);
        //if (_formulaBarButtonItem) [items removeObject:_formulaBarButtonItem];
        
        if (formulaBarButtonItem && index != NSNotFound) {
            [items replaceObjectAtIndex:index withObject:formulaBarButtonItem];
        }
        _formulaBarButtonItem = formulaBarButtonItem;
        self.toolBar.items = items;
    }
}

- (void)setNavigationItem:(UIBarButtonItem *)navigationItem {
    if (_navigationItem != navigationItem) {
        NSLog(@"set bar button item now");
        NSMutableArray *items = [self.toolBar.items mutableCopy];
        NSUInteger index = [items indexOfObject:_navigationItem];
        // remove the item in toolbar if it has one presented
        // insert the new item in toolbar
        if (navigationItem && index != NSNotFound) {
            [items replaceObjectAtIndex:index withObject:navigationItem];
        }
        self.toolBar.items = items;
        _navigationItem = navigationItem;
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
        [self setNavigationItem:svc.displayModeButtonItem];
    }
}

- (void)favoritePressed:(UIBarButtonItem *)sender {
    NSLog(@"fav pressed");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    UIViewController *favoriteGraphTableVC = [storyBoard instantiateViewControllerWithIdentifier:@"favoriteGraphTableVC"];
    [favoriteGraphTableVC setPreferredContentSize:CGSizeMake(300, 400)];
    favoriteGraphTableVC.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popoverVC = favoriteGraphTableVC.popoverPresentationController;
    popoverVC.barButtonItem = sender;
    popoverVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:favoriteGraphTableVC animated:NO completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showFavorite"]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        UIViewController *favoriteGraphTableVC = [storyBoard instantiateViewControllerWithIdentifier:@"favoriteGraphTableVC"];
        [self presentViewController:favoriteGraphTableVC animated:NO completion:nil];
    }
}


@end
