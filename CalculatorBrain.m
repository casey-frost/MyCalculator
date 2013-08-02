//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Casey Frost on 7/22/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

-(id)init
{
    if (self = [super init])
    {
        self.clearUniversalDisplayFlag  =   NO;
        self.previousResult             =   nil;
        self.previousSecondValue        =   nil;
        self.previousOperator           =   nil;
        self.firstValue                 =   nil;
        self.operator                   =   nil;
        self.secondValue                =   nil;
        self.firstValueIs0              =   NO;
        self.secondValueIs0             =   NO;
        self.firstMultiplier            =   [NSNumber numberWithInt:1];
        self.secondMultiplier           =   [NSNumber numberWithInt:1];
        self.previousSecondMultiplier   =   [NSNumber numberWithInt:1];
    }
    return self;
}

// Does the math portion of the App and resets many of the variables while saving their old values
- (NSString *)getSolution
{
    // Convert NSNumbers to doubles
    double firstValueDouble = [self.firstValue doubleValue];
    double secondValueDouble = [self.secondValue doubleValue];
    
    // Default to 0 for division of 0 as assignment stated it should return
    double result = 0;
    
    // Find operation
    if ([self.operator isEqualToString:@"+"]){
        result = firstValueDouble + secondValueDouble;
    }else if ([self.operator isEqualToString:@"-"]){
        result = firstValueDouble - secondValueDouble;
    }else if ([self.operator isEqualToString:@"*"]){
        result = firstValueDouble * secondValueDouble;
    }else if ([self.operator isEqualToString:@"/"]){
        // Don't allow division by 0
        if (!secondValueDouble == 0){
            result = firstValueDouble / secondValueDouble;
        }
    }
    
    // Reset values for next calculation
    self.previousSecondValue        =   self.secondValue;
    self.previousSecondMultiplier   =   self.secondMultiplier;
    self.previousOperator           =   self.operator;
    self.firstValue                 =   nil;
    self.secondValue                =   nil;
    self.secondMultiplier           =   [NSNumber numberWithInt:1];
    self.firstValueIs0              =   NO;
    self.secondValueIs0             =   NO;
    self.operator                   =   nil;
    
    // Store the result so it can be used as the firstValue if an operation is pressed next
    self.previousResult = [NSNumber numberWithDouble:result];
    
    // return result
    return [NSString stringWithFormat: @"%@", self.previousResult];
}

@end