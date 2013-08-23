//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Casey Frost on 7/22/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

+ (BOOL)isOperatorWith:(NSString *)entry {
    if ([entry isEqualToString:@"+"] || [entry isEqualToString:@"-"] || [entry isEqualToString:@"*"] || [entry isEqualToString:@"/"]){
        return YES;
    }else{
        return NO;
    }
}

// Finds the last result
+ (NSString *)findLastResultWith:(NSArray *)entries {
    NSString *result = @"0";
    
    for (int i=[entries count]-2; i>-1; i--) {
        if ([entries[i] isEqualToString:@"="]){
            result = entries[i+1];
            break;
        }
    }
    
    return result;
}

// Finds the last operator
+ (NSString *)findLastOperatorWith:(NSArray *)entries {
    NSString *result = @"NONE";
    
    for (int i=[entries count]-1; i>-1; i--) {
        if ([CalculatorBrain isOperatorWith:entries[i]]){
            result = entries[i];
            break;
        }
    }
    
    return result;
}

// Finds the last operand. Ignore very last input because it's not the operand we want
+ (NSString *)findLastOperandWith:(NSArray *)entries {
    NSString *result = @"0";
    
    for (int i=[entries count]-2; i>-1; i--) {
        NSLog(@"entries[%d] = %@",i,entries[i]);
        if ([CalculatorBrain isOperatorWith:entries[i]]){
            if (i == [entries count] - 2){
                result = entries[i-1];
            }else{
                result = entries[i+1];
            }
            break;
        }
    }
    
    return result;
}

// Takes universalDisplay and returns universalDisplay with at most 2 ='s
+ (NSString *)limitUniversalDisplayWith:(NSString *)universalDisplay {
    NSLog(@"I worked");
    
    // Separate string by = signs and store the amount of string fragments
    NSArray *separatedString = [universalDisplay componentsSeparatedByString:@"= "];
    NSUInteger splitCount = [separatedString count];
    
    // If there's only 1 fragment left then return it even if it's too wide for the screen
    if (splitCount > 2){
        NSArray *shortenedUniversalDisplay = [separatedString subarrayWithRange:NSMakeRange(splitCount - 2, 2)];
        universalDisplay = [shortenedUniversalDisplay componentsJoinedByString:@"= "];
    }
    
    NSLog(@"Me too with universalDisplay = '%@'",universalDisplay);
    return universalDisplay;
}

+ (NSString *)replaceLastOperandIn:(NSString *)universalDisplay with:(NSString *)digit  {
    return [NSString stringWithFormat:@"%@%@", [universalDisplay substringToIndex:[universalDisplay length]-1], digit];
}

+ (BOOL)isOperandWith:(NSString *)entry {
    BOOL result = NO;
    NSScanner *scanner;
    double doubleValue;
    
    scanner = [NSScanner scannerWithString:entry];
    result = [scanner scanDouble:&doubleValue];
    result = result && scanner.scanLocation == entry.length;
    
    return result;
}

+ (NSArray *)addObjectIn:(NSArray *)array at:(int)index with:(NSString *)newEntry{
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity: [array count] + 1];
    
    for (int i=0; i<[array count]; i++) {
        if (i==index){
            [result addObject:newEntry];
        }
        [result addObject:array[i]];
    }
    
    return result;
}

// Take a completeUniversalDisplay NSString and return a refactored version of it that is readable by our evaluate function
+ (NSString *)refactorDisplayWith:(NSString *)completeUniversalDisplay {
    // Split the completeUniversalDisplay into separate entries
    NSArray *entries = [completeUniversalDisplay componentsSeparatedByString: @" "];
    
    NSLog(@"completeUniversalDisplay sent to refactor is %@",completeUniversalDisplay);
    
    // Loop will make sure universalDisplay follows the pattern "operand operator operand = operand operator operand =..." repeating
    for (int i=0; i<[entries count]; i+=4) {
        // Should start with operand
        if (![self isOperandWith:entries[i]]){
            // If not then I'm lost
            NSLog(@"THIS ERROR BOGGLES MUH MIND and i is %d and the entry at i is %@",i,entries[i]);
        }
        
        // Second one should be an operator but we need to start checking that we're under entries count
        if (i+1 < [entries count]){
            if (![self isOperatorWith:entries[i+1]]){
                // Has to be an = if it gets here
                if ([entries[i+1] isEqualToString:@"="]){
                    // Should add in the last operand or the last operation and operand depending on previous entries
                    if (i == 0){
                        // When the use entered a number(or left the 0) and hit = we should return the same string because our evaluate function will handle that
                        return completeUniversalDisplay;
                    }else{
                        // When user re-runs the last operation
                        // Add operation into NSArray at this index pushing all entries after this up one
                        entries = [self addObjectIn:entries at:i+1 with:[NSString stringWithFormat:@"%@",entries[i-2]]];
                        // Add operand into NSArray at this index pushing all entries after this up one including last operation
                        entries = [self addObjectIn:entries at:i+1 with:[NSString stringWithFormat:@"%@",entries[i-3]]];
                        
                        // Call refactor again and return that
                        return [self refactorDisplayWith:[entries componentsJoinedByString:@" "]];
                    }
                }else{
                    // If not then I'm lost
                    NSLog(@"THIS ERROR BOGGLES MUH MIND 2");
                }
            }
        }else{
            break;
        }
        
        // Third should be another operand
        if (i+2 < [entries count]){
            if (![self isOperandWith:entries[i+2]]){
                // Could be an = or operator if it gets here
                if ([entries[i+2] isEqualToString:@"="] || [self isOperatorWith:entries[i+2]]){
                    NSLog(@"dis happened");
                    // Add last operand into the NSArray at this index
                    entries = [self addObjectIn:entries at:i+2 with:[NSString stringWithFormat:@"%@",entries[i]]];
                    
                    // Call refactor again and return that
                    return [self refactorDisplayWith:[entries componentsJoinedByString:@" "]];
                }else{
                    // If not then I'm lost
                    NSLog(@"THIS ERROR BOGGLES MUH MIND 3");
                }
            }
        }else{
            break;
        }
        
        // Fourth should be an =
        if (i+3 < [entries count]){
            if (![entries[i+3] isEqualToString:@"="]){
                if ([self isOperatorWith:entries[i+3]]){
                    // completeUniversalDisplay includes entries similar to "4 + 3 +" and we need to turn that into "4 + 3 = 7 +"
                    // First store the equation we need to run as an NSString
                    NSString *equation = [NSString stringWithFormat:@"%@ %@ %@ =",entries[i],entries[i+1],entries[i+2]];
                    
                    // Add "=" into NSArray at current index
                    entries = [self addObjectIn:entries at:i+3 with:@"="];
                    
                    // Add the result into the NSArray right after that equals
                    entries = [self addObjectIn:entries at:i+4 with:[NSString stringWithFormat:@"%@",[self evaluateWith:equation]]];
                    
                    // Call refactor again and return that
                    return [self refactorDisplayWith:[entries componentsJoinedByString:@" "]];
                }else{
                    // If not then I'm lost
                    NSLog(@"THIS ERROR BOGGLES MUH MIND 4");
                }
            }
        }else{
            break;
        }
    }
    NSLog(@"Returning: %@ from refactor",[entries componentsJoinedByString:@" "]);
    
    NSString *result = [entries componentsJoinedByString:@" "];
    
    // Only return what may later be used. In this case the last operation before the second to last = could be re-run so save from the 3rd to last = to the end
    [self limitUniversalDisplayWith:result];
    
    return result;
}

+ (NSString *)evaluateWith:(NSString *)equation{
    NSString *result = @"";
    
    NSLog(@"equation display is %@",equation);
    
    // Split the completeUniversalDisplay into operands and operator
    NSArray *entries = [equation componentsSeparatedByString: @" "];
    
    if (([entries count] > 3) && !([[self findLastOperatorWith:entries] isEqualToString:@"NONE"])) {
        // Store operands and operator (add 1 to skip the ending =)
        double operand1 = [entries[[entries count]-4] doubleValue];
        NSString *operator = entries[[entries count]-3];
        double operand2 = [entries[[entries count]-2] doubleValue];
        
        NSLog(@"Got here with operand1 = %f and operand2 = %f and operator %@", operand1, operand2, operator);
        
        // Evaluate based on operation
        if ([operator isEqualToString:@"+"]){
            result = [NSString stringWithFormat:@"%g",(operand1 + operand2)];
        }else if ([operator isEqualToString:@"-"]){
            result = [NSString stringWithFormat:@"%g",(operand1 - operand2)];
        }else if ([operator isEqualToString:@"*"]){
            result = [NSString stringWithFormat:@"%g",(operand1 * operand2)];
        }else if ([operator isEqualToString:@"/"]){
            // Test for division by 0
            if (operand2 == 0){
                result = @"0";
            }else{
                result = [NSString stringWithFormat:@"%g",(operand1 / operand2)];
            }
        }
    }else{
        NSArray *entries = [equation componentsSeparatedByString: @" "];
        
        // If there is never an operator then there can only be 1 operand and an = so the operand will always be returned
        if ([[self findLastOperatorWith:entries] isEqualToString:@"NONE"]){
            result = entries[0];
        }else{
            // If not then I'm lost
            NSLog(@"THIS ERROR BOGGLES MUH MIND 5");
        }
    }
    
    NSLog(@"Returning: %@ from evaluate",result);
    return result;
}

@end