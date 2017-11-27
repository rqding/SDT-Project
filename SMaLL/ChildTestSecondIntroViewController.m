//
//  ChildTestSecondIntroViewController.m
//  SMaLL
//
//  Created by cj on 2017-07-13.
//  Copyright © 2017 MathLab Carleton University. All rights reserved.
//

#import "ChildTestSecondIntroViewController.h"

@interface ChildTestSecondIntroViewController ()

@end

@implementation ChildTestSecondIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _StartButton.hidden = YES;
    
    //Update font color for right finger label
    NSString *rightfingertext = _RightFingerText.text;
    NSMutableAttributedString *rightfingerstring = [self addColorAttributeToString:rightfingertext size:18.0f];
    //set right finger label with attributes
    [_RightFingerText setAttributedText:rightfingerstring];
    
    //Update font color for left finger label
    NSString *leftfingertext = _LeftFingerText.text;
    NSMutableAttributedString *leftfingerstring = [self addColorAttributeToString:leftfingertext size:18.0f];
    //set left finger label with attributes
    [_LeftFingerText setAttributedText:leftfingerstring];
    
    //delay show next button 2s
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(showNextButton) userInfo:nil repeats:NO];
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

-(NSMutableAttributedString *)addColorAttributeToString: (NSString *)inputtext size:(double)size {
    //set font attribute
    UIFont *textFont = [UIFont systemFontOfSize:size];
    NSDictionary * fontAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:textFont, NSFontAttributeName, nil];
    
    //seperate intro text into words
    NSArray *words=[inputtext componentsSeparatedByString:@" "];
    
    //Add color attribute to intro text
    NSMutableAttributedString *stringtext = [[NSMutableAttributedString alloc]initWithString:inputtext attributes:fontAttributes];
    for (NSString *word in words) {
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

-(void)showNextButton {
    _GoImage.hidden = YES;
    _StartButton.hidden = NO;
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
