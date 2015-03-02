//
//  KDEImageChannelSourceView.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KDEImage.h"


@class KDEImageChannelSource;
@protocol KDEImageChannelSourceViewDelegate;


@interface KDEImageChannelSourceView : NSView

@property (nonatomic, readwrite, weak) IBOutlet NSButton *changeButton;
@property (nonatomic, readwrite, weak) IBOutlet NSTextField *channelAlias;
@property (nonatomic, readwrite, weak) IBOutlet NSImageView *sourceImage;
@property (nonatomic, readwrite, weak) IBOutlet NSMatrix *sourceChannel;
@property (nonatomic, readwrite, weak) IBOutlet NSSlider *clearValue;
@property (nonatomic, readwrite, weak) IBOutlet NSBox *clearValueView;

@property (nonatomic, readwrite, weak) id<KDEImageChannelSourceViewDelegate> delegate;

- (IBAction) channelSourceClick:(id)sender;
- (IBAction) clearValueDidChange:(id)sender;
- (IBAction) sourceChannelDidChange:(id)sender;

- (void) showSourceImage;
- (void) showClearValue;

- (void) displayImageChannelSource:(KDEImageChannelSource *)channelSource;

@end


@protocol KDEImageChannelSourceViewDelegate <NSObject>

- (void) imageChannelSourceViewDidReceiveClick:(KDEImageChannelSourceView *)channelSourceView;

- (void) imageChannelSourceView:(KDEImageChannelSourceView *)channelSourceView
         didChangeSourceChannel:(KDEImageChannel)newChannel;

- (void) imageChannelSourceView:(KDEImageChannelSourceView *)channelSourceView
            didChangeClearValue:(uint8_t)newClearValue;

@end