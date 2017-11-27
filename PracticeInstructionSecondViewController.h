//
//  PracticeInstructionSecondViewController.h
//  SMaLL
//
//  Second screen of practice instruction. Reminding the button function, ready to start the practice round
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeInstructionSecondViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *FirstParagraphText;

@property (strong, nonatomic) IBOutlet UILabel *FirstpointLabel;

@property (strong, nonatomic) IBOutlet UILabel *SecondpointLabel;

@property (strong, nonatomic) IBOutlet UIButton *NextFunctionButton;

@property (strong, nonatomic) IBOutlet UIImageView *GreenButton;

@property (strong, nonatomic) IBOutlet UIImageView *RedButton;

- (IBAction)PauseButton:(id)sender;

@end
