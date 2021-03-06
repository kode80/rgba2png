//
//  KDEImage.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImage.h"
#import <Cocoa/Cocoa.h>
#import "KDEImage+Private.h"


KDEImagePixel KDEImagePixelMake( uint8_t red, uint8_t green, uint8_t blue, uint8_t alpha)
{
    return (KDEImagePixel){ red, green, blue, alpha};
}

NSString *NSStringFromKDEImagePixel( KDEImagePixel pixel)
{
    return [NSString stringWithFormat:@"{ r:%d, g:%d, b:%d, a:%d", pixel.red, pixel.green, pixel.blue, pixel.alpha];
}


@interface KDEImage ()

@property (nonatomic, readwrite, strong) NSBitmapImageRep *imageRep;

@end


@implementation KDEImage

@dynamic pixelWidth, pixelHeight;

#pragma mark - Initializers

- (instancetype) initWithWidth:(int)width
                        height:(int)height
                         color:(KDEImagePixel)color
{
    self = [super init];
    if( self)
    {
        self.imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                pixelsWide:width
                                                                pixelsHigh:height
                                                             bitsPerSample:8
                                                           samplesPerPixel:4
                                                                  hasAlpha:YES
                                                                  isPlanar:NO
                                                            colorSpaceName:NSDeviceRGBColorSpace
                                                              bitmapFormat:NSAlphaNonpremultipliedBitmapFormat
                                                               bytesPerRow:width * 4
                                                              bitsPerPixel:32];
        [self clearToColor:color];
    }
    return self;
}

- (instancetype) initWithContentsOfFile:(NSString *)path
{
    return [self initWithNSImage:[[NSImage alloc] initWithContentsOfFile:path]];
}

- (instancetype) initWithNSImage:(NSImage *)image
{
    if( image == nil || image.representations.count == 0) { return nil; }
    
    self = [super init];
    if( self)
    {
        NSImageRep *inputImageRep = image.representations[0];
        
        self.imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                pixelsWide:inputImageRep.pixelsWide
                                                                pixelsHigh:inputImageRep.pixelsHigh
                                                             bitsPerSample:8
                                                           samplesPerPixel:4
                                                                  hasAlpha:YES
                                                                  isPlanar:NO
                                                            colorSpaceName:NSDeviceRGBColorSpace
                                                               bytesPerRow:inputImageRep.pixelsWide * 4
                                                              bitsPerPixel:32];
        
        NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:self.imageRep];
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:context];
        [image drawAtPoint:NSZeroPoint
                  fromRect:NSZeroRect
                 operation:NSCompositeCopy
                  fraction:1.0f];
        [context flushGraphics];
        [NSGraphicsContext restoreGraphicsState];
    }
    return self;
}

#pragma mark - Accessors

- (int) pixelWidth
{
    return (int)self.imageRep.pixelsWide;
}

- (int) pixelHeight
{
    return (int)self.imageRep.pixelsHigh;
}

#pragma mark - Public

- (void) savePNGToPath:(NSString *)path
{
    NSData *pngData = [self.imageRep representationUsingType:NSPNGFileType
                                                  properties:nil];
    [pngData writeToFile:path
              atomically:YES];
}

- (void) clearToColor:(KDEImagePixel)color
{
    KDEImagePixel *pixel = (KDEImagePixel *)self.imageRep.bitmapData;
    int count = self.pixelWidth * self.pixelHeight;
    for( int i=0; i<count; i++)
    {
        pixel->bits = color.bits;
        pixel++;
    }
}

- (void) convertToLuminosity
{
    KDEImagePixel *pixel = (KDEImagePixel *)self.imageRep.bitmapData;
    int count = (int)self.imageRep.pixelsWide * (int)self.imageRep.pixelsHigh;
    int luminosity;
    
    for( int i=0; i<count; i++)
    {
        luminosity = (pixel->red * 0.21f) + (pixel->green * 0.72f) + (pixel->blue * 0.07f);
        luminosity = luminosity > 255 ? 255 : luminosity;
        
        pixel->red = luminosity;
        pixel->green = luminosity;
        pixel->blue = luminosity;
        
        pixel++;
    }
}

- (BOOL) dimensionsAreEqualWith:(KDEImage *)image
{
    return self.pixelWidth == image.pixelWidth && self.pixelHeight == image.pixelHeight;
}

- (BOOL) isEqualToImage:(KDEImage *)image
{
    if( [self dimensionsAreEqualWith:image] == NO) { return NO; }
    if( self == image) { return YES; }
    
    KDEImagePixel *pixel = (KDEImagePixel *)self.imageRep.bitmapData;
    KDEImagePixel *imagePixel = (KDEImagePixel *)image.imageRep.bitmapData;
    int count = (int)self.imageRep.pixelsWide * (int)self.imageRep.pixelsHigh;
    
    for( int i=0; i<count; i++)
    {
        if( pixel->bits != imagePixel->bits)
        {
            return NO;
        }
        
        pixel++;
        imagePixel++;
    }
    
    return YES;
}

- (void) copyChannel:(KDEImageChannel)sourceChannel
           fromImage:(KDEImage *)source
           toChannel:(KDEImageChannel)destinationChannel
{
    if( [self dimensionsAreEqualWith:source] == NO) { return; }
    
    KDEImagePixel *sourcePixel = (KDEImagePixel *)source.imageRep.bitmapData;
    KDEImagePixel *destinationPixel = (KDEImagePixel *)self.imageRep.bitmapData;
    
    int count = self.pixelWidth * self.pixelHeight;
    int sourceBitShift = [KDEImage bitShiftForChannel:sourceChannel];
    int destinationBitShift = [KDEImage bitShiftForChannel:destinationChannel];
    uint32_t destinationBitMask = ~[KDEImage bitMaskForChannel:destinationChannel];
    uint32_t sourceValue;
    
    for( int i=0; i<count; i++)
    {
        sourceValue = (sourcePixel->bits >> sourceBitShift) & 0x000000ff;
        destinationPixel->bits = (destinationPixel->bits & destinationBitMask) | (sourceValue << destinationBitShift);
        
        sourcePixel++;
        destinationPixel++;
    }
}

#pragma mark - Private

+ (int) bitShiftForChannel:(KDEImageChannel)channel
{
    switch( channel)
    {
        case KDEImageChannelRed:   return 0;
        case KDEImageChannelGreen: return 8;
        case KDEImageChannelBlue:  return 16;
        case KDEImageChannelAlpha: return 24;
    }
}

+ (uint32_t) bitMaskForChannel:(KDEImageChannel)channel
{
    switch( channel)
    {
        case KDEImageChannelRed:   return 0x000000ff;
        case KDEImageChannelGreen: return 0x0000ff00;
        case KDEImageChannelBlue:  return 0x00ff0000;
        case KDEImageChannelAlpha: return 0xff000000;
    }
}

@end
