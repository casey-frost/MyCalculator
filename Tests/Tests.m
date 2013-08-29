//
//  Tests.m
//  Tests
//
//  Created by Casey Frost on 8/23/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import "Tests.h"
#import "CalculatorBrain.h"


@interface Tests ()

@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
 
    self.brain = [[CalculatorBrain alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBrainDoesSimpleAddition {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"+2 + 4"], @(6), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"6 + -4"], @(2), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 + 0"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 + 1"], @(1), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1 + 0"], @(1), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1020 + 75"], @(1095), @"");
}

- (void)testBrainDoesSimpleSubtraction {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"2 - 4"], @(-2), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"6 - 4"], @(2), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 - 0"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 - 1"], @(-1), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1 - 0"], @(1), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1020 - 75"], @(945), @"");
}

- (void)testBrainDoesSimpleMultiplication {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"2 * 4"], @(8), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"6 * 4"], @(24), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 * 0"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 * 1"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1 * 0"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1020 * 75"], @(76500), @"");
}

- (void)testBrainDoesSimpleDivision {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"120 / 4"], @(30), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"6 / 2"], @(3), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 / 5"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"120 / 1"], @(120), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"76500 / 75"], @(1020), @"");
}

- (void)testBrainDoesDivisionByZero {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"120 / 0"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"6 / 0"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 / 0"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"120 / 0"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"76500 / 0"], @(0), @"");
}

- (void)testBrainDoesDecimalAddition {
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"2.3 + 4.8"] floatValue], (float)7.1, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"1.643 + 4.028"] floatValue], (float)5.671, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0 + 1.983"] floatValue], (float)1.983, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"9009.1 + 0.01"] floatValue], (float)9009.11, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.01 + 0.123"] floatValue], (float)0.133, 0.00001, @"");
}

- (void)testBrainDoesDecimalSubtraction {
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"4.8 - 2.3"] floatValue], (float)2.5, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"4.028 - 1.643"] floatValue], (float)2.385, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"2 - 1.983"] floatValue], (float)0.017, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"9009.1 - 0.01"] floatValue], (float)9009.09, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.123 - .113"] floatValue], (float)0.01, 0.00001, @"");
}

- (void)testBrainDoesDecimalMultiplication {
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"4.8 * 2.3"] floatValue], (float)11.04, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"4.028 * 1.643"] floatValue], (float)6.618004, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"2 * 1.983"] floatValue], (float)3.966, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"9009 * 0.01"] floatValue], (float)90.09, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.123 * .113"] floatValue], (float)0.013899, 0.00001, @"");
}

- (void)testBrainDoesDecimalDivision {
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"12 / .4"] floatValue], (float)30, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@".6 / 2"] floatValue], (float).3, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.55 / 5"] floatValue], (float)0.11, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"1.2 / 10"] floatValue], (float)0.12, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"76.5 / 765"] floatValue], (float)0.1, 0.00001, @"");
}

- (void)testBrainDoesAdditionWithNegatives {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-2 + 4"], @(2), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"6 + -4"], @(2), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 + -1"], @(-1), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-5 + 0"], @(-5), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-1020 + 75"], @(-945), @"");
}

- (void)testBrainDoesSubtractionWithNegatives {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-2 - 4"], @(-6), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"6 - -4"], @(10), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 - -1"], @(1), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-1020 - 75"], @(-1095), @"");
}

- (void)testBrainDoesMultiplicationWithNegatives {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"2 * -4"], @(-8), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-6 * 4"], @(-24), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 * -1"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-1020 * -5"], @(5100), @"");
}

- (void)testBrainDoesDivisionWithNegatives {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"120 / -4"], @(-30), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-6 / -2"], @(3), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"0 / -5"], @(0), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-120 / 1"], @(-120), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"-7500 / 75"], @(-100), @"");
}

- (void)testBrainLeadingZeros {
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0011 + 004"] floatValue], (float)15, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0011 - 004"] floatValue], (float)7, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0011 * 004"] floatValue], (float)44, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0012 / 004"] floatValue], (float)3, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"001.1 + 00.4"] floatValue], (float)1.5, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"001.1 - 00.4"] floatValue], (float)0.7, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"001.1 * 00.04"] floatValue], (float)0.044, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"001.2 / 00.4"] floatValue], (float)3, 0.00001, @"");
}

- (void)testBrainAdditionResultAsOperand {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"11 + 4 + 13"], @(28), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1014 + 92 + 11"], @(1117), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"01014 + 092 + 011"], @(1117), @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"11.5 + 4 + 19.2"] floatValue], (float)34.7, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"13.56 + 4.04 + 19.22"] floatValue], (float)36.82, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"013.56 + 04.04 + 019.22"] floatValue], (float)36.82, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.56 + 0.04 + 0.22"] floatValue], (float)0.82, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"1.560 + 4.040 + 19.220"] floatValue], (float)24.82, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.56 + 0.04 + -0.22"] floatValue], (float)0.38, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"1.560 + -4.040 + 19.220"] floatValue], (float)16.74, 0.00001, @"");
}

- (void)testBrainSubtractionResultAsOperand {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"11 - 4 - 13"], @(-6), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1014 - 92 - 11"], @(911), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"01014 - 092 - 011"], @(911), @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"11.5 - 4 - 19.2"] floatValue], -11.7f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"13.56 - 4.04 - 19.22"] floatValue], -9.7f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"013.56 - 04.04 - 019.22"] floatValue], -9.7f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.56 - 0.04 - 0.22"] floatValue], 0.3f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"1.560 - 4.040 - 19.220"] floatValue], -21.7f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.56 - 0.04 - -0.22"] floatValue], 0.74f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"1.560 - -4.040 - 19.220"] floatValue], -13.62f, 0.00001, @"");
}

- (void)testBrainMultiplicationResultAsOperand {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"11 * 4 * 13"], @(572), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"1014 * 92 * 11"], @(1026168), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"01014 * 092 * 011"], @(1026168), @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"11.5 * 4 * 19.2"] floatValue], 883.2f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"13.56 * 4.04 * 19.22"] floatValue], 1052.917728f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"013.56 * 04.04 * 019.22"] floatValue], 1052.917728f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.56 * 0.04 * 0.22"] floatValue], 0.004928f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"1.560 * 4.040 * 19.220"] floatValue], 121.132128f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.56 * 0.04 * -0.22"] floatValue], -0.004928f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"1.560 * -4.040 * 19.220"] floatValue], -121.132128f, 0.00001, @"");
}

- (void)testBrainDivisionResultAsOperand {
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"12 / 4 / 3"], @(1), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"24 / 4 / 4"], @(1.5), @"");
    STAssertEqualObjects([CalculatorBrain evaluateEquation:@"020 / 2 / 05"], @(2), @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"50 / 5 / 3"] floatValue], 3.333333f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"5.55 / .01 / 111"] floatValue], 5.0f, 0.00001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"05.55 / 00.01 / 0111.00"] floatValue], 5.0f, 0.00001, @"");
}

- (void)testBrainResultWithNoOperators {
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0 ="] floatValue], 0.0f, 0.000001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"3 ="] floatValue], 3.0f, 0.000001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"5.5 ="] floatValue], 5.5f, 0.000001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"0.09 ="] floatValue], 0.09f, 0.000001, @"");
    STAssertEqualsWithAccuracy([[CalculatorBrain evaluateEquation:@"00.0900 ="] floatValue], 0.09f, 0.000001, @"");
}

- (void)testBrainResultWithBadInput {
    STAssertThrows([CalculatorBrain evaluateEquation:@" 3 + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3  + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 +  3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + 3 "], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"+ 3 - 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"- 3 - 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"* 3 - 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"/ 3 - 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"/3 + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"*3 + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 - + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 * + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 / + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 ++ 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 -+ 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 *+ 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 /+ 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + *3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + /3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3+ 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3- 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3* 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3/ 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3+3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3-3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3*3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3/3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 +3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 -3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 *3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 /3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3- +3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"33"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + 3 +"], @"");
}

- (void)testBrainWithCombinedOperandsAndOperators {
    STAssertThrows([CalculatorBrain evaluateEquation:@"3+ + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3- + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3* + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3/ + 3"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + 3+"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + 3-"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + 3*"], @"");
    STAssertThrows([CalculatorBrain evaluateEquation:@"3 + 3/"], @"");
}

- (void)testAddDigitToEquationAddsDigitToEquation {

}

/* Don't do this, shouldn't ever be back to back = without a result between
 - (void) testBrainResultWithBackToBackEquals {
 
 }*/

/*  Don't do this, should just be replaced with new operator
 - (void) testBrainResultWithBackToBackOperator {
 
 }*/

@end
