//
//  KDEImageChannelSourceMenuItem.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/2/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageChannelSourceMenuItem.h"

@implementation KDEImageChannelSourceMenuItem

+ (instancetype) menuItemWithTargetChannelSourceView:(KDEImageChannelSourceView *)channelSourceView
                                           imagePath:(NSString *)imagePath
                                              action:(SEL)action
{
    KDEImageChannelSourceMenuItem *item = [[super alloc] initWithTitle:imagePath.lastPathComponent
                                                                     action:action
                                                              keyEquivalent:@""];
    item.image = [KDEImageChannelSourceMenuItem menuImageWithContentsOfFile:imagePath];
    item.targetChannelSourceView = channelSourceView;
    item.channelSourceImagePath = imagePath;
    
    return item;
}

+ (NSImage *) menuImageWithContentsOfFile:(NSString *)path
{
    NSImage *original = [[NSImage alloc] initWithContentsOfFile:path];
    NSSize size = NSMakeSize( 64, 64);
    NSImage *menuImage = [[NSImage alloc] initWithSize:size];
    [menuImage lockFocus];
    [original drawInRect:NSMakeRect( 0.0f, 0.0f, size.width, size.height)];
    [menuImage unlockFocus];
    
    return menuImage;
}

@end
