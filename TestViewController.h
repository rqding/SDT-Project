//
//  TestViewController.h
//  SMaLL
//
//  Test view present looping test trial picture of math symbols.
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@class TrialObject;

@interface TestViewController : UIViewController
{
    TrialObject *trialobject;
}

@property (nonatomic, retain)TrialObject *trialobject;

@property (strong, nonatomic)NSString *databasePath;

@property (nonatomic) sqlite3 *SMALLDB;

@property (strong, nonatomic) IBOutlet UIImageView *TrialImage;

@property (strong, nonatomic) IBOutlet UILabel *FixpointLabel;

@property (strong, nonatomic) IBOutlet UIButton *YesButton;

@property (strong, nonatomic) IBOutlet UIButton *NoButton;

@property (strong, nonatomic) IBOutlet UIButton *FinishButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *PauseButton;

@property (strong, nonatomic) IBOutlet UIButton *ExitButton;

- (IBAction)PressYesButton:(id)sender;

- (IBAction)PressNoButton:(id)sender;

- (IBAction)PauseButton:(id)sender;

- (IBAction)PressFinishButton:(id)sender;

- (IBAction)PressExitButton:(id)sender;

@end
