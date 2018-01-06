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
@end
