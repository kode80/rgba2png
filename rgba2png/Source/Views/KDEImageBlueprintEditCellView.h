//
//  KDEImageBlueprintEditCellView.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class KDEImageChannelSourceView;

@interface KDEImageBlueprintEditCellView : NSTableCellView

@property (nonatomic, readwrite, weak) IBOutlet NSTextField *outputFilename;
@property (nonatomic, readwrite, weak) IBOutlet NSTextField *outputFullPath;

@property (nonatomic, readwrite, weak) IBOutlet KDEImageChannelSourceView *redChannel;
@property (nonatomic, readwrite, weak) IBOutlet KDEImageChannelSourceView *greenChannel;
@property (nonatomic, readwrite, weak) IBOutlet KDEImageChannelSourceView *blueChannel;
@property (nonatomic, readwrite, weak) IBOutlet KDEImageChannelSourceView *alphaChannel;

@property (nonatomic, readwrite, weak) IBOutlet NSView *redChannelContainer;
@property (nonatomic, readwrite, weak) IBOutlet NSView *greenChannelContainer;
@property (nonatomic, readwrite, weak) IBOutlet NSView *blueChannelContainer;
@property (nonatomic, readwrite, weak) IBOutlet NSView *alphaChannelContainer;

@end
