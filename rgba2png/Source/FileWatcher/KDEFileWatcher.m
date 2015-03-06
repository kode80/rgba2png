//
//  KDEFileWatcher.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/6/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEFileWatcher.h"


void KDEFileWatcherEventStreamCallback( ConstFSEventStreamRef streamRef,
                                        void *clientCallBackInfo,
                                        size_t numEvents,
                                        void *eventPaths,
                                        const FSEventStreamEventFlags eventFlags[],
                                        const FSEventStreamEventId eventIds[])
{
    
}


@implementation KDEFileWatcher

- (void) watchFileAtPath:(NSString *)path
{
    
}

- (void) stopWatchingFileAtPAth:(NSString *)path
{
    
}

@end
