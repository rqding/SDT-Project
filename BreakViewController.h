//
//  BreakViewController.h
//  SMaLL
//
//  Created by cj on 2016-11-03.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreakViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *BreakLabel;

@property (strong, nonatomic) IBOutlet UIButton *NextButton;

- (IBAction)PauseButton:(id)sender;

- (IBAction)PressNextButton:(id)sender;

@end
