//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Casey Frost on 7/22/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

+ (NSString *)replaceLastOperandIn:(NSString *)universalDisplay with:(NSString *)digit;
+ (NSNumber *)evaluateEquation:(NSString *)string;

@end
