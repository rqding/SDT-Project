//
//  TestInstructionFirstViewController.h
//  SMaLL
//
//  First screen of test instruction. Including detail instruction of test round
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface TestInstructionFirstViewController : UIViewController

@property (strong, nonatomic)NSString *databasePath;

@property (nonatomic) sqlite3 *SMALLDB;

@property (strong, nonatomic) IBOutlet UITextView *FirstParagraphText;

@property (strong, nonatomic) IBOutlet UILabel *SubtitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *FirstpointLabel;

@property (strong, nonatomic) IBOutlet UILabel *SecondpointLabel;

@property (strong, nonatomic) IBOutlet UIButton *NextFunctionButton;

- (IBAction)PauseButton:(id)sender;


@end
