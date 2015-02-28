//
//  KDEImage+Private.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

@interface KDEImage (Private)

@property (nonatomic, readwrite, strong) NSBitmapImageRep *imageRep;

+ (int) bitShiftForChannel:(KDEImageChannel)channel;
+ (uint32_t) bitMaskForChannel:(KDEImageChannel)channel;

@end
