//
//  KDEImageChannelSourceView.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageChannelSourceView.h"
#import "KDEImageChannelSource.h"

@interface KDEImageChannelSourceView ()

@property (nonatomic, readwrite, strong) NSMenu *menu;

@end


@implementation KDEImageChannelSourceView

- (void) awakeFromNib
{
    [self showClearValue];
    self.clearValueView.fillColor = [NSColor grayColor];
}

- (IBAction) channelSourceClick:(id)sender
{
    if( [self.delegate respondsToSelector:@selector(imageChannelSourceViewDidReceiveClick:)])
    {
        [self.delegate imageChannelSourceViewDidReceiveClick:self];
    }
}

- (IBAction) clearValueDidChange:(id)sender
{
    self.clearValueView.fillColor = [NSColor colorWithWhite:self.clearValue.floatValue
                                                      alpha:1.0f];
    
    if( [self.delegate respondsToSelector:@selector(imageChannelSourceView:didChangeClearValue:)])
    {
        [self.delegate imageChannelSourceView:self
                          didChangeClearValue:self.clearValue.floatValue * 255];
    }
}

- (IBAction) sourceChannelDidChange:(id)sender
{
    if( [self.delegate respondsToSelector:@selector(imageChannelSourceView:didChangeSourceChannel:)])
    {
        KDEImageChannel channel = [self imageChannelForMatrixColumn:self.sourceChannel.selectedColumn];
        [self.delegate imageChannelSourceView:self
                       didChangeSourceChannel:channel];
    }
}

- (void) showSourceImage
{
    self.sourceChannel.hidden = NO;
    self.sourceImage.hidden = NO;
    self.clearValue.hidden = YES;
    self.clearValueView.hidden = YES;
}

- (void) showClearValue
{
    self.sourceChannel.hidden = YES;
    self.sourceImage.hidden = YES;
    self.clearValue.hidden = NO;
    self.clearValueView.hidden = NO;
}

- (void) displayImageChannelSource:(KDEImageChannelSource *)channelSource
{
    if( channelSource.sourceImagePath.length)
    {
        self.sourceImage.image = [[NSImage alloc] initWithContentsOfFile:channelSource.sourceImagePath];
        [self selectMatrixColumnForImageChannel:channelSource.sourceImageChannel];
        [self showSourceImage];
    }
    else
    {
        self.clearValueView.fillColor = [NSColor colorWithWhite:channelSource.clearValue / 255.0f
                                                          alpha:1.0f];
        self.clearValue.floatValue = channelSource.clearValue / 255.0f;
        [self showClearValue];
    }
}

- (KDEImageChannel) imageChannelForMatrixColumn:(NSInteger)column
{
    switch( column)
    {
        default:
        case 0: return KDEImageChannelRed;
        case 1: return KDEImageChannelGreen;
        case 2: return KDEImageChannelBlue;
        case 3: return KDEImageChannelAlpha;
    }
}

- (void) selectMatrixColumnForImageChannel:(KDEImageChannel)channel
{
    switch( channel)
    {
        case KDEImageChannelRed:   [self.sourceChannel selectCellAtRow:0 column:0]; break;
        case KDEImageChannelGreen: [self.sourceChannel selectCellAtRow:0 column:1]; break;
        case KDEImageChannelBlue:  [self.sourceChannel selectCellAtRow:0 column:2]; break;
        case KDEImageChannelAlpha: [self.sourceChannel selectCellAtRow:0 column:3]; break;
    }
}

@end
