//
//  KDEImageChannelSourceView.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageChannelSourceView.h"


@interface KDEImageChannelSourceView ()

@property (nonatomic, readwrite, strong) NSMenu *menu;

@end


@implementation KDEImageChannelSourceView

- (void) awakeFromNib
{
    self.sourceChannel.hidden = YES;
    self.sourceImage.hidden = YES;
    self.clearValueView.fillColor = [NSColor grayColor];
}

- (IBAction) channelSourceClick:(id)sender
{
    NSMenu *menu = [NSMenu new];
    
    [menu addItemWithTitle:@"Pick image"
                    action:nil
             keyEquivalent:@""];
    
    [menu addItemWithTitle:@"-"
                    action:nil
             keyEquivalent:@""];
    
    [menu addItemWithTitle:@"Clear"
                    action:nil
             keyEquivalent:@""];
    
    NSView *targetView = sender;
    NSPoint result = [targetView convertPoint:NSMakePoint(NSMinX(targetView.bounds), NSMaxY(targetView.bounds))
                                       toView:nil];
    NSEvent *event = [NSApplication sharedApplication].currentEvent;
    
    NSEvent *newEvent = [NSEvent mouseEventWithType: [event type]
                                           location: result
                                      modifierFlags: [event modifierFlags]
                                          timestamp: [event timestamp]
                                       windowNumber: [event windowNumber]
                                            context: [event context]
                                        eventNumber: [event eventNumber]
                                         clickCount: [event clickCount]
                                           pressure: [event pressure]];
    
    // need to generate a new event otherwise selection of button
    // after menu display fails
    [NSMenu popUpContextMenu:menu
                   withEvent:newEvent
                     forView:targetView];

}

- (IBAction) clearValueDidChange:(id)sender
{
    self.clearValueView.fillColor = [NSColor colorWithWhite:self.clearValue.floatValue
                                                      alpha:1.0f];
}

@end
