//
//  StartViewController.m
//  SMaLL
//
//  Start view is for experimenter input object id and group id.
//  Experimenter also could enter configuration screen from top right bar button.
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController
{
    NSString *docsDir;
    NSArray *dirPath;
    NSString *modeselected;
    NSString *propertypath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set default button display
    _saveButton.hidden = NO;
    _resetButton.hidden = NO;
    _startButton.hidden = YES;
    
    //set default type
    //read configure file path and update total test round
    NSArray *configurepaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [configurepaths objectAtIndex:0];
    propertypath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"configure.plist"]];
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    //set default testing parameter as default adult mode
    [configDict setObject:@"60" forKey:@"num_of_test"];
    [configDict setObject:@"1" forKey:@"mode_selected"]; //testing mode 1:adult(math symbol), testing mode 2: Child mode, default mode is adult mode
    [configDict setObject:@"plain gene skit robe bin plin gean skti vobe bni" forKey:@"practice_list"];
    [configDict writeToFile:propertypath atomically:YES];
    
    // Get the dirctory
    dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPath[0];
    
    //setup path for config file
    propertypath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"configure.plist"]];
    //Check file exist
    NSFileManager *configfilemgr = [NSFileManager defaultManager];
    // if not configure file not create
    if([configfilemgr fileExistsAtPath:propertypath]==NO){
        NSMutableDictionary *configDict = [[NSMutableDictionary alloc] init];
        [configDict setObject:@"2" forKey:@"time_limit"];
        [configDict setObject:@"1.5" forKey:@"feedback_time"];
        [configDict setObject:@"0.5" forKey:@"fixpoint_time"];
        [configDict setObject:@"60" forKey:@"num_of_test"];
        [configDict setObject:@"1" forKey:@"mode_selected"];
        [configDict setObject:@"plain gene skit robe bin plin gean skti vobe bni" forKey:@"practice_list"];
        [configDict setObject:@"In this task, you job is to decide if each set of symbols you see are arranged in a readable or unreadable way. Your goal is to be accurate, but make your choice as quickly as possible before the text disappears. " forKey:@"main_intro"];
        
        [configDict setObject:@"To get used to the task, you will start with a practice round in English. The symbols will be letters of the alphabet. You will decide if the letters are arranged in a way that is readable or unreadable." forKey:@"first_practice_intro"];
        
        [configDict setObject:@"In this TEST round, you will see symbols from the language of mathematics. Remember, your job is to decide if each set of symbols you see are arranged in a way that is readable or unreadable. " forKey:@"adult_test_intro"];
        
        [configDict writeToFile:propertypath atomically:YES];
    }
    
    /* Create two database.
     1. participant table for store participant info including test-id, gender, and age.
     2. experiment result table to store the trial data, participant data, and other result data.
     3. trial list table to store the trial list.
     */
    
    //Build the path for keep database
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"small.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //Check file exist
    if([filemgr fileExistsAtPath:_databasePath]==NO){
        const char *dbpath= [_databasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_SMALLDB) == SQLITE_OK){
            char * errorMessage;
            // creaet paticipant info table
            const char *sql_statement1= "CREATE TABLE IF NOT EXISTS paticipantdata (ID INTEGER PRIMARY KEY AUTOINCREMENT, PID TEXT, TESTMODE TEXT);";
            if(sqlite3_exec(_SMALLDB, sql_statement1, NULL, NULL, &errorMessage)!=SQLITE_OK){
                [self showUIAlerWithMessage:@"Failed to create the table for paticipant" andTitle:@"Error"];
            }
            //create trial data table
            const char *sql_statement2= "CREATE TABLE IF NOT EXISTS resultdata (ID INTEGER PRIMARY KEY AUTOINCREMENT,trialcount INTEGER, date TEXT, pid TEXT,testmode TEXT, trialnumber INTEGER, trialcode INTEGER, pictureid TEXT, response INTEGER, correct INTEGER, reactiontime TEXT);";
            
            if(sqlite3_exec(_SMALLDB, sql_statement2, NULL, NULL, &errorMessage)!=SQLITE_OK){
                [self showUIAlerWithMessage:@"Failed to create the table for result data" andTitle:@"Error"];
            }
            
            //close database
            sqlite3_close(_SMALLDB);
        } else {
            [self showUIAlerWithMessage:@"Failed to open/create the table" andTitle:@"Error"];
        }
        
    }// end of create database
    
    
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)PressResetButton:(id)sender {
    //clear text fields and reset segment
    _subjectIDTextField.text = @"";
    _typeSegment.selectedSegmentIndex = 0;
}

- (IBAction)PressStartButton:(id)sender {
    // start introduction view
    if ([modeselected isEqual:@"2"]) {
        [self performSegueWithIdentifier:@"ChildIntroViewSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"AdultIntroViewSegue" sender:self];
    }
}

- (IBAction)PressSaveButton:(id)sender {
    //insert participant data to table
    if ([_subjectIDTextField.text isEqual: @""]) {
        //if experimenter does not enter subject id, present error alert view
        [self showUIAlerWithMessage:@"Please Enter Paticipant ID !" andTitle:@"Error"];
    } else {
        sqlite3_stmt *statment;
        const char * dbpath = [_databasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_SMALLDB)==SQLITE_OK){
            
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO paticipantdata (pid, testmode) VALUES (\"%@\", \"%@\")", _subjectIDTextField.text, modeselected];
            const char *insert_statment =[insertSQL UTF8String];
            sqlite3_prepare_v2(_SMALLDB, insert_statment, -1, &statment, NULL);
            
            if(sqlite3_step(statment)==SQLITE_DONE){
                //[self showUIAlerWithMessage:@"Paticipant add to the Database" andTitle:@"Message"];
                //Display start button and hidden all other buttons
                _startButton.hidden = NO;
                _saveButton.hidden = YES;
                _resetButton.hidden = YES;
                //disable text fields and change colour to gray
                _subjectIDTextField.enabled = NO;
                _typeSegment.enabled = NO;
                _subjectIDTextField.backgroundColor = [UIColor grayColor];

            }
            else{
                //show error message if fail to insert data
                [self showUIAlerWithMessage:@"Fail to create paticipant" andTitle:@"Error"];
                
            }
            sqlite3_finalize(statment);
            sqlite3_close(_SMALLDB);
        }
    }// end of insert data
        
}

- (IBAction)SelectTypeSegment:(id)sender {
    
    //read configure file path and update total test round
    NSArray *configurepaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [configurepaths objectAtIndex:0];
    propertypath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"configure.plist"]];
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    
    //set test type segment selection
    if (_typeSegment.selectedSegmentIndex == 0 ) {
        //test mode is adult mode
        modeselected = @"1";
        [configDict setObject:@"60" forKey:@"num_of_test"];
        [configDict setObject:modeselected forKey:@"mode_selected"];
        [configDict setObject:@"plain gene skit robe bin plin gean skti vobe bni" forKey:@"practice_list"];
        [configDict writeToFile:propertypath atomically:YES];
        
    } else if (_typeSegment.selectedSegmentIndex == 1 ) {
        //test mode is child mode set configure file
        modeselected= @"2";
        [configDict setObject:@"42" forKey:@"num_of_test"];
        [configDict setObject:modeselected forKey:@"mode_selected"];
        [configDict setObject:@"the hte cat cta fly lyf" forKey:@"practice_list"];
        [configDict writeToFile:propertypath atomically:YES];
    }
}





@end
