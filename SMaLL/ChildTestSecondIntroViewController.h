//
//  ChildTestSecondIntroViewController.h
//  SMaLL
//
//  Created by cj on 2017-07-13.
//  Copyright © 2017 MathLab Carleton University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildTestSecondIntroViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *RightFingerText;

@property (strong, nonatomic) IBOutlet UILabel *LeftFingerText;

@property (strong, nonatomic) IBOutlet UIImageView *GoImage;

@property (strong, nonatomic) IBOutlet UIButton *StartButton;

- (IBAction)PauseButton:(id)sender;

@end
