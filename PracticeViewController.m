//
//  PracticeViewController.m
//  SMaLL
//
//  Practice view present looping practice trials for english words.
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import "PracticeViewController.h"
#import "TrialObject.h"

@interface PracticeViewController ()

@end

@implementation PracticeViewController
{
    double timelimit;
    double feedback_timelimit;
    double fixpoint_timelimit;
    int loopcount;
    NSInteger numofpractice;
    NSArray *paths;
    NSString *docsPath;
    NSString *propertypath;
    NSMutableArray *practiceArray;
    NSString *buttonpressed;
    NSString *practicetext;
    NSString *practiceresult;
    NSString *testmode;
    NSString *YesResponseText;
    NSString *NoResponseText;
    
}

@synthesize trialobject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loopcount = 0;
    
    //default buttons setup
    _YesButton.hidden = YES;
    _NoButton.hidden = YES;
    _FixpointLabel.hidden = YES;
    _TrialLabel.hidden = YES;
    _WrongImage.hidden = YES;
    _WrongLabel.hidden = YES;
    _CorrectImage.hidden = YES;
    _CorrectLabel.hidden = YES;
    _NextButton.hidden = YES;
    _ResponseLabel.hidden = YES;
    //disable the pause button
    _PauseButton.enabled = NO;
    practicetext = @"";
    buttonpressed = @"";
    practiceresult = @"";
    YesResponseText = @"You Marked YES";
    NoResponseText = @"You Marked NO";
    
    //init practice array
    practiceArray = [[NSMutableArray alloc]init];
    
    //read configure file
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsPath = [paths objectAtIndex:0];
    //get paramiter from configuration file
    propertypath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"configure.plist"]];
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    timelimit = [[configDict objectForKey:@"time_limit"] doubleValue];
    feedback_timelimit = [[configDict objectForKey:@"feedback_time"] doubleValue];
    fixpoint_timelimit = [[configDict objectForKey:@"fixpoint_time"] doubleValue];
    testmode = [configDict objectForKey:@"mode_selected"];
    NSString *practicestring = [configDict objectForKey:@"practice_list"];
    practiceArray = [self generatePracticeTrial:practicestring];
    //start practice loop
    [self practiceLoop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)PressNoButton:(id)sender {
    //Press No Button response as unreadable
    _PauseButton.enabled = NO;
    [self clearButtonText];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //record practice trial result
    buttonpressed = @"N";
    
    [self responsefeedback];
}

- (IBAction)PressYesButton:(id)sender {
    //Press Yes Button response as readable
    _PauseButton.enabled = NO;
    [self clearButtonText];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //record practice trial result
    buttonpressed = @"Y";
    [self responsefeedback];
    
}

- (IBAction)PauseButton:(id)sender {
    //press top bar pause button show quit app alert view
    [self clearButtonText];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to quit now ?"
                                                    message:@"Press YES to quit. Press cancel back to practice."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"YES", nil];
    alert.tag = 100;
    [alert show];
}

- (IBAction)StartTestRoundButton:(id)sender {
    //set test round value in configure file
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    [configDict writeToFile:propertypath atomically:YES];
    
    // start test introduction view base on mode selected
    if ([testmode isEqual:@"2"]) {
        [self performSegueWithIdentifier:@"ChildTestIntroViewSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"AdultTestIntroViewSegue" sender:self];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //press yes to quit app
    if (alertView.tag ==100) {
        if (buttonIndex ==1)
            exit(0);
        if (buttonIndex ==0){
            //redo the same trial
            loopcount--;
            [self practiceLoop];
        }
    }
}

-(void)showfixpoint{
    //Every round start with fix point
    _FixpointLabel.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:fixpoint_timelimit target:self selector:@selector(showpracticetrial) userInfo:nil repeats:NO];
}

-(void)showpracticetrial{
    //hidden fixation point and show trial label with two buttons, enable pause button
    _FixpointLabel.hidden = YES;
    _TrialLabel.hidden = NO;
    _YesButton.hidden = NO;
    _NoButton.hidden = NO;
    _PauseButton.enabled = YES;
    // if no response condition after time limit
    if (timelimit != 0) {
        [self performSelector:@selector(hiddentrial) withObject:@"" afterDelay:timelimit];
    }
}

-(void)hiddentrial {
    //after time limit hidden trial and clear label text
    _TrialLabel.text = @"";
    _TrialLabel.hidden = YES;
}

-(void)responsefeedback {
    [self clearButtonText];
    // if test mode selected is not child mode provide user response feedback
    if (![testmode isEqual:@"2"]) {;
        if ([buttonpressed isEqual:@"Y"]) {
            _ResponseLabel.text = YesResponseText;
            _ResponseLabel.textColor = [UIColor greenColor];
            _ResponseLabel.hidden = NO;
        } else {
            _ResponseLabel.text = NoResponseText;
            _ResponseLabel.textColor = [UIColor redColor];
            _ResponseLabel.hidden = NO;
        }
    } else {
        // if test mode selected is child mode. Provide correct or incorrect feedback.
        if ([practiceresult isEqualToString:buttonpressed]) {
            //Correct response
            _CorrectLabel.hidden = NO;
            _CorrectImage.hidden = NO;
        } else {
            //Incorrect response
            _WrongLabel.hidden = NO;
            _WrongImage.hidden = NO;
            loopcount--;
        }
    }
    [self performSelector:@selector(hiddenfeedback) withObject:@"" afterDelay:feedback_timelimit];
}

-(void)hiddenfeedback {
    _CorrectLabel.hidden = YES;
    _CorrectImage.hidden = YES;
    _WrongImage.hidden = YES;
    _WrongLabel.hidden = YES;
    _ResponseLabel.hidden = YES;
    [self practiceLoop];
}

-(void)clearButtonText {
    //after user press YES or No button clear trial and button
    _TrialLabel.text = @"";
    _TrialLabel.hidden = YES;
    _YesButton.hidden = YES;
    _NoButton.hidden = YES;
}

/*
 Practice loop
 Loop present practice trials
 */
-(void) practiceLoop {
    TrialObject *practicetrial = [[TrialObject alloc] init];
    if (loopcount < numofpractice) {
        //set practice trial label text
        practicetrial=practiceArray[loopcount];
        practicetext = practicetrial.trialstring;
        practiceresult = practicetrial.trialresult;
        _TrialLabel.text = practicetext;
        loopcount++;
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showfixpoint) userInfo:nil repeats:NO];
    } else {
        //finish practice loop show next button
        _NextButton.hidden = NO;
    }
    
}

/*
 Pause practice loop
 Hidden all components
 */
-(void) pausepractice {
    
    _YesButton.hidden = YES;
    _NoButton.hidden = YES;
    _FixpointLabel.hidden = YES;
    _TrialLabel.hidden = YES;
    _CorrectLabel.hidden = YES;
    _CorrectImage.hidden = YES;
    _WrongImage.hidden = YES;
    _WrongLabel.hidden = YES;
}

/*
 Input practice string from configure file
 Output practice trial list (NSMutableArray)
 */
-(NSMutableArray *) generatePracticeTrial:(NSString *)practicestring
{
    
    NSMutableArray *trialArray;
    trialArray = [[NSMutableArray alloc]init];
    
    //seperate string into words
    NSArray *words=[practicestring componentsSeparatedByString:@" "];
    int index = 0;
    for (NSString *text in words) {
        TrialObject *newtrial = [[TrialObject alloc] init];
        newtrial.trialstring = text;
        if ( index % 2 != 0) {
            newtrial.trialresult = @"N";
        } else {
            newtrial.trialresult = @"Y";
        }
        [trialArray addObject:newtrial];
        index++;
    
    } //end of create practice list
    
    //Create random practice trial list
    // Select a random element between i and end of array to swap with.
    numofpractice = trialArray.count;
    NSUInteger count = numofpractice;
    for (NSUInteger i = 0; i<count; ++i) {
        NSUInteger nElements = count-i;
        NSUInteger n = (arc4random() % nElements) + i;
        [trialArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return trialArray;
}


@end
