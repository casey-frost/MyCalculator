//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Casey Frost on 7/19/13.
//  Copyright (c) 2013 Casey Frost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel *display;
@property (nonatomic, weak) IBOutlet UILabel *universalDisplay;

//- (NSNumber *)calculateValueWith:(NSNumber *)Value And:(NSNumber *)Multiplier And:(NSNumber *)digit;

@end
