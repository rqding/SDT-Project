//
//  FirstInstructionViewController.h
//  SMaLL
//
//  First screen for present instruction. Including main instruction, and two practice instruction.
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstInstructionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *FirstParagraphTextView;

@property (strong, nonatomic) IBOutlet UILabel *FirstPointLabel;

@property (strong, nonatomic) IBOutlet UILabel *SecondPointLabel;

@property (strong, nonatomic) IBOutlet UIButton *NextFunctionButton;

- (IBAction)PauseButton:(id)sender;

@end
