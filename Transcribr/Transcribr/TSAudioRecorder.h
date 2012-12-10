//
//  TSAudioRecorder.h
//  Transcribr
//
//  Created by Herbert Yeung on 10/12/12.
//  Copyright (c) 2012 becontactable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Novocaine.h"
#import "AudioFileWriter.h"

#define AUDIO_MAX_SIZE 144000 // Roughly 30mins of Audio

@interface TSAudioRecorder : NSObject
{
    Novocaine *audioManager;
    AudioFileWriter *fileWriter;
}

@property (nonatomic, copy) NSString* fileName;

-(BOOL) checkEnoughDiskSpace;
-(void) startRecording;
-(void) pauseRecording;
-(void) stopRecording;
-(UInt32) audioFileSize;

@end
