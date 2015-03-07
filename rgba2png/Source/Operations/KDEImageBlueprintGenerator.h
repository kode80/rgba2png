//
//  KDEImageBlueprintGenerator.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KDEImageBlueprint;

@interface KDEImageBlueprintGenerator : NSObject

- (void) addImageBlueprintToGenerationQueue:(KDEImageBlueprint *)blueprint;
- (void) removeImageBlueprintFromGenerationQueue:(KDEImageBlueprint *)blueprint;

@end
