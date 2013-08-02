//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Casey Frost on 7/22/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

// Tells the program to clear the universalDisplay if another operation isn't run on the result
@property (nonatomic)           BOOL        clearUniversalDisplayFlag;

// Store old values in case another operation is run on them
@property (nonatomic,strong)    NSNumber    *previousResult;
@property (nonatomic,strong)    NSNumber    *previousSecondValue;
@property (nonatomic,strong)    NSNumber    *previousSecondMultiplier;
@property (nonatomic,strong)    NSString    *previousOperator;

// Store the state of current equation being entered
@property (nonatomic,strong)    NSNumber    *firstValue;
@property (nonatomic,strong)    NSString    *operator;
@property (nonatomic,strong)    NSNumber    *secondValue;
@property (nonatomic)           BOOL        firstValueIs0;
@property (nonatomic)           BOOL        secondValueIs0;

// Store the location of the decimals if they exist. Allows for easy adding of digits after decimals without counting digits
@property (nonatomic,strong)    NSNumber    *firstMultiplier;
@property (nonatomic,strong)    NSNumber    *secondMultiplier;

- (NSString *)getSolution;

@end
