//
//  calculatorBrain.m
//  calculator
//
//  Created by Wang Tom on 2018-01-05.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "calculatorBrain.h"

@interface calculatorBrain()
@property(nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation calculatorBrain: NSObject
@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack {
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void)setOperandStack: (NSMutableArray *)array {
    _operandStack = array;
}

- (void)pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand {
    NSNumber *operand = [self.operandStack lastObject];
    if (operand) [self.operandStack removeLastObject];
    return [operand doubleValue];
}

- (double)performOperation:(NSString *)operation {
    double result = 0;
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"-"]) {
        double secondOperand = [self popOperand];
        result = [self popOperand] - secondOperand;
    }
    else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"/"]) {
        double secondOperand = [self popOperand];
        result = [self popOperand] / secondOperand;
    }
    [self pushOperand:result];
    return result;
}

@end
