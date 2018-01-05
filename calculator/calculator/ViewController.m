//
//  ViewController.m
//  calculator
//
//  Created by Wang Tom on 2018-01-05.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) BOOL enteringNumber;
@end

@implementation ViewController
@synthesize display;
@synthesize enteringNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)digitPressed:(id)sender {
    NSString *digit = [sender currentTitle];
    if (enteringNumber) {
        [self.display setText:[self.display.text stringByAppendingString:digit]];
    }
    else {
        [self.display setText:[sender currentTitle]];
        enteringNumber = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
