//
//  TSAudioRecorder.m
//  Transcribr
//
//  Created by Herbert Yeung on 10/12/12.
//  Copyright (c) 2012 becontactable. All rights reserved.
//

#import "TSAudioRecorder.h"

@implementation TSAudioRecorder

-(id) initWithFilename: (NSString*) name {
    self = [self init];
    if (self) {
        [self setFileName:name];
    }
    return self;
}

-(BOOL) startRecording {
    if ([self checkEnoughDiskSpace]) {
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   [[self fileName] stringByAppendingString:@".m4a"],
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
        
        return YES;
    }
    else
        return NO;
}

-(void) pauseRecording {
    if (audioManager) {
        [audioManager pause];
    }
}

-(void) stopRecording {
    [self pauseRecording];
    audioManager.inputBlock = nil; // Resets the block
}

-(BOOL) checkEnoughDiskSpace {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    
    if (totalFreeSpace < FILE_MAX_SIZE) {
        return YES;
    }
    else
        return NO;
}

@end
