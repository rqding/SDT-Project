//
//  TestViewController.m
//  SMaLL
//
//  Test view present looping test trial picture of math symbols.
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import "TestViewController.h"
#import "TestInstructionFirstViewController.h"
#import "TrialObject.h"

@interface TestViewController ()

@end

@implementation TestViewController
{
    double timelimit;
    double feedback_timelimit;
    double fixpoint_timelimit;
    int loopcount;
    int correct;
    int testid;
    int testround;
    int totaltestround;
    int numoftest;
    NSArray *paths;
    NSString *docsPath;
    NSString *propertypath;
    NSMutableArray *testArray;
    NSString *testtrialname;
    NSString *readable;
    NSString *unreadable;
    NSString *picturename;
    NSString *trialresult;
    
    NSString *PID;
    NSString *groupID;
    NSString *testmode;
    NSString *testtype;
    NSString *firsttesttype;
    NSString *secondtesttype;
    NSString *reactiontime;
    NSString *currentdate;
    
    NSTimeInterval starttime;
    NSTimeInterval endtime;
    CGSize updateimagesize;
}

@synthesize trialobject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loopcount = 0;
    readable = @"Y";
    unreadable = @"N";
    testid = 0;
    //default buttons setup
    _YesButton.hidden = YES;
    _NoButton.hidden = YES;
    _FixpointLabel.hidden = YES;
    _TrialImage.hidden = YES;
    _FinishButton.hidden = YES;
    _ExitButton.hidden = YES;
    _NextButton.hidden = YES;
    //disable the pause button
    _PauseButton.enabled = NO;
    
    
    //get current date to string
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentdate = [dateFormatter stringFromDate:now];

    //init test array
    testArray = [[NSMutableArray alloc]init];
    
    //read configure file
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsPath = [paths objectAtIndex:0];
    //get configuration data
    propertypath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"configure.plist"]];
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    timelimit = [[configDict objectForKey:@"time_limit"] doubleValue];
    feedback_timelimit = [[configDict objectForKey:@"feedback_time"] doubleValue];
    fixpoint_timelimit = [[configDict objectForKey:@"fixpoint_time"] doubleValue];
    numoftest = [[configDict objectForKey:@"num_of_test"] intValue];
    testround = [[configDict objectForKey:@"current_round"] intValue];
    totaltestround = [[configDict objectForKey:@"total_test_round"] intValue];
    
    //get paticipant info from paticipant table
    _databasePath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"small.db"]];
    
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
    
    //resize the image if it is child mode
    if ([testmode isEqual:@"3"]) {
        NSLog(@"Rezie the IMAGE");
        float width = _TrialImage.frame.size.width*3;
        float height = _TrialImage.frame.size.height*3;
        NSLog(@"SIZE WIDTH : %f AND HIEGHT: %f", width, height);
        _TrialImage.frame = CGRectMake(_TrialImage.frame.origin.x, _TrialImage.frame.origin.y, width, height);
        _TrialImage.contentMode = UIViewContentModeScaleAspectFit;
    
    }
    
    //if break view passed value, this is the second round
    if (testround == 1 )
    {
        testtype = firsttesttype;
        
    } else if (testround == 2){
        testtype = secondtesttype;
    }
    
    //generate test object loop
    testArray = [self generatePracticeTrial:numoftest];
    //start practice loop
    [self testLoop];
    
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


- (IBAction)PressYesButton:(id)sender {
    //end timer
    endtime = [[NSDate date] timeIntervalSinceReferenceDate];
    //Press Yes Button response as readable
    _PauseButton.enabled = NO;
    [self clearButtonText];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self writetotable:1];
}

- (IBAction)PressNoButton:(id)sender {
    //end timer
    endtime = [[NSDate date] timeIntervalSinceReferenceDate];
    //Press No Button response as unreadable
    _PauseButton.enabled = NO;
    [self clearButtonText];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self writetotable:0];
}

- (IBAction)PauseButton:(id)sender {
    //press top bar pause button show quit app alert view
    [self clearButtonText];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to quit now ?"
                                                    message:@"Press YES to quit. Press cancel back to test."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"YES", nil];
    alert.tag = 100;
    [alert show];
}

- (IBAction)PressFinishButton:(id)sender {
    
    //remove the current test round key from plist
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    [configDict removeObjectForKey:@"current_round"];
    [configDict writeToFile:propertypath atomically:YES];
    
    //write trialdatatable to csv file
    
    NSString *csv = @"index,trialcount,date,subjectID,testmode,testtype,stimulusnum,trialcode,pictureID,responseButton,correct,reactiontime\n";
    
    NSString *testfile = [docsPath stringByAppendingPathComponent:@"smalloutput.csv"];
    NSError *error;
    
    sqlite3_stmt *statment;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_SMALLDB)==SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM resultdata"];
        
        const char *sql_statment =[querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_SMALLDB, sql_statment, -1, &statment, NULL) == SQLITE_OK){
            while(sqlite3_step(statment) == SQLITE_ROW){
                
                NSInteger dataid = sqlite3_column_int(statment, 0);
                NSInteger trialcount = sqlite3_column_int(statment, 1);
                NSString *testdate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 2)];
                NSString *pid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 3)];
                NSString *mode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 4)];
                NSString *type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 5)];
                NSInteger stimulusno = sqlite3_column_int(statment, 6);
                NSInteger code = sqlite3_column_int(statment, 7);
                NSString *picid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 8)];
                NSInteger button = sqlite3_column_int(statment, 9);
                NSInteger result = sqlite3_column_int(statment, 10);
                NSString *reaction = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 11)];
                
                csv = [csv stringByAppendingFormat:@"%ld,%ld,%@,%@,%@,%@,%ld,%ld,%@,%ld,%ld,%@\n", (long)dataid, (long)trialcount,testdate, pid, mode, type, (long)stimulusno, (long)code, picid, (long)button, (long)result, reaction];
            } //end of while
            sqlite3_finalize(statment);
            sqlite3_close(_SMALLDB);
            [self showUIAlerWithMessage:@"Save data to csv file." andTitle:@"Message"];
            
            BOOL ok = [csv writeToFile:testfile atomically:NO encoding:NSUTF8StringEncoding error:&error];
            
            if (!ok) {
                // an error occurred
                NSLog(@"Error writing file the error is %@\n", error);
            }
            _FinishButton.hidden = YES;
            _ExitButton.hidden = NO;
            
        } else {
            
            [self showUIAlerWithMessage:@"Fail to get data from database" andTitle:@"Error"];
            
        }
        
    }

}

- (IBAction)PressExitButton:(id)sender {
    //exit app
    exit(0);
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //press yes to quit app
    if (alertView.tag ==100) {
        if (buttonIndex ==1)
            _FinishButton.hidden = NO;
        if (buttonIndex ==0){
            //redo the same trial
            loopcount--;
            [self testLoop];
        }
    }
}

/*
 test loop
 Loop present test trial image
 */
-(void) testLoop {
    TrialObject *testtrial = [[TrialObject alloc] init];
    if (loopcount < numoftest) {
        //get trial ID
        testtrial=testArray[loopcount];
        testid = [testtrial.trialid intValue];
        //check image name exists
        
        NSString *imageNameYes = [NSString stringWithFormat:@"%@-item-%d-%@", testtype, testid, readable];
        NSString *imageNameNo = [NSString stringWithFormat:@"%@-item-%d-%@", testtype, testid, unreadable];
        
        NSString *imagefileyes = [[NSBundle mainBundle] pathForResource:imageNameYes ofType:@"jpg"];
        NSString *imagefileno = [[NSBundle mainBundle] pathForResource:imageNameNo ofType:@"jpg"];
        if ([UIImage imageWithContentsOfFile:imagefileyes] != nil) {
            //setup trial information
            testtrial.trialstring = imageNameYes;
            testtrial.trialresult = readable;
            //set trial image
            _TrialImage.image = [UIImage imageWithContentsOfFile:imagefileyes];
        } else if ([UIImage imageWithContentsOfFile:imagefileno] != nil){
            //setup trial information
            testtrial.trialstring = imageNameNo;
            testtrial.trialresult = unreadable;
            //set trial image
            _TrialImage.image = [UIImage imageWithContentsOfFile:imagefileno];
        } else {
            NSLog(@"Unable fine item %d", testid);
        }
        picturename = testtrial.trialstring;
        trialresult = testtrial.trialresult;
        loopcount++;
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showfixpoint) userInfo:nil repeats:NO];
    } else {
        //After test round finish, release memory
        [testArray removeAllObjects];
        if (testround >= totaltestround ) {
            //finish test loop show finish button
            _FinishButton.hidden = NO;
            //remove the current test round key from plist
            NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
            [configDict removeObjectForKey:@"current_round"];
            [configDict writeToFile:propertypath atomically:YES];
            
        } else {
            //ready to start next round
            _NextButton.hidden = NO;
        }
    }
}



-(void)showfixpoint{
    //Every round start with fix point
    _FixpointLabel.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:fixpoint_timelimit target:self selector:@selector(showtesttrial) userInfo:nil repeats:NO];
    
}

-(void)showtesttrial{
    //start timer
    starttime = [[NSDate date] timeIntervalSinceReferenceDate];
    //hidden fixation point and show trial label with two buttons, enable pause button
    _FixpointLabel.hidden = YES;
    _TrialImage.hidden = NO;
    _YesButton.hidden = NO;
    _NoButton.hidden = NO;
    _PauseButton.enabled = YES;
    // if no response condition after time limit hidden trial image
    if (timelimit != 0) {
        [self performSelector:@selector(hiddentrial) withObject:@"" afterDelay:timelimit];
    }
}

-(void)hiddentrial {
    //after time limit hidden trial and clear label text
    _TrialImage.hidden = YES;
}

-(void)clearButtonText {
    //after user press YES or No button clear trial and button
    _TrialImage.image = nil;
    _TrialImage.hidden = YES;
    _YesButton.hidden = YES;
    _NoButton.hidden = YES;
}


-(NSMutableArray *) generatePracticeTrial:(int)numtest {
    NSMutableArray *triallist;
    triallist = [[NSMutableArray alloc]init];
    //Initially create trial list
    for (int i=1; i<=numtest; i++){
        TrialObject *testtrial = [[TrialObject alloc] init];
        testtrial.trialid = [NSNumber numberWithInt:i];
        [triallist addObject:testtrial];
    }
    
    //Create random test trial list
    // Select a random element between i and end of array to swap with.
    NSUInteger count = numtest;
    for (NSUInteger i = 0; i<count; ++i) {
        NSUInteger nElements = count-i;
        NSUInteger n = (arc4random() % nElements) + i;
        [triallist exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

    return triallist;
}

- (void)writetotable:(int)button{
    
    int trialcode;//(stimulus)1 for trial is readable, 0 for trial is unreadable
    //convert trail image name to trialcode
    if ([trialresult isEqual:@"Y"]){
        trialcode = 1;
    } else {
        trialcode = 0;
    }
    //convert s type to 1, and p type to 2 in database
    NSString *type;
    if ([testtype isEqual:@"S"]) {
        type = @"1";
    } else if ([testtype isEqual:@"P"]){
        type = @"2";
    } else {
        type = @"3";
    }
    
    if (button == trialcode) {
        correct = 1; //correct response
    } else {
        correct = 0; //wrong response
    }
    
    double rt = endtime-starttime;
    reactiontime = [NSString stringWithFormat:@"%f", rt];
    
    sqlite3_stmt *statment;
    const char *dbpath = [_databasePath UTF8String];
    
    //insert to database
    if(sqlite3_open(dbpath, &_SMALLDB)==SQLITE_OK){
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO resultdata (trialcount, date, pid, testmode, testtype, trialnumber, trialcode, pictureid, response, correct, reactiontime) VALUES (\"%d\",\"%@\", \"%@\",\"%@\", \"%@\", \"%d\", \"%d\",\"%@\", \"%d\", \"%d\", \"%@\")", loopcount, currentdate, PID, testmode,type, testid, trialcode, picturename, button, correct, reactiontime];
        
        const char *insert_statment =[insertSQL UTF8String];
        
        sqlite3_prepare_v2(_SMALLDB, insert_statment, -1, &statment, NULL);
        
        if(sqlite3_step(statment)==SQLITE_DONE){
            [self testLoop];
        } else {
            [self showUIAlerWithMessage:@"Fail to insert the row !" andTitle:@"Error"];
            
        }
        sqlite3_finalize(statment);
        sqlite3_close(_SMALLDB);
    }// end of insert data
    trialobject = nil;
    //_TrialImage.image = nil;
}


@end
