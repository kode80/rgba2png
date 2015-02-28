//
//  KDEImage.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct KDEImagePixel
{
    uint8_t red;
    uint8_t green;
    uint8_t blue;
    uint8_t alpha;
} KDEImagePixel;

typedef NS_ENUM( NSUInteger, KDEImageChannel)
{
    KDEImageChannelRed   = 1 << 1,
    KDEImageChannelGreen = 1 << 2,
    KDEImageChannelBlue  = 1 << 3,
    KDEImageChannelAlpha = 1 << 4
};

@interface KDEImage : NSObject

@property (nonatomic, readonly, assign) int pixelWidth;
@property (nonatomic, readonly, assign) int pixelHeight;

- (instancetype) initWithContentsOfFile:(NSString *)path;
- (instancetype) initWithNSImage:(NSImage *)image;

- (void) savePNGToPath:(NSString *)path;

- (void) convertToLuminosity;

- (BOOL) dimensionsAreEqualWith:(KDEImage *)image;
- (BOOL) isEqualToImage:(KDEImage *)image;

- (void) copyChannel:(KDEImageChannel)sourceChannel
           fromImage:(KDEImage *)source
           toChannel:(KDEImageChannel)destinationChannel;

@end
