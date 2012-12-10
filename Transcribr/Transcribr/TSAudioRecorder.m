//
//  TSAudioRecorder.m
//  Transcribr
//
//  Created by Herbert Yeung on 10/12/12.
//  Copyright (c) 2012 becontactable. All rights reserved.
//

#import "TSAudioRecorder.h"

@implementation TSAudioRecorder

-(void) startRecording {
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyRecording.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    NSLog(@"URL: %@", outputFileURL);
    
    fileWriter = [[AudioFileWriter alloc]
                  initWithAudioFileURL:outputFileURL
                  samplingRate:audioManager.samplingRate
                  numChannels:audioManager.numInputChannels];
    
    
    __block int counter = 0;
    audioManager.inputBlock = ^(float *data, UInt32 numFrames, UInt32 numChannels) {
        [fileWriter writeNewAudio:data numFrames:numFrames numChannels:numChannels];
        counter += 1;
        if (counter > AUDIO_MAX_SIZE) {
            audioManager.inputBlock = nil;
//            [fileWriter release];
        }
    };

}

@end
