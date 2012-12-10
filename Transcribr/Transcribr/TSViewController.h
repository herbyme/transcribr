//
//  TSViewController.h
//  Transcribr
//
//  Created by Herbert Yeung on 10/12/12.
//  Copyright (c) 2012 becontactable. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_RECORDING_TIME 1800 //30 minutes = 1800 seconds
#define GRAYED_OUT 0.5

@interface TSViewController : UIViewController

@property (strong, nonatomic) NSDate *recordDate;

@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

- (void)countdownUpdate:(NSTimer*)timer;
- (IBAction)recordAction:(id)sender;
- (IBAction)pauseAction:(id)sender;
- (IBAction)stopAction:(id)sender;

@end
