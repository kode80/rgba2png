//
//  KDEChannelSource.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageChannelSource.h"

NSString * const KDEImageChannelSourceDocumentKeyClearValue = @"ClearValue";
NSString * const KDEImageChannelSourceDocumentKeySourceImagePath = @"SourceImagePath";
NSString * const KDEImageChannelSourceDocumentKeySourceImageChannel = @"SourceImageChannel";

@implementation KDEImageChannelSource

- (void) readFromDocumentDictionary:(NSDictionary *)dictionary
{
    self.clearValue = [dictionary[ KDEImageChannelSourceDocumentKeyClearValue] integerValue];
    self.sourceImagePath = dictionary[ KDEImageChannelSourceDocumentKeySourceImagePath];
    self.sourceImageChannel = [dictionary[ KDEImageChannelSourceDocumentKeySourceImageChannel] integerValue];
}

- (NSDictionary *) writeDocumentDictionary
{
    NSMutableDictionary *doc = [NSMutableDictionary dictionary];
    doc[ KDEImageChannelSourceDocumentKeyClearValue] = @(self.clearValue);
    if( self.sourceImagePath)
    {
        doc[ KDEImageChannelSourceDocumentKeySourceImagePath] = self.sourceImagePath;
        doc[ KDEImageChannelSourceDocumentKeySourceImageChannel] = @(self.sourceImageChannel);
    }
    return [NSDictionary dictionaryWithDictionary:doc];
}

@end
