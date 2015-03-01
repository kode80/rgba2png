//
//  KDEImageChannelSourceView.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageChannelSourceView.h"

@implementation KDEImageChannelSourceView

- (void) awakeFromNib
{
    self.sourceChannel.hidden = YES;
    self.sourceImage.hidden = YES;
    self.clearValueView.fillColor = [NSColor grayColor];
}

- (IBAction) clearValueDidChange:(id)sender
{
    self.clearValueView.fillColor = [NSColor colorWithWhite:self.clearValue.floatValue
                                                      alpha:1.0f];
}

@end
