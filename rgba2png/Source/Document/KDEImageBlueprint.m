//
//  KDEImageBluePrint.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageBlueprint.h"


NSString * const KDEImageBluePrintKeyOutputPath = @"OutputPath";
NSString * const KDEImageBluePrintKeyRedChannel = @"RedChannel";
NSString * const KDEImageBluePrintKeyGreenChannel = @"GreenChannel";
NSString * const KDEImageBluePrintKeyBlueChannel = @"BlueChannel";
NSString * const KDEImageBluePrintKeyAlphaChannel = @"AlphaChannel";


@interface KDEImageBlueprint ()

@property (nonatomic, readwrite, strong) KDEImageChannelSource *redChannel;
@property (nonatomic, readwrite, strong) KDEImageChannelSource *greenChannel;
@property (nonatomic, readwrite, strong) KDEImageChannelSource *blueChannel;
@property (nonatomic, readwrite, strong) KDEImageChannelSource *alphaChannel;
@property (nonatomic, readwrite, copy) NSArray *channels;

@end


@implementation KDEImageBlueprint

- (instancetype) init
{
    self = [super init];
    if( self)
    {
        self.redChannel = [KDEImageChannelSource imageChannelSourceForBlueprint:self];
        self.greenChannel = [KDEImageChannelSource imageChannelSourceForBlueprint:self];
        self.blueChannel = [KDEImageChannelSource imageChannelSourceForBlueprint:self];
        self.alphaChannel = [KDEImageChannelSource imageChannelSourceForBlueprint:self];
        self.channels = @[ self.redChannel, self.greenChannel, self.blueChannel, self.alphaChannel];
    }
    return self;
}

- (NSArray *) allChannelSourceImagePaths
{
    NSMutableSet *paths = [NSMutableSet set];
    
    for( KDEImageChannelSource *channel in self.channels)
    {
        if( channel.sourceImagePath.length)
        {
            [paths addObject:channel.sourceImagePath];
        }
    }
    
    return [paths allObjects];
}

- (KDEImagePixel) blueprintImagePixel
{
    return KDEImagePixelMake( self.redChannel.clearValue,
                              self.greenChannel.clearValue,
                              self.blueChannel.clearValue,
                              self.alphaChannel.clearValue);
}

- (void) exportPNGWithCompletionHandler:(void (^)(BOOL success))handler
{
    NSMutableArray *images = [NSMutableArray array];
    NSMapTable *imageToChannelSource = [NSMapTable weakToWeakObjectsMapTable];
    KDEImage *image;
    KDEImageChannelSource *channelSource;
    
    for( channelSource in self.channels)
    {
        if( channelSource.sourceImagePath.length)
        {
            image = [[KDEImage alloc] initWithContentsOfFile:channelSource.sourceImagePath];
            [images addObject:image];
            [imageToChannelSource setObject:channelSource
                                     forKey:image];
        }
    }
    
    NSSize size = NSMakeSize( 64.0f, 64.0f);
    if( images.count)
    {
        image = images.firstObject;
        NSSize imageSize = NSMakeSize( image.pixelWidth, image.pixelHeight);
        for( image in images)
        {
            if( image.pixelWidth != imageSize.width || image.pixelHeight != imageSize.height)
            {
                if( handler) { handler( NO); }
                return;
            }
        }
        size = imageSize;
    }
    
    KDEImage *exportedImage = [[KDEImage alloc] initWithWidth:size.width
                                                       height:size.height
                                                        color:[self blueprintImagePixel]];

    for( image in images)
    {
        channelSource = [imageToChannelSource objectForKey:image];
        [exportedImage copyChannel:channelSource.sourceImageChannel
                         fromImage:image
                         toChannel:[self imageChannelForChannelSource:channelSource]];
    }
    
    [exportedImage savePNGToPath:self.outputPath];
    
    if( handler) { handler( YES); }
}

- (KDEImageChannel) imageChannelForChannelSource:(KDEImageChannelSource *)source
{
    if( source == self.redChannel) { return KDEImageChannelRed; }
    else if( source == self.greenChannel) { return KDEImageChannelGreen;}
    else if( source == self.blueChannel) { return KDEImageChannelBlue;}
    
    return KDEImageChannelAlpha;
}

- (void) readFromDocumentDictionary:(NSDictionary *)dictionary
{
    self.outputPath = dictionary[ KDEImageBluePrintKeyOutputPath];
    [self.redChannel readFromDocumentDictionary:dictionary[ KDEImageBluePrintKeyRedChannel]];
    [self.greenChannel readFromDocumentDictionary:dictionary[ KDEImageBluePrintKeyGreenChannel]];
    [self.blueChannel readFromDocumentDictionary:dictionary[ KDEImageBluePrintKeyBlueChannel]];
    [self.alphaChannel readFromDocumentDictionary:dictionary[ KDEImageBluePrintKeyAlphaChannel]];
}

- (NSDictionary *) writeDocumentDictionary
{
    NSMutableDictionary *doc = [NSMutableDictionary dictionary];
    
    if( self.outputPath)
    {
        doc[ KDEImageBluePrintKeyOutputPath] = self.outputPath;
    }
    
    doc[ KDEImageBluePrintKeyRedChannel] = [self.redChannel writeDocumentDictionary];
    doc[ KDEImageBluePrintKeyGreenChannel] = [self.greenChannel writeDocumentDictionary];
    doc[ KDEImageBluePrintKeyBlueChannel] = [self.blueChannel writeDocumentDictionary];
    doc[ KDEImageBluePrintKeyAlphaChannel] = [self.alphaChannel writeDocumentDictionary];
    
    return [NSDictionary dictionaryWithDictionary:doc];
}

@end
