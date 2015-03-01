//
//  Document.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "Document.h"

#import "KDEImageBlueprint.h"
#import "KDEDocumentWindowController.h"


NSString * const DocumentKeyImageBlueprints = @"ImageBlueprints";


@interface Document ()

@property (nonatomic, readwrite, copy) NSArray *imageBlueprints;

@end


@implementation Document

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.imageBlueprints = @[];
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (void) makeWindowControllers
{
    KDEDocumentWindowController *controller = [[KDEDocumentWindowController alloc] initWithWindowNibName:@"DocumentWindow"];
    [self addWindowController:controller];
}

- (void) addImageBlueprint:(KDEImageBlueprint *)blueprint
{
    if( [self.imageBlueprints containsObject:blueprint] == NO)
    {
        self.imageBlueprints = [self.imageBlueprints arrayByAddingObject:blueprint];
    }
}

- (void) removeImageBlueprintAtIndex:(NSInteger)index
{
    if( self.imageBlueprints.count && index < self.imageBlueprints.count)
    {
        NSMutableArray *blueprints = [self.imageBlueprints mutableCopy];
        [blueprints removeObjectAtIndex:index];
        self.imageBlueprints = [NSArray arrayWithArray:blueprints];
    }
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    
    NSMutableDictionary *doc = [NSMutableDictionary dictionary];

    NSMutableArray *blueprintDictionaries = [NSMutableArray array];
    for( KDEImageBlueprint *blueprint in self.imageBlueprints)
    {
        [blueprintDictionaries addObject:[blueprint writeDocumentDictionary]];
    }
    doc[ DocumentKeyImageBlueprints] = blueprintDictionaries;
    
    return [NSPropertyListSerialization dataWithPropertyList:doc
                                                      format:NSPropertyListXMLFormat_v1_0
                                                     options:0
                                                       error:outError];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSDictionary *doc = [NSPropertyListSerialization propertyListWithData:data
                                                                  options:NSPropertyListImmutable
                                                                   format:NULL
                                                                    error:outError];
    
    if( *outError)
    {
        return NO;
    }
    
    NSMutableArray *blueprints = [NSMutableArray array];
    KDEImageBlueprint *blueprint;
    for( NSDictionary *blueprintDictionary in doc[ DocumentKeyImageBlueprints])
    {
        blueprint = [KDEImageBlueprint new];
        [blueprint readFromDocumentDictionary:blueprintDictionary];
        [blueprints addObject:blueprint];
    }
    self.imageBlueprints = [NSArray arrayWithArray:blueprints];
    
    return YES;
}

@end
