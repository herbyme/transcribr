//
//  TSViewController.m
//  Transcribr
//
//  Created by Herbert Yeung on 10/12/12.
//  Copyright (c) 2012 becontactable. All rights reserved.
//

#import "TSViewController.h"
#import "TSAudioRecorder.h"

@interface TSViewController ()
{
    TSAudioRecorder *audioRecorder;
    NSTimer *timer;
}
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
    [self setPause:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordAction:(id)sender {

    // Grab the current date & time
    [self setRecordDate:[NSDate date]];
    
    // Initialise the audioRecorder with filename & then start recording
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[self recordDate] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
    audioRecorder = [[TSAudioRecorder alloc] initWithFilename:dateString];
//    [audioRecorder startRecording];
    
    // Create timer, hold a reference to timer if we want to cancel ahead of countdown
    timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(countdownUpdate:) userInfo:nil repeats:YES];
    
    // Ungray out pause & stop buttons and gray out record button
    [[self pauseButton] setEnabled:YES];
    [[self stopButton] setEnabled:YES];
    [[self recordButton] setEnabled:NO];
    [[self pauseButton] setAlpha:1];
    [[self stopButton] setAlpha:1];
    [[self recordButton] setAlpha:GRAYED_OUT];
}

- (IBAction)pauseAction:(id)sender {

    [[self pauseButton] setEnabled:YES];
    [[self pauseButton] setAlpha:1];
    
    if ([[[[self pauseButton] titleLabel] text] isEqualToString:@"Pause"]) {
        [[self pauseButton] setTitle:@"Resume" forState:UIControlStateNormal];
        
        // Ungray out pause & gray out rest
        [[self stopButton] setEnabled:NO];
        [[self stopButton] setAlpha:GRAYED_OUT];
        [self setPause:YES];
        [timer invalidate]; // Cancels the scheduledTimerWithTimeInterval
    }
    else {
        [[self pauseButton] setTitle:@"Pause" forState:UIControlStateNormal];
        
        // Ungray out pause & gray out rest
        [[self stopButton] setEnabled:YES];
        [[self stopButton] setAlpha:1];
        
        [self setPause:NO];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(countdownUpdate:) userInfo:nil repeats:YES]; // create timer, hold ref to timer if we want to cancel ahead of countdown
    }
}

- (IBAction)stopAction:(id)sender {
    // Ungray out pause & gray out rest
    [[self pauseButton] setEnabled:NO];
    [[self stopButton] setEnabled:NO];
    [[self recordButton] setEnabled:YES];
    [[self pauseButton] setAlpha:GRAYED_OUT];
    [[self stopButton] setAlpha:GRAYED_OUT];
    [[self recordButton] setAlpha:1];
    
    if ([[[[self pauseButton] titleLabel] text] isEqualToString:@"Resume"]) {
        [[self pauseButton] setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
    [timer invalidate]; // Cancels the scheduledTimerWithTimeInterval
    [[self timeLeftLabel] setText:@"30:00"];
}

-(void)countdownUpdate:(NSTimer*) timer {
    if (![self pause]) {
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
}

@end
