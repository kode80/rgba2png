//
//  KDEDocumentWindowController.h
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDEDocumentWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, readwrite, weak) IBOutlet NSToolbar *toolbar;
@property (nonatomic, readwrite, weak) IBOutlet NSTableView *tableView;

- (IBAction) addImageBlueprint:(id)sender;
- (IBAction) removeSelectedImageBlueprint:(id)sender;

- (IBAction) pickImageBlueprintOutputPath:(id)sender;

@end
