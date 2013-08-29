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
@property (nonatomic, weak) IBOutlet UILabel *display;                  // Displays the last value typed
@property (nonatomic, weak) IBOutlet UILabel *universalDisplay;         // Displays full history. Truncated when too wide for screen. Clear when clear hit or completely new equation started
@property (nonatomic, strong) NSString *completeUniversalDisplay;       // Stores full history so previous results and previous operations can be stored and re-run. Clears with clear button & new equation
@end

BOOL userIsEnteringANumber = NO;                                        // Lets us know when to clear display vs add to it
BOOL clearAfterNewEquation = NO;                                        // Lets us know if user starts a new equation without clearing so we can clear

@implementation CalculatorViewController

/* Not sure if I'm required to use _'s here, wasn't able to get brain or self.brain to do anything
- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}*/

- (void)viewDidLoad {
    self.display.text = @"0";
    self.universalDisplay.text = @"0";
    self.completeUniversalDisplay = @"0";
}

// Clears all variables
- (IBAction)clearPressed:(UIButton *)sender {
    self.display.text               =   @"0";
    self.universalDisplay.text      =   @"0";
    self.completeUniversalDisplay   =   @"0";
    userIsEnteringANumber           =   NO;
    clearAfterNewEquation           =   NO;
}

// Returns the max size universalDisplay text that will fit on the screen
- (NSString *)sizeUniversalDisplayToFit:(NSString *)suggestedUniversalDisplay {
    
    // Separate string by = signs and store the amount of string fragments
    NSArray *separatedString = [suggestedUniversalDisplay componentsSeparatedByString:@"= "];
    NSUInteger splitCount = [separatedString count];
    
    // If there's only 1 fragment left then return it even if it's too wide for the screen
    if (splitCount == 1) {
        return suggestedUniversalDisplay;
    }
    
    // Store width of current font and screen size
    CGSize universalDisplayTextSize = [suggestedUniversalDisplay sizeWithFont:self.universalDisplay.font];
    CGSize availableUniversalDisplaySize = self.universalDisplay.frame.size;
    
    // If new string is still too large for the screen then rerecursively call the same function until it fits
    if (universalDisplayTextSize.width > availableUniversalDisplaySize.width) {
        NSArray *shortenedUniversalDisplay = [separatedString subarrayWithRange:NSMakeRange(1, splitCount - 1)];
        return [self sizeUniversalDisplayToFit:[shortenedUniversalDisplay componentsJoinedByString:@"= "]];
    }
    
    return suggestedUniversalDisplay;
}

- (IBAction)addDigitToEquation:(UIButton *)sender {
    // If user is starting a new equation we need to clear state
    if (clearAfterNewEquation){
        [self clearPressed:sender];
    }
    
    // Store which digit was pressed
    NSString *digit = [sender currentTitle];
    
    // If display text is 0 replace it
    if ([self.display.text isEqualToString: @"0"]){
        self.display.text = @"";
    }
    
    if ([self.universalDisplay.text isEqualToString: @"0"]){
        self.universalDisplay.text = @"";
        self.completeUniversalDisplay = @"";
    }
    
    // Add to the basic display if the user is in the middle of entering a number, otherwise replace it with the new digit
    if (userIsEnteringANumber) {
        // Add digit to display
        self.display.text = [NSString stringWithFormat:@"%@%@", self.display.text, digit];
    }else{
        self.display.text = digit;
    }
    
    // Add a space if user isn't in the middle of entering a number and the universalDisplay isn't blank
    if (!userIsEnteringANumber && ![self.universalDisplay.text isEqualToString:@""]){
        digit = [NSString stringWithFormat:@" %@", digit];
    }
    
    // Make edits to universalDisplays, make sure universalDisplay isn't too wide for screen
    NSString *suggestedUnversalDisplay = [NSString stringWithFormat:@"%@%@", self.universalDisplay.text, digit];
    self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalDisplay];
    
    self.completeUniversalDisplay = [NSString stringWithFormat:@"%@%@", self.completeUniversalDisplay, digit];
    
    // User is always entering a number when a digit is pressed
    userIsEnteringANumber = YES;
}

- (IBAction)addDecimalToEquation:(UIButton *)sender {
    // If user is starting a new equation we need to clear state
    if (clearAfterNewEquation){
        [self clearPressed:sender];
    }
    
    // Add a decimal if no decimal exists, add space if not entering a number currently
    if (userIsEnteringANumber){
        if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
            self.display.text = [NSString stringWithFormat:@"%@.", self.display.text];
            
            NSString *suggestedUnversalDisplay = [NSString stringWithFormat:@"%@.", self.universalDisplay.text];
            self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalDisplay];
            
            self.completeUniversalDisplay = [NSString stringWithFormat:@"%@.", self.completeUniversalDisplay];
        }
    }else{
        self.display.text = @"0.";
        if ([self.universalDisplay.text isEqualToString: @"0"]){
            self.universalDisplay.text = @"0.";
            self.completeUniversalDisplay = @"0.";
        }else{
            self.universalDisplay.text = [NSString stringWithFormat:@"%@ 0.", self.universalDisplay.text];
            self.completeUniversalDisplay = [NSString stringWithFormat:@"%@ 0.", self.completeUniversalDisplay];
        }
        
        // User is always entering a number after decimal is pressed
        userIsEnteringANumber = YES;
    }
}

- (IBAction)addOperationToEquation:(UIButton *)sender {
    // Store last char
    NSString *lastChar = [self.universalDisplay.text substringFromIndex:[self.universalDisplay.text length] - 1];
    
    // If last thing entered was an operation, delete it in both universalDisplay and completeUniversalDisplay, add the new operator and exit the function
    if ([CalculatorBrain isOperatorWith:lastChar]){
        self.universalDisplay.text = [NSString stringWithFormat:@"%@%@", [self.universalDisplay.text substringToIndex:[self.universalDisplay.text length]-1], [sender currentTitle]];
        self.completeUniversalDisplay = [NSString stringWithFormat:@"%@%@", [self.completeUniversalDisplay substringToIndex:[self.completeUniversalDisplay length]-1], [sender currentTitle]];
        
        return;
    }
    
    // Only call equalsPressed if something needs to be calculated
    NSArray *entries = [self.completeUniversalDisplay componentsSeparatedByString: @" "];
    if ([entries count] > 2){
        // Store last 3 entries
        NSString *lastEntry = entries[[entries count] -1];
        NSString *secondLastEntry = entries[[entries count] -2];
        NSString *thirdLastEntry = entries[[entries count] -3];
        
        // Test if 1st and 3rd are numbers and 2nd is an operator
        if (![CalculatorBrain isOperatorWith:lastEntry] && ![lastEntry isEqualToString:@"="] && [CalculatorBrain isOperatorWith:secondLastEntry] && ![CalculatorBrain isOperatorWith:thirdLastEntry] && ![thirdLastEntry isEqualToString:@"="]){
            // Run equals pressed if an equation needs to be evaluated
            [self equalsPressed:sender];
            return;
        }
    }
    
    // Add operation to the displays
    NSString *suggestedUnversalDisplay = [NSString stringWithFormat:@"%@ %@", self.universalDisplay.text, [sender currentTitle]];
    self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalDisplay];
    
    self.completeUniversalDisplay = [NSString stringWithFormat:@"%@ %@", self.completeUniversalDisplay, [sender currentTitle]];
    
    // Anytime an operation is pressed the user is no longer entering a number
    userIsEnteringANumber = NO;
    
    // Reset clearAfterNewEquation because they are extending the previous equation
    clearAfterNewEquation = NO;
}

- (IBAction)changeOperandSignInEquation:(id)sender {
    // User must be entering a number to perform this operation
    if (userIsEnteringANumber || clearAfterNewEquation) {
        if ([self.universalDisplay.text rangeOfString:@" " options:NSBackwardsSearch].location == NSNotFound) {
            // If something has been entered it is the only operand. Switch the sign and return
            if (![self.universalDisplay.text doubleValue] == 0) {
                NSString *newDisplay = [NSString stringWithFormat:@"%g",[self.universalDisplay.text doubleValue] * -1];
                self.display.text = newDisplay;
                self.universalDisplay.text = newDisplay;
                self.completeUniversalDisplay = newDisplay;
            }
            
            return;
        }
        
        // Store the location of the last space so we know where to add in the new value and remove the old
        int location = [self.universalDisplay.text rangeOfString:@" " options:NSBackwardsSearch].location;
        
        // The number in the display should always be the number we're working with so multiply by -1 to change sign and store it
        NSString *newNumber = [NSString stringWithFormat:@"%g",[self.display.text doubleValue] * -1];
        
        // Add it to the displays removing old values where necessary
        self.display.text = newNumber;
        self.universalDisplay.text = [NSString stringWithFormat:@"%@ %@",[self.universalDisplay.text substringToIndex:location],newNumber];
        self.completeUniversalDisplay = [NSString stringWithFormat:@"%@ %@",[self.completeUniversalDisplay substringToIndex:[self.completeUniversalDisplay rangeOfString:@" " options:NSBackwardsSearch].location],newNumber];
    }
}

- (IBAction)removeLastEntryInEquation:(id)sender {
    // Store length of completeUniversalDisplay
    int len = [self.completeUniversalDisplay length];
    
    if (len==1) {
        [self clearPressed:sender];
        return;
    }
    
    if (len > 1) {
        // If the new string ends in a whitespace remove it along with the last character
        if ([[self.completeUniversalDisplay substringWithRange:NSMakeRange(len - 2, 1)] isEqualToString:@" "]) {
            self.completeUniversalDisplay = [self.completeUniversalDisplay substringToIndex:len - 2];
            self.universalDisplay.text = [self.universalDisplay.text substringToIndex:len - 2];
            
            // If the new last character is a number then userIsEnteringANumber and !clearAfterNewEquation otherwise !userIsEnteringANumber
            len = [self.completeUniversalDisplay length];
            if ([CalculatorBrain isOperatorWith:[self.completeUniversalDisplay substringFromIndex:len - 1]]) {
                userIsEnteringANumber = NO;
            }else{
                userIsEnteringANumber = YES;
                clearAfterNewEquation = NO;
            }
        }else{
            self.completeUniversalDisplay = [self.completeUniversalDisplay substringToIndex:len - 1];
            self.universalDisplay.text = [self.universalDisplay.text substringToIndex:len - 1];
        }
        
        if ([self.display.text length] > 0) {
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        }
    }
}

- (IBAction)calculateEquationResult:(id)sender {
    // Store sender currentTitle so we know if we need to add an operator or an = to the string
    NSString *newChar = [sender currentTitle];
    
    // Get result of the equation
    NSNumber *newResult = [CalculatorBrain evaluateEquation:[NSString stringWithFormat:@"%@ %@",self.completeUniversalDisplay, newChar]];
    
    
    // Add result to displays but only if an empty string wasn't returned
    if (![newResult isEqualToString:@""]){
        self.display.text = newResult;
    }
    
    NSString *suggestedUnversalDisplay = cleanEquation;
    
    // Only add a space if newResult isn't blank
    if (![newResult isEqualToString:@""]) {
        suggestedUnversalDisplay = [NSString stringWithFormat:@"%@ %@",suggestedUnversalDisplay,newResult];
        self.completeUniversalDisplay = [NSString stringWithFormat:@"%@",suggestedUnversalDisplay];
    }
    
    self.universalDisplay.text = [self sizeUniversalDisplayToFit:suggestedUnversalDisplay];
    self.completeUniversalDisplay = [self sizeUniversalDisplayToFit:suggestedUnversalDisplay];
    
    // If the last entry is an = we need to remove it and run equalsPressed again
    // This can only have if an = is entered right after an operator
    NSArray *newEntries = [newResult componentsSeparatedByString: @" "];
    if ([newEntries[[newEntries count]-1] isEqualToString:@"="]){
        self.completeUniversalDisplay = [self.completeUniversalDisplay substringToIndex:[self.completeUniversalDisplay length]-2];
        [self calculateEquationResult:sender];
    }
    
    // When = is pressed the user is no longer entering a number
    userIsEnteringANumber = NO;
    
    // Any time equals is pressed we set clearAfterNewEquation to YES. Then if a new, unrelated equation is started next we clear the old equation
    if ([[sender currentTitle] isEqualToString:@"="]) {
        clearAfterNewEquation = YES;
    }
}

@end





















