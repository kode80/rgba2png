//
//  KDEImageBlueprintGenerator.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 3/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageBlueprintGenerator.h"
#import "KDEGenerateImageBlueprintOperation.h"
#import "KDEImageBlueprint.h"


@interface KDEImageBlueprintGenerator ()

@property (nonatomic, readwrite, strong) NSOperationQueue *operationQueue;

@end


@implementation KDEImageBlueprintGenerator

- (instancetype) init
{
    self = [super init];
    if( self)
    {
        self.operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void) addImageBlueprintToGenerationQueue:(KDEImageBlueprint *)blueprint
{
    if( [self isImageBlueprintQueuedForGeneration:blueprint] == NO)
    {
        // TODO: add blueprint generation operation
    }
}

- (void) removeImageBlueprintFromGenerationQueue:(KDEImageBlueprint *)blueprint
{
    KDEGenerateImageBlueprintOperation *operation = [self queuedOperationForImageBlueprint:blueprint];
    
    if( operation && operation.isExecuting == NO)
    {
        [operation cancel];
    }
}

- (KDEGenerateImageBlueprintOperation *) queuedOperationForImageBlueprint:(KDEImageBlueprint *)blueprint
{
    for( KDEGenerateImageBlueprintOperation *operation in self.operationQueue.operations)
    {
        if( operation.blueprint == blueprint)
        {
            return operation;
        }
    }
    
    return nil;
}

- (BOOL) isImageBlueprintQueuedForGeneration:(KDEImageBlueprint *)blueprint
{
    KDEGenerateImageBlueprintOperation *operation = [self queuedOperationForImageBlueprint:blueprint];
    return operation && operation.isExecuting == NO;
}

@end
