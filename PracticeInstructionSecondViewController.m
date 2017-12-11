//
//  PracticeInstructionSecondViewController.m
//  SMaLL
//
//  Second screen of practice instruction. Reminding the button function, ready to start the practice round
//
//  Created by Richard Ding on 2016-10-27.
//  Copyright © 2016 MathLab Carleton University. All rights reserved.
//

#import "PracticeInstructionSecondViewController.h"

@interface PracticeInstructionSecondViewController ()

@end

@implementation PracticeInstructionSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _NextFunctionButton.hidden = YES;
    _GreenButton.hidden = NO;
    _RedButton.hidden = NO;
    _GoImage.hidden = NO;
    
    //update font color for first paragraph
    NSString *introtext = _FirstParagraphText.text;
    NSMutableAttributedString *introstring = [self addColorAttributeToString:introtext size:22.0f];
    //set First Paragraph text with attributes
    [_FirstParagraphText setAttributedText:introstring];
    
    //Update font color for first point label
    NSString *firstpointtext = _FirstpointLabel.text;
    NSMutableAttributedString *firstpointstring = [self addColorAttributeToString:firstpointtext size:18.0f];
    //set First Paragraph text with attributes
    [_FirstpointLabel setAttributedText:firstpointstring];
    
    //Update font color for second point label
    NSString *secondpointtext = _SecondpointLabel.text;
    NSMutableAttributedString *secondpointstring = [self addColorAttributeToString:secondpointtext size:18.0f];
    //set First Paragraph text with attributes
    [_SecondpointLabel setAttributedText:secondpointstring];
    
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
    _GoImage.hidden = YES;
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
        if ([word hasPrefix:@"NO"]) {
            NSRange range=[inputtext rangeOfString:word];
            [stringtext addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        }
        if ([word hasPrefix:@"YES"]) {
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
