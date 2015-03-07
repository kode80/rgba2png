//
//  KDEFileWatcher.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/6/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEFileWatcher.h"


@interface KDEFileWatcher ()

@property (nonatomic, readwrite, copy) NSDictionary *watchedFolderToWatchedFileNames;
@property (nonatomic, readwrite, assign) FSEventStreamRef eventStream;

@end


void KDEFileWatcherEventStreamCallback( ConstFSEventStreamRef streamRef,
                                        void *clientCallBackInfo,
                                        size_t numEvents,
                                        void *eventPaths,
                                        const FSEventStreamEventFlags eventFlags[],
                                        const FSEventStreamEventId eventIds[])
{
    KDEFileWatcher *watcher = (__bridge KDEFileWatcher *)clientCallBackInfo;
    NSArray *paths = (__bridge NSArray *)((CFArrayRef)eventPaths);
    NSString *path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for( int i=0; i<numEvents; i++)
    {
        path = paths[ i];
        
        // FSEvents require overly complex tracking for basic file watching. A simple file
        // modify will send remove + rename + modified flags. Any file that is removed
        // via the finder will in fact send a rename flag and it is up to the application
        // to also track files added to the trash's path and then compare event IDs etc.
        // Since we only care about file changes and files that no longer exist at the
        // original path (either due to deletion or renaming), we can simply see if the
        // file exists at the path, if it does we assume it was modified otherwise deleted.
        if( [fileManager fileExistsAtPath:path])
        {
            if( [watcher.delegate respondsToSelector:@selector(fileWatcher:fileWasModifiedAtPath:)])
            {
                [watcher.delegate fileWatcher:watcher
                        fileWasModifiedAtPath:path];
            }
        }
        else
        {
            if( [watcher.delegate respondsToSelector:@selector(fileWatcher:fileNoLongerExistsAtPath:)])
            {
                [watcher.delegate fileWatcher:watcher
                     fileNoLongerExistsAtPath:path];
            }
        }
    }
}


@implementation KDEFileWatcher

- (void) dealloc
{
    [self invalidateEventStream];
}

- (instancetype) init
{
    self = [super init];
    if( self)
    {
        self.watchedFolderToWatchedFileNames = @{};
        self.eventStream = NULL;
    }
    return self;
}

- (void) watchFileAtPath:(NSString *)path
{
    if( [self fileIsNotDirectoryAndExistsAtPath:path])
    {
        NSString *folder = [path stringByDeletingLastPathComponent];
        NSString *file = [path lastPathComponent];
        NSArray *files = self.watchedFolderToWatchedFileNames[ folder];
        
        if( [files containsObject:file] == NO)
        {
            files = files ? [files arrayByAddingObject:file] : @[ file];
            
            NSMutableDictionary *mutableWatchDictionary = [self.watchedFolderToWatchedFileNames mutableCopy];
            mutableWatchDictionary[ folder] = files;
            self.watchedFolderToWatchedFileNames = [NSDictionary dictionaryWithDictionary:mutableWatchDictionary];
            
            [self refreshEventStream];
        }
    }
}

- (void) stopWatchingFileAtPath:(NSString *)path
{
    if( [self isWatchingFileAtPath:path])
    {
        NSString *folder = [path stringByDeletingLastPathComponent];
        NSString *file = [path lastPathComponent];
        NSArray *files = self.watchedFolderToWatchedFileNames[ folder];
        NSMutableDictionary *mutableWatchDictionary = [self.watchedFolderToWatchedFileNames mutableCopy];
        
        if( files.count > 1)
        {
            NSMutableArray *mutableFiles = [files mutableCopy];
            [mutableFiles removeObject:file];
            mutableWatchDictionary[ folder] = [NSArray arrayWithArray:mutableFiles];
        }
        else
        {
            [mutableWatchDictionary removeObjectForKey:folder];
        }
        
        self.watchedFolderToWatchedFileNames = [NSDictionary dictionaryWithDictionary:mutableWatchDictionary];
        
        [self refreshEventStream];
    }
}

- (BOOL) isWatchingFileAtPath:(NSString *)path
{
    if( [self fileIsNotDirectoryAndExistsAtPath:path])
    {
        NSString *folder = [path stringByDeletingLastPathComponent];
        NSString *file = [path lastPathComponent];
        NSArray *files = self.watchedFolderToWatchedFileNames[ folder];
        return [files containsObject:file];
    }
    
    return NO;
}

#pragma mark - Private

- (NSArray *) allWatchedPaths
{
    NSMutableArray *paths = [NSMutableArray array];
    
    for( NSString *folder in self.watchedFolderToWatchedFileNames.allKeys)
    {
        for( NSString *file in self.watchedFolderToWatchedFileNames[ folder])
        {
            [paths addObject:[folder stringByAppendingPathComponent:file]];
        }
    }
    
    return [NSArray arrayWithArray:paths];
}

- (BOOL) fileIsNotDirectoryAndExistsAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    
    return [manager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory == NO;
}

- (void) invalidateEventStream
{
    if( self.eventStream == NULL) { return; }
    
    FSEventStreamStop( self.eventStream);
    FSEventStreamInvalidate( self.eventStream);
    FSEventStreamRelease( self.eventStream);
    
    self.eventStream = NULL;
}

- (void) refreshEventStream
{
    [self invalidateEventStream];
    
    if( self.watchedFolderToWatchedFileNames.count == 0) { return; }
    
    FSEventStreamContext context;
    context.version = 0;
    context.info = (__bridge void *)(self);
    context.retain = NULL;
    context.release = NULL;
    context.copyDescription = NULL;
    
    CFArrayRef pathsToWatch = (__bridge CFArrayRef)[self allWatchedPaths];
    CFTimeInterval latency = 0.1;
    self.eventStream = FSEventStreamCreate( NULL,
                                            KDEFileWatcherEventStreamCallback,
                                            &context,
                                            pathsToWatch,
                                            kFSEventStreamEventIdSinceNow,
                                            latency,
                                            kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagUseCFTypes);
    
    if( self.eventStream)
    {
        FSEventStreamScheduleWithRunLoop( self.eventStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        FSEventStreamStart( self.eventStream);
    }
}

@end
