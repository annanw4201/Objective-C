//
//  ViewController.m
//  calculator
//
//  Created by Wang Tom on 2018-01-05.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "ViewController.h"
#import "calculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL enteringNumber;
@property (nonatomic) BOOL enteringFloatingNumber;
@property (nonatomic, strong) calculatorBrain *brain;
@end

@implementation ViewController

@synthesize resultDisplay = _resultDisplay;
@synthesize enteringNumber = _enteringNumber;
@synthesize brain = _brain;
@synthesize enteringFloatingNumber = _enteringFloatingNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (calculatorBrain *)brain {
    if (!_brain) {
        _brain = [[calculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.enteringNumber) {
        [self.resultDisplay setText:[self.resultDisplay.text stringByAppendingString:digit]];
    }
    else {
        [self.resultDisplay setText:[sender currentTitle]];
        if (![digit isEqualToString:@"0"]) {
            self.enteringNumber = YES;
        }
    }
}

- (IBAction)floatPressed:(UIButton *)sender {
    if (self.enteringNumber && !self.enteringFloatingNumber) {
        NSString *text = [self.resultDisplay.text stringByAppendingString:@"."];
        [self.resultDisplay setText:text];
        self.enteringFloatingNumber = YES;
    }
    else if (!self.enteringNumber && !self.enteringFloatingNumber) {
        [self.resultDisplay setText:@"0."];
        self.enteringFloatingNumber = YES;
        self.enteringNumber = YES;
    }
}


- (IBAction)operationPressed:(UIButton *)sender {
    if (self.enteringNumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    [self.expressionDisplay setText: [self.expressionDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", operation]]];
    double result = [self.brain performOperation:operation];
    [self.resultDisplay setText:[NSString stringWithFormat:@"%g", result]];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.resultDisplay.text doubleValue]];
    [self.expressionDisplay setText:[self.expressionDisplay.text stringByAppendingString: [NSString stringWithFormat:@"%@ ", self.resultDisplay.text]]];
    self.enteringNumber = NO;
    self.enteringFloatingNumber = NO;
}

- (IBAction)clearPressed:(UIButton *)sender {
    [self.resultDisplay setText:@"0"];
    [self.expressionDisplay setText:@""];
    self.enteringNumber = NO;
    self.enteringFloatingNumber = NO;
    [self.brain clearState];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
