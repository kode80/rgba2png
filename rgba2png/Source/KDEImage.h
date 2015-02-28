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

@interface KDEImage : NSObject

@property (nonatomic, readonly, assign) int pixelWidth;
@property (nonatomic, readonly, assign) int pixelHeight;

- (instancetype) initWithContentsOfFile:(NSString *)path;
- (instancetype) initWithNSImage:(NSImage *)image;

- (void) savePNGToPath:(NSString *)path;

- (void) convertToLuminosity;

@end
