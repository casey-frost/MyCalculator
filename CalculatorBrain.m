//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Casey Frost on 7/22/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

+ (NSString *)replaceLastOperandIn:(NSString *)universalDisplay with:(NSString *)digit  {
    return [NSString stringWithFormat:@"%@%@", [universalDisplay substringToIndex:[universalDisplay length]-1], digit];
}

+ (NSArray *)removeFirstThreeArrayObjects:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity: [array count] - 3];

    for (int i=3; i<[array count]; i++) {
        [result addObject:array[i]];
    }

    return result;
}

+ (BOOL)isValidOperand:(NSString *)string {
    BOOL result = YES;

    for (int i = 0; i < [string length]; i++) {
        NSString *character = [string substringWithRange:NSMakeRange(i,1)];

        if ([character isEqualToString:@"+"] || [character isEqualToString:@"-"] || [character isEqualToString:@"*"] || [character isEqualToString:@"/"]){
            if (i != 0){
                return NO;
            }else{
                if ([character isEqualToString:@"*"] || [character isEqualToString:@"/"]){
                    return NO;
                }
            }
        }
    }
    return result;
}

+ (NSNumber *)evaluateEquation:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@" "];

    NSNumber *result = nil;
    
    if ([components count] > 2) {
        if (![self isValidOperand:[components objectAtIndex:0]] || ![self isValidOperand:[components objectAtIndex:2]]) {
            [NSException raise:@"CalculatorBrainException" format:@"Not a valid operand %@", string];
        }

        NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:[components objectAtIndex:0]];
        NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:[components objectAtIndex:2]];

        if ([[components objectAtIndex:1] isEqual:@"+"]) {
            result = [number1 decimalNumberByAdding:number2];
        } else if ([[components objectAtIndex:1] isEqual:@"-"]) {
            result = [number1 decimalNumberBySubtracting:number2];
        } else if ([[components objectAtIndex:1] isEqual:@"*"]) {
            result = [number1 decimalNumberByMultiplyingBy:number2];
        } else if ([[components objectAtIndex:1] isEqual:@"/"]) {
            @try {
                result = [number1 decimalNumberByDividingBy:number2];
            }
            @catch(NSException *e) {
                result = [NSNumber numberWithInt:0];
            }
        }
    }else if ([[components objectAtIndex:1] isEqual:@"="]) {
        result = [NSDecimalNumber decimalNumberWithString:[components objectAtIndex:0]];
    }

    if (result) {
        if ([components count] > 3){
            components = [self removeFirstThreeArrayObjects:components];
            return [self evaluateEquation:[NSString stringWithFormat:@"%@ %@",result,[components componentsJoinedByString:@" "]]];
        }else {
            return result;
        }
    }

    [NSException raise:@"CalculatorBrainException" format:@"Cannot evaluate %@", string];
    return nil;
}

@end