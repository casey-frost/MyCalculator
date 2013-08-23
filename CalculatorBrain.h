//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Casey Frost on 7/22/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

+ (BOOL)isOperatorWith:(NSString *)entry;
+ (NSString *)refactorDisplayWith:(NSString *)completeUniversalDisplay;
+ (NSString *)evaluateWith:(NSString *)equation;
+ (NSString *)findLastOperatorWith:(NSArray *)entries;
+ (NSString *)findLastOperandWith:(NSArray *)entries;
+ (NSString *)replaceLastOperandIn:(NSString *)universalDisplay with:(NSString *)digit;

@end
