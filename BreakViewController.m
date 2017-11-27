//
//  BreakViewController.m
//  SMaLL
//
//  Created by cj on 2016-11-03.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import "BreakViewController.h"
#import "TestInstructionFirstViewController.h"
#import "TestViewController.h"

@interface BreakViewController ()

@end

@implementation BreakViewController
{
    NSArray *paths;
    NSString *docsPath;
    NSString *propertypath;
    NSString *testround;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _BreakLabel.hidden = NO;
    _NextButton.hidden = YES;
    //read configure file
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsPath = [paths objectAtIndex:0];
    //get configuration data
    propertypath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"configure.plist"]];
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    testround = [configDict objectForKey:@"current_round"];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(showNextButton) userInfo:nil repeats:NO];
    
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

-(void)showNextButton {
    _NextButton.hidden = NO;
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

- (IBAction)PressNextButton:(id)sender {
    //set num of tested after break screen showed
    int currentround = [testround intValue];
    currentround++; //start next round
    testround = [NSString stringWithFormat:@"%d", currentround];
    
    //set test round value in configure file
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithContentsOfFile:propertypath];
    [configDict setObject:testround forKey:@"current_round"];
    [configDict writeToFile:propertypath atomically:YES];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //press yes to quit app
    if (alertView.tag ==100) {
        if (buttonIndex ==1)
            exit(0);
    }
}

@end
