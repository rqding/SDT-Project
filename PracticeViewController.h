//
//  PracticeViewController.h
//  SMaLL
//
//  Practice view present looping practice trials for english word. 
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrialObject;

@interface PracticeViewController : UIViewController
{
    TrialObject *trialobject;
}

@property (nonatomic, retain)TrialObject *trialobject;

@property (strong, nonatomic) IBOutlet UILabel *TrialLabel;

@property (strong, nonatomic) IBOutlet UIButton *NoButton;

@property (strong, nonatomic) IBOutlet UIButton *YesButton;

@property (strong, nonatomic) IBOutlet UILabel *FixpointLabel;

@property (strong, nonatomic) IBOutlet UILabel *CorrectLabel;

@property (strong, nonatomic) IBOutlet UILabel *WrongLabel;

@property (strong, nonatomic) IBOutlet UIButton *NextButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *PauseButton;

@property (strong, nonatomic) IBOutlet UIImageView *CorrectImage;

@property (strong, nonatomic) IBOutlet UIImageView *WrongImage;

@property (strong, nonatomic) IBOutlet UILabel *ResponseLabel;

- (IBAction)PressNoButton:(id)sender;

- (IBAction)PressYesButton:(id)sender;

- (IBAction)PauseButton:(id)sender;

- (IBAction)StartTestRoundButton:(id)sender;


@end
