//
//  calculatorBrain.m
//  calculator
//
//  Created by Wang Tom on 2018-01-05.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import "calculatorBrain.h"

@interface calculatorBrain()
@property(nonatomic, strong) NSMutableArray *programStack;
@end

@implementation calculatorBrain: NSObject
@synthesize programStack = _programStack;
@synthesize program = _program;

- (NSMutableArray *)programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program {
    return [self.programStack copy];
}

- (void)setprogramStack: (NSMutableArray *)array {
    _programStack = array;
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand {
    NSNumber *operand = [self.programStack lastObject];
    if (operand) [self.programStack removeLastObject];
    return [operand doubleValue];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [calculatorBrain runProgram:self.programStack];
}

+ (NSString *)descriptionOfProgram:(id)program {
    return 0;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)popOperandOffStack: (NSMutableArray *)stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"-"]) {
            double secondOperand = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - secondOperand;
        }
        else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"/"]) {
            double secondOperand = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] / secondOperand;
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    return result;
}

- (void)clearState {
    [self.programStack removeAllObjects];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

@end
