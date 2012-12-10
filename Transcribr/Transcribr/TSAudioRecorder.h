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
#define FILE_MAX_SIZE 50      // Roughly Max of 50Mb of Audio for 30Mins

@interface TSAudioRecorder : NSObject
{
    Novocaine *audioManager;
    AudioFileWriter *fileWriter;
}

@property (nonatomic, copy) NSString* fileName;

-(BOOL) checkEnoughDiskSpace;
-(BOOL) startRecording;
-(void) pauseRecording;
-(void) stopRecording;
-(UInt32) audioFileSize;

@end
