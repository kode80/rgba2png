//
//  KDEImageChannelSourceMenuItem.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/2/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class KDEImageChannelSourceView;

@interface KDEImageChannelSourceMenuItem : NSMenuItem

@property (nonatomic, readwrite, weak) KDEImageChannelSourceView *targetChannelSourceView;
@property (nonatomic, readwrite, copy) NSString *channelSourceImagePath;

+ (instancetype) menuItemWithTargetChannelSourceView:(KDEImageChannelSourceView *)channelSourceView
                                           imagePath:(NSString *)imagePath
                                              action:(SEL)action;

@end
