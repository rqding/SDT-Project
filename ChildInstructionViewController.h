//
//  ChildInstructionViewController.h
//  SMaLL
//
//  Created by Richard Ding on 2017-07-12.
//  Copyright © 2017 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildInstructionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *InstructionText;

@property (strong, nonatomic) IBOutlet UILabel *ReadableText;

@property (strong, nonatomic) IBOutlet UILabel *UnreadableText;

@property (strong, nonatomic) IBOutlet UIButton *NextButton;

- (IBAction)NextButton:(id)sender;

- (IBAction)PauseButton:(id)sender;

@end
