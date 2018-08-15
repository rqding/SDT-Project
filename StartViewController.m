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
    NSString *childTestTrialPath;
    NSString *adultTestTrialPath;
    NSArray *directoryContent;
    NSString *docsPath;
    NSString *testtrialpath;
    NSString *adultpraticetrials;
    NSString *childpracticetrials;
    NSUInteger numberofchildtesttrail, numberofadulttesttrail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set default button display
    _saveButton.hidden = NO;
    _resetButton.hidden = NO;
    _startButton.hidden = YES;
    
    BOOL firsttimefoldermessage = false;
    //default mode selected is Adult mode = 1, Child mode = 2
    modeselected = @"1";
    
    //set default type
    //read configure file path
    NSArray *configurepaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsPath = [configurepaths objectAtIndex:0];
    
    //create test trial image folder
    childTestTrialPath = [docsPath stringByAppendingPathComponent:@"/ChildTestTrials"];
    adultTestTrialPath = [docsPath stringByAppendingPathComponent:@"/AdultTestTrials"];
    //if trial images folder not exists create folder and show message require user create trial images
    if (![[NSFileManager defaultManager] fileExistsAtPath:childTestTrialPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:childTestTrialPath withIntermediateDirectories:NO attributes:nil error:nil];
        firsttimefoldermessage = true;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:adultTestTrialPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:adultTestTrialPath withIntermediateDirectories:NO attributes:nil error:nil];
        firsttimefoldermessage = true;
    }
    // If it is the first create test trials folder show message.
    if ( firsttimefoldermessage == true ) {
        [self showUIAlerWithMessage:@"Just create trial images folder. Please read online instruction and add test trail images to the folder" andTitle:@"Message"];
    }
    
    //create configure file
    propertypath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"configure.plist"]];
    
    //set default testing parameter for default adult mode
    //testing mode 1:adult(math symbol), testing mode 2: Child mode, default mode is adult
    modeselected = @"1";
    testtrialpath = adultTestTrialPath;
    adultpraticetrials = @"plain gene skit robe bin plin gean skti vobe bni";
    childpracticetrials = @"the hte cat cta fly lyf";
    
    // Get the dirctory
    dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPath[0];
    
    //setup path for config file
    propertypath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"configure.plist"]];
    //Check file exist
    NSFileManager *configfilemgr = [NSFileManager defaultManager];
    // if not configure file not create
    if([configfilemgr fileExistsAtPath:propertypath]==NO){
        // Set up default configuration parameters
        NSMutableDictionary *configDict = [[NSMutableDictionary alloc] init];
        [configDict setObject:@"2" forKey:@"time_limit"];
        [configDict setObject:@"1.5" forKey:@"feedback_time"];
        [configDict setObject:@"0.5" forKey:@"fixpoint_time"];
        [configDict setObject:@"0" forKey:@"num_of_test"];
        [configDict setObject:@"jpg" forKey:@"trial_file_extension"];
        [configDict setObject:adultpraticetrials forKey:@"adult_practice_list"];
        [configDict setObject:childpracticetrials forKey:@"child_practice_list"];
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
    // setup check file extentions
    NSArray *extensions = [NSArray arrayWithObjects:@"jpg", nil];
    
    if ([modeselected isEqual:@"2"]) {
        //If user check child button, check child test trial folder has test trials
        NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:childTestTrialPath error:nil];
        NSArray *files = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]];
        numberofchildtesttrail = [files count];
        if ( numberofchildtesttrail == 0) {
            [self showUIAlerWithMessage:@"There is no trail image found !" andTitle:@"Error"];
        }
        else {
            [self UpdateNumOfTestConfig:numberofchildtesttrail];
            [self performSegueWithIdentifier:@"ChildIntroViewSegue" sender:self];
        }
        
    } else {
        //If user check adult button, check adult test trial folder has test trials
        NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:adultTestTrialPath error:nil];
        NSArray *files = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]];
        numberofadulttesttrail = [files count];
        if ( numberofadulttesttrail == 0) {
            [self showUIAlerWithMessage:@"There is no trail image found ! Please read instruction and add test trails" andTitle:@"Error"];
        }
        else {
            [self UpdateNumOfTestConfig:numberofadulttesttrail];
            [self performSegueWithIdentifier:@"AdultIntroViewSegue" sender:self];
        }
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
                //read configure file path and update total test round
                propertypath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"configure.plist"]];
                NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
                //Setup configuration parameters
                [configDict setObject:testtrialpath forKey:@"test_trial_path"];
                [configDict setObject:modeselected forKey:@"mode_selected"];
                [configDict writeToFile:propertypath atomically:YES];
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
    
    //set test type segment selection
    if (_typeSegment.selectedSegmentIndex == 0 ) {
        //test mode is adult mode set configure file
        modeselected = @"1";
        testtrialpath = adultTestTrialPath;
        
    } else if (_typeSegment.selectedSegmentIndex == 1 ) {
        //test mode is child mode set configure file
        modeselected= @"2";
        testtrialpath = childTestTrialPath;
    }
}

- (IBAction)PressExitButton:(id)sender {
    //press top bar Exit button show quit app alert view
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to quit now ?"
                                                    message:@"Press YES to quit. Press cancel back to practice."
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

- (void)UpdateNumOfTestConfig:(NSUInteger)numoftest {
    //read configure file path and update total test round
    propertypath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"configure.plist"]];
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    [configDict setObject:[NSString stringWithFormat:@"%lu", (unsigned long)numoftest] forKey:@"num_of_test"];
    [configDict writeToFile:propertypath atomically:YES];

}


@end
