//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Casey Frost on 7/19/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic,strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

// Not sure if I'm required to use _'s here, wasn't able to get brain or self.brain to do anything
- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

// Clears the displays and re-initializes the brain so all variables are sback to their default values
- (IBAction)clearPressed:(id)sender {
    self.display.text           =   @"0";
    self.universalDisplay.text  =   @"0";
    self.brain                  =   [[CalculatorBrain alloc] init];
}

// Takes a value, multiplier and new digit and makes the new number. This is only necessary because I wanted to work with NSNumbers instead of string representations of number
- (NSNumber*)calculateValueWith:(NSNumber *)Value And:(NSNumber *)Multiplier And:(NSNumber *)digit
{
    // Convert the NSNumbers to C primitives
    double valueDouble = [Value doubleValue];
    int multiplierInt = [Multiplier intValue];
    
    // If there is a decimal
    if ([Multiplier intValue] > 1){
        // Convert the number to a whole number, add the new digit then convert back to a double
        valueDouble = (valueDouble*multiplierInt+[digit intValue]) / multiplierInt;
    }else{
        // If there's no decimal then multiply by 10 and add the new digit
        valueDouble = valueDouble*10+[digit intValue];
    }
    
    return [NSNumber numberWithDouble:valueDouble];
}

// Returns the max size universalDisplay text that will fit on the screen
- (NSString *)sizeUniversalDisplayToFit:(NSString *)suggestedUniversalDisplay {
    
    // Separate string by = signs and store the amount of string fragments
    NSArray *separatedString = [suggestedUniversalDisplay componentsSeparatedByString:@"="];
    NSUInteger splitCount = [separatedString count];
    
    // If there's only 1 fragment left then return it even if it's too wide for the screen
    if( splitCount == 1){
        return suggestedUniversalDisplay;
    }
    
    // Store width of current font and screen size
    CGSize universalDisplayTextSize = [suggestedUniversalDisplay sizeWithFont:self.universalDisplay.font];
    CGSize availableUniversalDisplaySize = self.universalDisplay.frame.size;
    
    // If new string is still too large for the screen then rerecursively call the same function until it fits
    if (universalDisplayTextSize.width > availableUniversalDisplaySize.width) {
        NSArray *shortenedUniversalDisplay = [separatedString subarrayWithRange:NSMakeRange(1, splitCount - 1)];
        return [self sizeUniversalDisplayToFit:[shortenedUniversalDisplay componentsJoinedByString:@"="]];
    }
    
    return suggestedUniversalDisplay;
}

// Sets variables for special operations like an operand running an operation on itself or re-running the operation on the result
- (void)equals
{
    if (self.brain.firstValue || self.brain.firstValueIs0){
		if (self.brain.operator){
			if (!self.brain.secondValue && !self.brain.secondValueIs0){
                // Mac calculators run the operation on itself if there's no secondValue
                self.brain.secondValue = self.brain.firstValue;
            }
            
            // Solve the equation and display the result
            self.display.text = [NSString stringWithFormat: @"%@", [self.brain getSolution]];
            
            // Confirm the string will fit in universalDisplay then update universalDisplay
            NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@ = %@", self.universalDisplay.text, self.display.text];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
        }
    }else{
        // Run the same operation on the previousResult if the user hit ='s again
        if (self.brain.previousOperator){
            // retrieve old values and run operation again
            self.brain.firstValue = self.brain.previousResult;
            self.brain.secondValue = self.brain.previousSecondValue;
            self.brain.secondMultiplier = self.brain.previousSecondMultiplier;
            self.brain.operator = self.brain.previousOperator;
            
            // Call same function now that values are set again
            [self equals];
        }
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    // Clear the universalDisplay. This happens when the user hits the = button then starts a new number.
    if (self.brain.clearUniversalDisplayFlag){
        self.universalDisplay.text = @"";
        self.brain.clearUniversalDisplayFlag = NO;
    }
    
    // Store the new digit as an NSNumber
    NSNumber *digit = [NSNumber numberWithDouble:[[sender currentTitle] doubleValue]];
    
    // If there is no firstValue then set it
    if (!self.brain.firstValue && !self.brain.firstValueIs0){
        self.brain.firstValue = digit;
        self.display.text = [sender currentTitle];
        
        // If the first digit of the number is 0 we must store that in another variable because only testing for if(firstValue) breaks when it's 0
		if (!digit){
			self.brain.firstValueIs0 = YES;
        }
        
        // Remove the placeholder 0 if that's all that's in the universalDisplay, otherwise add the new digit to the universal display
        if ([self.universalDisplay.text isEqualToString: @"0"]){
            self.universalDisplay.text = [NSString stringWithFormat: @"%@", digit];
        }else{
            self.universalDisplay.text = [NSString stringWithFormat: @"%@ %@", self.universalDisplay.text, digit];
        }
    }
    // If the operator isn't set and firstValue has a value then we are adding a new digit to the end of firstValue
    else if (!self.brain.operator){
        self.brain.firstValue = [self calculateValueWith:self.brain.firstValue And:self.brain.firstMultiplier And:digit];
        if ([self.brain.firstMultiplier intValue] > 1){
            self.brain.firstMultiplier = [NSNumber numberWithInt:([self.brain.firstMultiplier intValue]*10)];
        }
        
        if (self.brain.firstValueIs0 && [digit intValue] != 0){
            self.brain.firstValueIs0 = NO;
        }
        
        self.display.text = [NSString stringWithFormat: @"%g", [self.brain.firstValue doubleValue]];
        
        NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@%@", self.universalDisplay.text, digit];
        self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
    }
    // There is a firstValue and an operator, use new digit for secondValue
    else{
        if (!self.brain.secondValue && !self.brain.secondValueIs0){
            if ([digit intValue] == 0){
                self.brain.secondValueIs0 = YES;
            }else{
                self.brain.secondValueIs0 = NO;
            }
            
            if ([self.brain.secondMultiplier intValue] > 1){
                self.brain.secondValue = [self calculateValueWith:self.brain.secondValue And:self.brain.secondMultiplier And:digit];
                self.brain.secondMultiplier = [NSNumber numberWithDouble:[self.brain.secondMultiplier intValue] * 10];
            }else{
                self.brain.secondValue = digit;
            }
            
            NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@ %@", self.universalDisplay.text, digit];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
        }else{
            self.brain.secondValue = [self calculateValueWith:self.brain.secondValue And:self.brain.secondMultiplier And:digit];
            
            if ([self.brain.secondMultiplier intValue] > 1){
                self.brain.secondMultiplier = [NSNumber numberWithInt:[self.brain.secondMultiplier intValue] * 10];
            }
            
            NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@%@", self.universalDisplay.text, digit];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
        }
        self.display.text = [NSString stringWithFormat: @"%g", [self.brain.secondValue doubleValue]];
    }
}

- (IBAction)decimalPressed:(UIButton*)sender
{
    // Starting a value with a decimal should clear the universalDisplay if ='s was the last thing pressed
    if (self.brain.clearUniversalDisplayFlag){
        self.universalDisplay.text = @"";
        self.brain.clearUniversalDisplayFlag = NO;
    }
    
    // If there's no firstValue then firstValue becomes 0 and firstMultiplier changes to account for the decimal place
    if (!self.brain.firstValue && !self.brain.firstValueIs0){
		self.brain.firstMultiplier = [NSNumber numberWithInt:10];
        self.brain.firstValueIs0 = YES;
        self.display.text = @"0.";
        
        if ([self.universalDisplay.text isEqualToString: @"0"]){
            self.universalDisplay.text = @"0.";
        }else{
            // Might be some unecessary code because i think it could only reach here if universalDisplay was already cleared
            NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@%@", self.universalDisplay.text, @"0."];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
        }
    }
    // If there's no operator the decimal is in the middle of the firstValue
    else if (!self.brain.operator){
        if ([self.brain.firstMultiplier intValue] < 10){
            self.brain.firstMultiplier = [NSNumber numberWithInt:10];
            self.display.text = [NSString stringWithFormat: @"%@%@", self.display.text, @"."];
            
            NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@%@", self.universalDisplay.text, @"."];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
        }// Do nothing if > 1 because there already is a decimal
    }
    // Otherwise decimal goes in secondValue
    else{
        if (!self.brain.secondValue && !self.brain.secondValueIs0){
            self.brain.secondMultiplier = [NSNumber numberWithInt:10];
            self.brain.secondValueIs0 = YES;
            self.display.text = @"0." ;
            
            NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@ %@", self.universalDisplay.text, @"0."];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
        }else{
            if ([self.brain.secondMultiplier intValue] < 10){
                self.brain.secondMultiplier = [NSNumber numberWithInt:10];
                self.display.text = [NSString stringWithFormat: @"%@%@", self.display.text, @"."];
                
                NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@%@", self.universalDisplay.text, @"."];
                self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
            }
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    // If there's an operator and secondValue then we can get a solution
    if (self.brain.operator){
		if (self.brain.secondValue || self.brain.secondValueIs0){
            // set the displays to show new value
            self.display.text = [NSString stringWithFormat: @"%@", [self.brain getSolution]];
            
            NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@ = %@", self.universalDisplay.text, self.display.text];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
            
			self.brain.firstValue = self.brain.previousResult;
            
            [self equals];
            
			self.brain.previousResult = nil;
        }else{
            // Already has an operator but no second value, need to remove old operator(and a space) from universalDisplay and replace it
            NSString *suggestedUnversalHistory = [self.universalDisplay.text substringToIndex:[self.universalDisplay.text length]-2];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
        }
    }
    // If there is no firstValue either previousResult or 0 will be our new firstValue depending on if there is a previousValue
    if (!self.brain.firstValue){
        if (self.brain.previousResult){
            self.brain.firstValue = self.brain.previousResult;
        }else{
            self.brain.firstValue = [NSNumber numberWithInt:0];
            self.brain.firstValueIs0 = YES;
        }
    }
    
    // Set the operator, an operator can be entered at any step of the process
    self.brain.operator = [sender currentTitle];
    
    // Clear display when operator pressed
    self.display.text = @"";
    
    NSString *suggestedUnversalHistory = [NSString stringWithFormat: @"%@ %@",self.universalDisplay.text,[sender currentTitle]];
    self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalHistory];
    
    // When operation was pressed you no longer should clear the universalDisplay text
    self.brain.clearUniversalDisplayFlag = NO;
}

- (IBAction)equalsPressed
{
    [self equals];
    
    // When = is pressed by the user this flag goes up
    self.brain.clearUniversalDisplayFlag = YES;
}

@end
