//
//  ChildPracticeInstructionViewController.h
//  SMaLL
//
//  Created by Richard Ding on 2017-07-12.
//  Copyright © 2017 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildPracticeInstructionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *InstructionText;

@property (strong, nonatomic) IBOutlet UILabel *ReadableText;

@property (strong, nonatomic) IBOutlet UILabel *UnreadableText;

@property (strong, nonatomic) IBOutlet UILabel *RightFingerText;

@property (strong, nonatomic) IBOutlet UILabel *LeftFingerText;

@property (strong, nonatomic) IBOutlet UIImageView *GoImage;

@property (strong, nonatomic) IBOutlet UIButton *StartPracticeButton;

- (IBAction)PauseButton:(id)sender;

@end
