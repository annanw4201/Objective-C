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
@property (nonatomic, strong) calculatorBrain *brain;
@end

@implementation ViewController
@synthesize display = _display;
@synthesize enteringNumber = _enteringNumber;
@synthesize brain = _brain;

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
        [self.display setText:[self.display.text stringByAppendingString:digit]];
    }
    else {
        [self.display setText:[sender currentTitle]];
        if (![digit isEqualToString:@"0"]) {
            self.enteringNumber = YES;
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.enteringNumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    [self.display setText:[NSString stringWithFormat:@"%g", result]];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.enteringNumber = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
