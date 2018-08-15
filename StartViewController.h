//
//  StartViewController.h
//  SMaLL
//
//  Start view is for experimenter input object id and group id.
//  Experimenter also could enter configuration screen from top right bar button.
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface StartViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic)NSString *databasePath;

@property (nonatomic) sqlite3 *SMALLDB;

@property (strong, nonatomic) IBOutlet UITextField *subjectIDTextField;

@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSegment;

@property (strong, nonatomic) IBOutlet UIButton *resetButton;

@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)PressResetButton:(id)sender;

- (IBAction)PressStartButton:(id)sender;

- (IBAction)PressSaveButton:(id)sender;

- (IBAction)SelectTypeSegment:(id)sender;

- (IBAction)PressExitButton:(id)sender;

@end
