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
@property (nonatomic) BOOL leadingZero;
@property (nonatomic) BOOL enteringVariable;
@property (nonatomic, strong) calculatorBrain *brain;
@end

@implementation ViewController

@synthesize resultDisplay = _resultDisplay;
@synthesize enteringNumber = _enteringNumber;
@synthesize brain = _brain;
@synthesize enteringFloatingNumber = _enteringFloatingNumber;
@synthesize leadingZero = _leadingZero;
@synthesize enteringVariable = _enteringVariable;

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
    NSString *text = [self.resultDisplay text];
    if (!self.enteringNumber && [digit isEqualToString:@"0"]) {
        self.leadingZero = YES;
        self.enteringNumber = YES;
        text = @"0";
    }
    else if (self.leadingZero && [digit isEqualToString:@"0"]) {
        text = @"0";
    }
    else if (self.leadingZero && ![digit isEqualToString:@"0"]) {
        text = digit;
        self.leadingZero = NO;
    }
    else if (self.enteringNumber) {
        text = [text stringByAppendingString:digit];
    }
    else {
        text = digit;
        self.enteringNumber = YES;
    }
    [self.resultDisplay setText:text];
}

- (IBAction)floatPressed:(UIButton *)sender {
    if (self.enteringNumber && !self.enteringFloatingNumber) {
        NSString *text = [self.resultDisplay.text stringByAppendingString:@"."];
        [self.resultDisplay setText:text];
        self.enteringFloatingNumber = YES;
        self.leadingZero = NO;
    }
    else if (!self.enteringNumber && !self.enteringFloatingNumber) {
        [self.resultDisplay setText:@"0."];
        self.enteringFloatingNumber = YES;
        self.enteringNumber = YES;
        self.leadingZero = NO;
    }
}

- (BOOL)unaryOperator: (NSString *)operator {
    return [operator isEqualToString:@"sin"] || [operator isEqualToString:@"cos"] || [operator isEqualToString:@"sqrt"];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.enteringNumber || [self unaryOperator:[sender currentTitle]]) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    [self.resultDisplay setText:[NSString stringWithFormat:@"%g", result]];
    [self.expressionDisplay setText: [calculatorBrain descriptionOfProgram:self.brain.program]];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.resultDisplay.text doubleValue]];
    [self.expressionDisplay setText: [calculatorBrain descriptionOfProgram:self.brain.program]];
    self.enteringNumber = NO;
    self.enteringFloatingNumber = NO;
    self.leadingZero = NO;
}

- (IBAction)clearPressed:(UIButton *)sender {
    [self.resultDisplay setText:@"0"];
    [self.expressionDisplay setText:@""];
    self.enteringNumber = NO;
    self.enteringFloatingNumber = NO;
    self.leadingZero = NO;
    [self.brain clearState];
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.enteringNumber) {
        [self enterPressed];
    }
    [self.brain pushVariable:[sender currentTitle]];
    [self.expressionDisplay setText: [calculatorBrain descriptionOfProgram:self.brain.program]];
    self.enteringVariable = YES;
}

- (IBAction)undoPressed:(UIButton *)sender {
    if (self.enteringNumber) {
        NSString *text = [self.resultDisplay text];
        if ([text length] > 0) {
            if ([text hasSuffix:@"."]) self.enteringFloatingNumber = NO;
            else if ([text isEqualToString:@"0"]) self.leadingZero = NO;
            self.resultDisplay.text = [text substringToIndex:[text length] - 1];
        }
        else if ([text isEqualToString:@""]) {
            double result = [self.brain calculate];
            [self.resultDisplay setText:[NSString stringWithFormat:@"%g", result]];
            self.enteringNumber = NO;
        }
    }
    else {
        [self.brain undoLastItemInStack];
        double result = [self.brain calculate];
        [self.resultDisplay setText:[NSString stringWithFormat:@"%g", result]];
        [self.expressionDisplay setText: [calculatorBrain descriptionOfProgram:self.brain.program]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
