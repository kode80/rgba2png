//
//  Document.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class KDEImageBlueprint;

@interface Document : NSDocument

@property (nonatomic, readonly, copy) NSArray *imageBlueprints;

- (void) addImageBlueprint:(KDEImageBlueprint *)blueprint;
- (void) removeImageBlueprintAtIndex:(NSInteger)index;

@end

