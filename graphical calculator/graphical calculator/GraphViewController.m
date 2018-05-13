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
#import "favoriteGraphTableViewController.h"

@interface GraphViewController () <graphViewDelegate, favoriteGraphTableViewDelegate>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation GraphViewController
@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize graphView = _graphView;
@synthesize leftNavigationItem = _leftNavigationItem;
@synthesize formulaBarButtonItem = _formulaBarButtonItem;
@synthesize favoriteBarButtonItem = _favoriteBarButtonItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view didload GraphVC");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self setLeftNavigationItem:self.splitViewController.displayModeButtonItem];
        [self setFormulaBarButtonItem:self.formulaBarButtonItem];
        self.favoriteBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Favorite" style:UIBarButtonItemStylePlain target:self action:@selector(favoritePressed:)];
        NSMutableArray *toolBarItems = [self.toolBar.items mutableCopy];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolBarItems addObjectsFromArray:[[NSArray alloc] initWithObjects:self.leftNavigationItem, flexibleSpace, self.formulaBarButtonItem, flexibleSpace, self.favoriteBarButtonItem, nil]];
        [self.toolBar setItems:toolBarItems];
        self.splitViewController.delegate = self;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    NSLog(@"viewWillAppear");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"setPrgm GraphViewVC");
    _program = program;
    NSString *desciptionOfProgram = [calculatorBrain topOfDescriptionOfProgram:program];
    NSString *formulaStr = [NSString stringWithFormat:@"y = %@", desciptionOfProgram];
    if (![desciptionOfProgram isEqualToString:@""]) {
        UIBarButtonItem *formulaButton = [[UIBarButtonItem alloc] initWithTitle:formulaStr style:UIBarButtonItemStylePlain target:nil action:nil];
        [self setFormulaBarButtonItem:formulaButton];
    }
    [self.graphView setNeedsDisplay];
}

- (UIBarButtonItem *)formulaBarButtonItem {
    NSLog(@"formula item");
    if (!_formulaBarButtonItem) {
        _formulaBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Graph" style:UIBarButtonItemStylePlain target:self action:nil];
    }
    return _formulaBarButtonItem;
}

- (void)setFormulaBarButtonItem:(UIBarButtonItem *)formulaBarButtonItem {
    if (_formulaBarButtonItem != formulaBarButtonItem) {
        NSMutableArray *items = [self.toolBar.items mutableCopy];
        NSUInteger index = [items indexOfObject:_formulaBarButtonItem];
        // replace the new formula bar button item in toolbar
        if (formulaBarButtonItem && index != NSNotFound) {
            [items replaceObjectAtIndex:index withObject:formulaBarButtonItem];
        }
        self.toolBar.items = items;
        _formulaBarButtonItem = formulaBarButtonItem;
    }
}

- (void)setLeftNavigationItem:(UIBarButtonItem *)leftNavigationItem {
    if (_leftNavigationItem != leftNavigationItem) {
        NSLog(@"set bar button item now");
        NSMutableArray *items = [self.toolBar.items mutableCopy];
        NSUInteger index = [items indexOfObject:self.leftNavigationItem];
        // replace the new nav bar button item in toolbar
        if (leftNavigationItem && index != NSNotFound) {
            NSLog(@"replace navigation item");
            [items replaceObjectAtIndex:index withObject:leftNavigationItem];
        }
        self.toolBar.items = items;
        _leftNavigationItem = leftNavigationItem;
    }
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        //NSLog(@"hidden");
    }
    if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
        //NSLog(@"all visible");
    }
    if (displayMode == UISplitViewControllerDisplayModePrimaryOverlay) {
        //NSLog(@"overlay");
        [self setLeftNavigationItem:svc.displayModeButtonItem];
    }
}

- (double)yValueOfx:(CGFloat)xValue {
    //NSLog(@"yValOfX");
    NSDictionary *variableDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:xValue], @"x", nil];
    return [calculatorBrain runProgram:self.program usingVariableValues:variableDict];
}

- (void)setGraphView:(GraphView *)graphView {
    NSLog(@"set graph view");
    _graphView = graphView;
    [graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    graphView.delegate = self;
    
    id originX = [[NSUserDefaults standardUserDefaults] valueForKey:@"origin.x"];
    id originY = [[NSUserDefaults standardUserDefaults] valueForKey:@"origin.y"];
    id scale = [[NSUserDefaults standardUserDefaults] valueForKey:@"scale"];
    if (!originX && !originY) {
        _origin.x = self.graphView.bounds.size.width / 2;
        _origin.y = self.graphView.bounds.size.height / 2;
    }
    if (originX) _origin.x = [[[NSUserDefaults standardUserDefaults] valueForKey:@"origin.x"] floatValue];
    if (originY) _origin.y = [[[NSUserDefaults standardUserDefaults] valueForKey:@"origin.y"] floatValue];
    if (scale) self.scale = [scale floatValue];
    
    [self.graphView setNeedsDisplay];
}

- (void)favoritePressed:(UIBarButtonItem *)sender {
    NSLog(@"fav pressed");
    UIStoryboard *ipadStoryBoard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    UIViewController *ipadFavoriteGraphTableVC = [ipadStoryBoard instantiateViewControllerWithIdentifier:@"ipadFavoriteGraphTableVC"];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && ipadFavoriteGraphTableVC) {
        [ipadFavoriteGraphTableVC setPreferredContentSize:CGSizeMake(300, 400)];
        ipadFavoriteGraphTableVC.modalPresentationStyle = UIModalPresentationPopover;
        
        // set up popover for favorite graph view controller
        UIPopoverPresentationController *popoverVC = ipadFavoriteGraphTableVC.popoverPresentationController;
        popoverVC.barButtonItem = sender;
        popoverVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
        
        NSArray *programArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"programArray"];
        if ([ipadFavoriteGraphTableVC isKindOfClass:[favoriteGraphTableViewController class]]) {
            NSLog(@"set table");
            [(favoriteGraphTableViewController *)ipadFavoriteGraphTableVC setProgramArray:programArray];
            [(favoriteGraphTableViewController *)ipadFavoriteGraphTableVC setDelegate:self];
        }
        [self presentViewController:ipadFavoriteGraphTableVC animated:NO completion:nil];
    }
}

- (IBAction)addToFavoritePressed:(UIButton *)sender {
    NSLog(@"add to favorite");
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *programArray = [[standardUserDefaults valueForKey:@"programArray"] mutableCopy];
    if (!programArray) {
        programArray = [[NSMutableArray alloc] init];
    }
    if (self.program) [programArray addObject:self.program];
    //NSLog(@"top is %@", [calculatorBrain topOfDescriptionOfProgram:self.program]);
    [standardUserDefaults setObject:programArray forKey:@"programArray"];
    [standardUserDefaults synchronize];
}

#pragma mark - favoriteGraphTableViewDelegate
- (void)favoriteGraphTableViewController:(id)sender chosenProgram:(id)program {
    self.program = program;
}

- (void)favoriteGraphTableViewController:(id)sender deleteProgram:(NSInteger)toBeRemovedIndex {
    NSLog(@"deletePrgm");
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *programArray = [[standardUserDefaults valueForKey:@"programArray"] mutableCopy];
    [programArray removeObjectAtIndex:toBeRemovedIndex];
    [standardUserDefaults setObject:programArray forKey:@"programArray"];
    [standardUserDefaults synchronize];
    if ([sender isKindOfClass:[favoriteGraphTableViewController class]]) {
        [(favoriteGraphTableViewController *)sender setProgramArray:programArray];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showFavorite"]) {
        NSLog(@"showFav");
        if ([segue.destinationViewController isKindOfClass:[favoriteGraphTableViewController class]]) {
            NSArray *programArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"programArray"];
            [(favoriteGraphTableViewController *)segue.destinationViewController setProgramArray:programArray];
            [(favoriteGraphTableViewController *)segue.destinationViewController setDelegate:self];
        }
    }
}


@end
