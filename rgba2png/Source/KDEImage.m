//
//  KDEImage.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImage.h"
#import <Cocoa/Cocoa.h>

@interface KDEImage ()

@property (nonatomic, readwrite, strong) NSBitmapImageRep *imageRep;

@end


@implementation KDEImage

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
                                                            colorSpaceName:NSCalibratedRGBColorSpace
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

- (void) savePNGToPath:(NSString *)path
{
    NSData *pngData = [self.imageRep representationUsingType:NSPNGFileType
                                                  properties:nil];
    [pngData writeToFile:path
              atomically:YES];
}

@end
