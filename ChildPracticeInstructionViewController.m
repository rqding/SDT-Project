//
//  ChildPracticeInstructionViewController.m
//  SMaLL
//
//  Created by Richard Dings on 2017-07-12.
//  Copyright © 2017 MathLab Carleton University. All rights reserved.
//

#import "ChildPracticeInstructionViewController.h"

@interface ChildPracticeInstructionViewController ()

@end

@implementation ChildPracticeInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _StartPracticeButton.hidden = YES;
    
    //update font color for Instruction paragraph
    NSString *introtext = _InstructionText.text;
    NSMutableAttributedString *introstring = [self addColorAttributeToString:introtext size:22.0f];
    //set Instruction Paragraph text with attributes
    [_InstructionText setAttributedText:introstring];
    
    //Update font color for readable label
    NSString *readabletext = _ReadableText.text;
    NSMutableAttributedString *readablestring = [self addColorAttributeToString:readabletext size:18.0f];
    //set readable label with attributes
    [_ReadableText setAttributedText:readablestring];
    
    //Update font color for unreadable label
    NSString *unreadabletext = _UnreadableText.text;
    NSMutableAttributedString *unreadablestring = [self addColorAttributeToString:unreadabletext size:18.0f];
    //set unreadable label with attributes
    [_UnreadableText setAttributedText:unreadablestring];
    
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
    
    //delay show next button 10s
    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(showNextButton) userInfo:nil repeats:NO];
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
        
        if ([word hasPrefix:@"QUICK"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        }
        
        if ([word hasPrefix:@"ACCURATE"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        }
    }
    return stringtext;
}


-(void)showNextButton {
    _GoImage.hidden = YES;
    _StartPracticeButton.hidden = NO;
}

- (IBAction)PauseButton:(id)sender {
    //press top bar pause button show quit app alert view
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

@end
