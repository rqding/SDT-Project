//
//  PracticeInstructionFirstViewController.h
//  SMaLL
//
//  First screen of practice instruction. Including detail instruction of practice round
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeInstructionFirstViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *FirstParagraphText;

@property (strong, nonatomic) IBOutlet UILabel *FirstpointLabel;

@property (strong, nonatomic) IBOutlet UILabel *SecondpointLabel;

@property (strong, nonatomic) IBOutlet UITextView *LastpointText;

@property (strong, nonatomic) IBOutlet UIButton *NextFunctionButton;

- (IBAction)PauseButton:(id)sender;

@end
