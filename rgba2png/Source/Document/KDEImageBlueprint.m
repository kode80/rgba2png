//
//  KDEImageBluePrint.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageBlueprint.h"


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
        self.redChannel = [KDEImageChannelSource new];
        self.greenChannel = [KDEImageChannelSource new];
        self.blueChannel = [KDEImageChannelSource new];
        self.alphaChannel = [KDEImageChannelSource new];
        self.channels = @[ self.redChannel, self.greenChannel, self.blueChannel, self.alphaChannel];
    }
    return self;
}

- (void) readFromDocumentDictionary:(NSDictionary *)dictionary
{
    [self.redChannel readFromDocumentDictionary:dictionary[ KDEImageBluePrintKeyRedChannel]];
    [self.greenChannel readFromDocumentDictionary:dictionary[ KDEImageBluePrintKeyGreenChannel]];
    [self.blueChannel readFromDocumentDictionary:dictionary[ KDEImageBluePrintKeyBlueChannel]];
    [self.alphaChannel readFromDocumentDictionary:dictionary[ KDEImageBluePrintKeyAlphaChannel]];
}

- (NSDictionary *) writeDocumentDictionary
{
    NSMutableDictionary *doc = [NSMutableDictionary dictionary];
    
    doc[ KDEImageBluePrintKeyRedChannel] = [self.redChannel writeDocumentDictionary];
    doc[ KDEImageBluePrintKeyGreenChannel] = [self.greenChannel writeDocumentDictionary];
    doc[ KDEImageBluePrintKeyBlueChannel] = [self.blueChannel writeDocumentDictionary];
    doc[ KDEImageBluePrintKeyAlphaChannel] = [self.alphaChannel writeDocumentDictionary];
    
    return [NSDictionary dictionaryWithDictionary:doc];
}

@end
