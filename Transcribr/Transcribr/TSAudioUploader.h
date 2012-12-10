//
//  TSAudioUploader.h
//  Transcribr
//
//  Created by Herbert Yeung on 10/12/12.
//  Copyright (c) 2012 becontactable. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHUNK_SIZE 1000 // 1Mb chunks?!?

@interface TSAudioUploader : NSObject

@property (nonatomic, assign) int chunkIndex;

-(BOOL) checkWifiConnectivity;
-(BOOL) uploadFile;

@end
