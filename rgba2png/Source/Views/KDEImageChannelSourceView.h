//
//  KDEImageChannelSourceView.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDEImageChannelSourceView : NSView

@property (nonatomic, readwrite, weak) IBOutlet NSTextField *channelAlias;
@property (nonatomic, readwrite, weak) IBOutlet NSImageView *sourceImage;
@property (nonatomic, readwrite, weak) IBOutlet NSMatrix *sourceChannel;
@property (nonatomic, readwrite, weak) IBOutlet NSSlider *clearValue;
@property (nonatomic, readwrite, weak) IBOutlet NSBox *clearValueView;

- (IBAction) channelSourceClick:(id)sender;
- (IBAction) clearValueDidChange:(id)sender;

@end
