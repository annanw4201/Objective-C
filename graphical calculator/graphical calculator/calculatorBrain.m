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
@property(nonatomic, strong) NSMutableDictionary *variableDict;
@end

@implementation calculatorBrain: NSObject
@synthesize programStack = _programStack;
@synthesize program = _program;
@synthesize variableDict = _variableDict;

- (NSMutableArray *)programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program {
    return [self.programStack copy];
}

- (NSDictionary *)variables {
    return [self.variableDict copy];
}

- (NSMutableDictionary *)variableDict {
    if (!_variableDict) {
        _variableDict = [[NSMutableDictionary alloc] init];
    }
    return _variableDict;
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
    if (operation) [self.programStack addObject:operation];
    //return [calculatorBrain runProgram:self.programStack];
    return [calculatorBrain runProgram:self.program usingVariableValues:self.variableDict];
}

+ (NSString *)getDescription:(NSMutableArray *)stack {
    NSString *result = @"";
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [NSString stringWithFormat:@"%@", topOfStack];
        return result;
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            NSString *secondOperand = [self getDescription:stack];
            result = [NSString stringWithFormat:@"(%@+%@)",[self getDescription:stack], secondOperand];
            //return result;
        }
        else if ([operation isEqualToString:@"-"]) {
            NSString *secondOperand = [self getDescription:stack];
            result = [NSString stringWithFormat:@"(%@-%@)",[self getDescription:stack], secondOperand];
            //return result;
        }
        else if ([operation isEqualToString:@"*"]) {
            NSString *secondOperand = [self getDescription:stack];
            result = [NSString stringWithFormat:@"%@*%@",[self getDescription:stack], secondOperand];
            //return result;
        }
        else if ([operation isEqualToString:@"/"]) {
            NSString *secondOperand = [self getDescription:stack];
            result = [NSString stringWithFormat:@"%@/%@",[self getDescription:stack], secondOperand];
            //return result;
        }
        else if ([operation isEqualToString:@"sqrt"]) {
            result = [NSString stringWithFormat:@"sqrt(%@)",[self getDescription:stack]];
            //return result;
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = [NSString stringWithFormat:@"sin(%@)",[self getDescription:stack]];
            //return result;
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = [NSString stringWithFormat:@"cos(%@)",[self getDescription:stack]];
            //return result;
        }
        else {
            result = operation;
            //return operation;
        }
    }
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSString *description = @"";
    NSMutableArray *stack = [program mutableCopy];
    if ([stack count] == 0) return @"0";
    while ([stack count]) {
        description = [description stringByAppendingString:[self getDescription:stack]];
        if ([stack count] > 0) {
            description = [description stringByAppendingString:@","];
        }
        //NSLog(@"--%@", [NSString stringWithFormat:@"descrip: %@", description]);
    }
    return  description;
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
    [self.variableDict removeAllObjects];
}

- (void)pushVariable:(NSString *)variable {
    /*
    NSNumber *value = nil;
    if ([variable isEqualToString:@"x"]) value = [NSNumber numberWithInt:3];
    else if ([variable isEqualToString:@"y"]) value = [NSNumber numberWithInt:6];
    */
    [self.programStack addObject:variable];
    [self.variableDict setObject:variable forKey:variable];
}

+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableDict {
    double result = 0;
    NSMutableArray *programCopy = [program mutableCopy];
    for (id operand in program) {
        NSNumber *value = nil;
        if ([operand isKindOfClass:[NSString class]]) {
            value = [variableDict valueForKey:operand];
        }
        NSUInteger index = [programCopy indexOfObject:operand];
        if (value) {
            [programCopy replaceObjectAtIndex:index withObject:value];
        }
    }
    result = [self popOperandOffStack:programCopy];
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (id obj in program) {
        if ([obj isKindOfClass:[NSString class]]) {
            [set addObject:obj];
            //NSLog(@"obj: %@", obj);
        }
    }
    if ([set count] == 0) set = nil;
    return set;
}

- (void)undoLastItemInStack {
    [self.programStack removeLastObject];
}

- (double)calculate {
    return [calculatorBrain runProgram:self.program usingVariableValues:self.variableDict];
}

+ (NSString *)topOfDescriptionOfProgram:(id)program {
    NSString *description = @"";
    NSMutableArray *stack = [program mutableCopy];
    if ([stack count] == 0) return @"0";
    description = [self getDescription:stack];
    return description;
}

@end
