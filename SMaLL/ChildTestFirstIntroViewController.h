//
//  ChildTestFirstIntroViewController.h
//  SMaLL
//
//  Created by cj on 2017-07-13.
//  Copyright © 2017 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildTestFirstIntroViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *InstructionText;

@property (strong, nonatomic) IBOutlet UILabel *ReadableText;

@property (strong, nonatomic) IBOutlet UILabel *UnreadableText;

@property (strong, nonatomic) IBOutlet UIButton *NextButton;

- (IBAction)PauseButton:(id)sender;

@end
