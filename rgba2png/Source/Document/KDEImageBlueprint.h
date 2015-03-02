//
//  KDEImageBluePrint.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDEImageChannelSource.h"

@interface KDEImageBlueprint : NSObject

@property (nonatomic, readwrite, copy) NSString *outputPath;
@property (nonatomic, readonly, strong) KDEImageChannelSource *redChannel;
@property (nonatomic, readonly, strong) KDEImageChannelSource *greenChannel;
@property (nonatomic, readonly, strong) KDEImageChannelSource *blueChannel;
@property (nonatomic, readonly, strong) KDEImageChannelSource *alphaChannel;

- (NSArray *) allChannelSourceImagePaths;

- (void) readFromDocumentDictionary:(NSDictionary *)dictionary;
- (NSDictionary *) writeDocumentDictionary;

@end
