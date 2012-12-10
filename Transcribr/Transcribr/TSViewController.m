//
//  TSViewController.m
//  Transcribr
//
//  Created by Herbert Yeung on 10/12/12.
//  Copyright (c) 2012 becontactable. All rights reserved.
//

#import "TSViewController.h"

@interface TSViewController ()

@end

@implementation TSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Gray out pause & stop buttons
    [[self pauseButton] setEnabled:NO];
    [[self stopButton] setEnabled:NO];
    [[self pauseButton] setAlpha:GRAYED_OUT];
    [[self stopButton] setAlpha:GRAYED_OUT];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordAction:(id)sender {

    // Grab the current date & time
    [self setRecordDate:[NSDate date]];
    
    // create the timer, hold a reference to the timer if we want to cancel ahead of countdown
    [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(countdownUpdate:) userInfo:nil repeats:YES];
    
    // Ungray out pause & stop buttons and gray out record button
    [[self pauseButton] setEnabled:YES];
    [[self stopButton] setEnabled:YES];
    [[self recordButton] setEnabled:NO];
    [[self pauseButton] setAlpha:1];
    [[self stopButton] setAlpha:1];
    [[self recordButton] setAlpha:GRAYED_OUT];
}

-(void)countdownUpdate:(NSTimer*) timer {
    // code is written so one can see everything that is happening
    // I am sure, some people would combine a few of the lines together
    NSDate *currentDate = [NSDate date];
    NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:[self recordDate]];
    
    NSTimeInterval difference = MAX_RECORDING_TIME - elaspedTime;
    if (difference <= 0) {
        [timer invalidate];  // kill the timer
        difference = 0;      // set to zero just in case iOS fired the timer late
    }
    int minutes = (int)difference/60;
    int seconds =  (int)difference%60;
    
    // update the label with the remainding seconds
    [[self timeLeftLabel] setText:[NSString stringWithFormat:@"%02d:%02d", minutes, seconds]];
    
    // Re-initialise the settings back to original if max recording time is reached
    if (difference <= 0) {
        [[self pauseButton] setEnabled:NO];
        [[self stopButton] setEnabled:NO];
        [[self recordButton] setEnabled:YES];
        [[self pauseButton] setAlpha:GRAYED_OUT];
        [[self stopButton] setAlpha:GRAYED_OUT];
        [[self recordButton] setAlpha:1];
        [[self timeLeftLabel] setText:@"30:00"];
    }
}

@end
