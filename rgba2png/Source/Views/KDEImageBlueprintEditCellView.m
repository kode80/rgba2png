//
//  KDEImageBlueprintEditCellView.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageBlueprintEditCellView.h"
#import "KDEImageChannelSourceView.h"



@implementation KDEImageBlueprintEditCellView

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.redChannel = [self imageChannelSourceViewWithAlias:@"Red"];
    [self addImageChannelSourceView:self.redChannel
                        toContainer:self.redChannelContainer];
    
    self.greenChannel = [self imageChannelSourceViewWithAlias:@"Green"];
    [self addImageChannelSourceView:self.greenChannel
                        toContainer:self.greenChannelContainer];
    
    self.blueChannel = [self imageChannelSourceViewWithAlias:@"Blue"];
    [self addImageChannelSourceView:self.blueChannel
                        toContainer:self.blueChannelContainer];
    
    self.alphaChannel = [self imageChannelSourceViewWithAlias:@"Alpha"];
    [self addImageChannelSourceView:self.alphaChannel
                        toContainer:self.alphaChannelContainer];
}

- (KDEImageChannelSourceView *) imageChannelSourceViewWithAlias:(NSString *)alias
{
    KDEImageChannelSourceView *view = nil;
    NSArray *topLevelObjects;
    
    if( [[NSBundle mainBundle] loadNibNamed:@"KDEImageChannelSourceView"
                                      owner:nil
                            topLevelObjects:&topLevelObjects])
    {
        for( NSObject *object in topLevelObjects)
        {
            view = [object isKindOfClass:[KDEImageChannelSourceView class]] ? (KDEImageChannelSourceView *)object : view;
        }
        
        view.channelAlias.stringValue = alias;
    }
    
    return view;
}

- (void) addImageChannelSourceView:(KDEImageChannelSourceView *)imageChannelSource
                       toContainer:(NSView *)container
{
    imageChannelSource.frame = container.bounds;
    [container addSubview:imageChannelSource];
}

@end
