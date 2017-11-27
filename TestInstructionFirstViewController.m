//
//  TestInstructionFirstViewController.m
//  SMaLL
//
//  First screen of test instruction. Including detail instruction of test round
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import "TestInstructionFirstViewController.h"

@interface TestInstructionFirstViewController ()

@end

@implementation TestInstructionFirstViewController
{
    NSString *PID;
    NSString *groupID;
    NSString *testmode;
    NSString *firsttesttype;
    NSString *secondtesttype;
    NSString *testtype;
    int testround;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _NextFunctionButton.hidden = YES;
    
    NSString *subtitle = _SubtitleLabel.text;
    
    // Get the dirctory
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPath[0];
    
    //setup path for property file
    NSString *propertypath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"configure.plist"]];
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    
    testround = [[configDict objectForKey:@"current_round"] intValue];
    
    //get paticipant info from paticipant table
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"small.db"]];
    
    sqlite3_stmt *statment;
    const char *dbpath = [_databasePath UTF8String];
    
    //read from paticipant database
    if(sqlite3_open(dbpath, &_SMALLDB)==SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM paticipantdata WHERE ID = (SELECT MAX(ID) FROM paticipantdata)"];
        
        const char *sql_statment =[querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_SMALLDB, sql_statment, -1, &statment, NULL) == SQLITE_OK){
            while(sqlite3_step(statment) == SQLITE_ROW){
                
                PID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 1)];
                testmode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 2)];
                firsttesttype = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 3)];
                secondtesttype = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 4)];
                
            }// end of while
            sqlite3_finalize(statment);
            sqlite3_close(_SMALLDB);
            
        }  else{
            
            [self showUIAlerWithMessage:@"Fail to get data from paticipant table" andTitle:@"Error"];
        }
    } //end of if
    
    //base on test round to setup intro label
    if (testround == 1) {
        testtype = firsttesttype;

    } else if (testround == 2) {
        testtype = secondtesttype;
    }
    
    NSString *testIntro = nil;
    if ([testtype isEqual: @"S"])
    {
        testIntro = @"math_test_intro";
    } else if ([testtype isEqual: @"P"]) {
        testIntro = @"punctuation_test_intro";
        subtitle = [subtitle stringByReplacingOccurrencesOfString:@"math" withString:@"punctuation"];
    } else {
        // Test intro for children math information. TO DO: UPDATE INTRO!!
        testIntro = @"math_test_intro";
        subtitle = [subtitle stringByReplacingOccurrencesOfString:@"math" withString:@"child math"];
    }
    
    _SubtitleLabel.text = subtitle;
    
    //update font color for first paragraph
    NSString *introtext = [configDict objectForKey:testIntro];
    NSMutableAttributedString *introstring = [self addColorAttributeToString:introtext size:22.0f];
    [_FirstParagraphText setAttributedText:introstring];
    
    //Update font color for first point label
    NSString *firstpointtext = _FirstpointLabel.text;
    NSMutableAttributedString *firstpointstring = [self addColorAttributeToString:firstpointtext size:18.0f];
    [_FirstpointLabel setAttributedText:firstpointstring];
    
    //Update font color for second point label
    NSString *secondpointtext = _SecondpointLabel.text;
    NSMutableAttributedString *secondpointstring = [self addColorAttributeToString:secondpointtext size:18.0f];
    [_SecondpointLabel setAttributedText:secondpointstring];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(showNextButton) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showUIAlerWithMessage:(NSString*)message andTitle:(NSString*)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showNextButton {
    _NextFunctionButton.hidden = NO;
}

-(NSMutableAttributedString *)addColorAttributeToString: (NSString *)inputtext size:(double)size {
    //set font attribute
    UIFont *textFont = [UIFont systemFontOfSize:size];
    NSDictionary * fontAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:textFont, NSFontAttributeName, nil];
    
    //seperate intro text into words
    NSArray *words=[inputtext componentsSeparatedByString:@" "];
    
    //Add color attribute to intro text
    NSMutableAttributedString *stringtext = [[NSMutableAttributedString alloc]initWithString:inputtext attributes:fontAttributes];
    for (NSString *word in words) {
        if ([word hasPrefix:@"unreadable"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        }
        if ([word hasPrefix:@"readable"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
        }
        if ([word hasPrefix:@"RED"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        }
        if ([word hasPrefix:@"GREEN"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
        }
        if ([word hasPrefix:@"LEFT"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        }
        if ([word hasPrefix:@"RIGHT"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
        }
        
    }
    return stringtext;
}

- (IBAction)PauseButton:(id)sender {
    //press top bar pause button show quit app alert view
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to quit now ?"
                                                    message:@"Press YES to quit. Press cancel back to test."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"YES", nil];
    alert.tag = 100;
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //press yes to quit app
    if (alertView.tag ==100) {
        if (buttonIndex ==1)
            exit(0);
    }
}


@end
