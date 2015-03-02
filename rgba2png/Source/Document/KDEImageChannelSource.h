//
//  KDEChannelSource.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDEImage.h"


@class KDEImageBlueprint;

@interface KDEImageChannelSource : NSObject

@property (nonatomic, readonly, weak) KDEImageBlueprint *blueprint;
@property (nonatomic, readwrite, assign) uint8_t clearValue;
@property (nonatomic, readwrite, copy) NSString *sourceImagePath;
@property (nonatomic, readwrite, assign) KDEImageChannel sourceImageChannel;

+ (instancetype) imageChannelSourceForBlueprint:(KDEImageBlueprint *)blueprint;

- (void) readFromDocumentDictionary:(NSDictionary *)dictionary;
- (NSDictionary *) writeDocumentDictionary;

@end
