//
//  calculatorBrain.h
//  calculator
//
//  Created by Wang Tom on 2018-01-05.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface calculatorBrain : NSObject
- (void)pushOperand: (double)operand;
- (double)performOperation: (NSString *)operation;
- (void)clearState;
- (void)pushVariable: (NSString *)variable;

@property (readonly) id program;
+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
@end
