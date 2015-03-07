//
//  KDEFileWatcher.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/6/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol KDEFileWatcherDelegate;

@interface KDEFileWatcher : NSObject

@property (nonatomic, readwrite, weak) id<KDEFileWatcherDelegate> delegate;

- (void) watchFileAtPath:(NSString *)path;
- (void) stopWatchingFileAtPath:(NSString *)path;
- (BOOL) isWatchingFileAtPath:(NSString *)path;

@end


@protocol KDEFileWatcherDelegate <NSObject>

- (void) fileWatcher:(KDEFileWatcher *)watcher fileNoLongerExistsAtPath:(NSString *)path;
- (void) fileWatcher:(KDEFileWatcher *)watcher fileWasModifiedAtPath:(NSString *)path;

@end
