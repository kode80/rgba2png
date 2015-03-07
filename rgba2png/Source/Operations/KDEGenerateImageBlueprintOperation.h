//
//  KDEGenerateImageBlueprintOperation.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KDEImageBlueprint;

@interface KDEGenerateImageBlueprintOperation : NSOperation

@property (nonatomic, readwrite, strong) KDEImageBlueprint *blueprint;

@end
