//
//  KDEDocumentWindowController.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEDocumentWindowController.h"
#import "Document.h"
#import "KDEImageBlueprint.h"
#import "KDEImageBlueprintCellView.h"
#import "KDEImageBlueprintEditCellView.h"
#import "KDEImageChannelSourceView.h"
#import "KDEImageChannelSourceMenuItem.h"


@interface KDEDocumentWindowController () <KDEImageChannelSourceViewDelegate, NSToolbarDelegate>

@property (nonatomic, readwrite, assign) NSInteger previousSelectedRow;
@property (nonatomic, readwrite, strong) NSMapTable *imageChannelSourceViewToModel;

@end


@implementation KDEDocumentWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.previousSelectedRow = -1;
    self.window.titleVisibility = NSWindowTitleHidden;
}

- (IBAction) addImageBlueprint:(id)sender
{
    [self presentPNGSavePanelWithFilename:@"Untitled"
                        completionHandler:^(NSString *filePath) {
                            Document *document = (Document *)self.document;
                            KDEImageBlueprint *blueprint = [KDEImageBlueprint new];
                            blueprint.outputPath = filePath;
                            [document addImageBlueprint:blueprint];
                          
                            [self.tableView reloadData];
                      }];
}

- (IBAction) removeSelectedImageBlueprint:(id)sender
{
    if( self.tableView.selectedRow > -1)
    {
        Document *document = (Document *)self.document;
        [document removeImageBlueprintAtIndex:self.tableView.selectedRow];
        [self.tableView reloadData];
    }
}

- (IBAction) exportSelectedImageBlueprint:(id)sender
{
    
}

- (IBAction) pickImageBlueprintOutputPath:(id)sender
{
    [self presentPNGSavePanelWithFilename:@"Untitled"
                        completionHandler:^(NSString *filePath) {
                            NSView *parent = [(NSView *)sender superview];
                            NSInteger row = [self.tableView rowForView:parent];
                            Document *document = (Document *)self.document;
                            KDEImageBlueprint *blueprint = document.imageBlueprints[ row];
                            blueprint.outputPath = filePath;
                      
                            [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row]
                                                      columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                        }];
}

#pragma mark - Private

- (void) presentPNGSavePanelWithFilename:(NSString *)filename
                       completionHandler:(void (^)(NSString *filePath))handler
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = @[ @"png"];
    panel.nameFieldStringValue = [filename stringByAppendingPathExtension:@"png"];
    [panel beginSheetModalForWindow:self.window
                  completionHandler:^(NSInteger result){
                      if (result == NSFileHandlingPanelOKButton)
                      {
                          handler( panel.URL.filePathURL.path);
                      }
                  }];
}

- (void) presentImageOpenPanelWithInitialPath:(NSString *)initialPath
                            completionHandler:(void (^)(NSString *filePath))handler
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = @[ @"jpg", @"png"];
    panel.allowsMultipleSelection = NO;
    panel.canChooseDirectories = NO;

    [panel beginSheetModalForWindow:self.window
                  completionHandler:^(NSInteger result){
                      if (result == NSFileHandlingPanelOKButton)
                      {
                          handler( panel.URL.filePathURL.path);
                      }
                  }];
}

- (IBAction) pickSourceImage:(id)sender
{
    if( [sender isKindOfClass:[NSMenuItem class]])
    {
        NSMenuItem *menuItem = sender;
        KDEImageChannelSourceView *channelSourceView = menuItem.representedObject;
        KDEImageChannelSource *channelSource = [self.imageChannelSourceViewToModel objectForKey:channelSourceView];
        
        [self presentImageOpenPanelWithInitialPath:nil
                                 completionHandler:^(NSString *filePath){
                                     channelSource.sourceImagePath = filePath;
                                     [channelSourceView displayImageChannelSource:channelSource];
                                 }];
    }
}

- (IBAction) clearSourceImage:(id)sender
{
    if( [sender isKindOfClass:[NSMenuItem class]])
    {
        NSMenuItem *menuItem = sender;
        KDEImageChannelSourceView *channelSourceView = menuItem.representedObject;
        KDEImageChannelSource *channelSource = [self.imageChannelSourceViewToModel objectForKey:channelSourceView];
        
        channelSource.sourceImagePath = nil;
        [channelSourceView displayImageChannelSource:channelSource];
    }
}

- (IBAction) assignSourceImageFromMenuItem:(id)sender
{
    if( [sender isKindOfClass:[KDEImageChannelSourceMenuItem class]])
    {
        KDEImageChannelSourceMenuItem *item = sender;
        KDEImageChannelSource *channelSource = [self.imageChannelSourceViewToModel objectForKey:item.targetChannelSourceView];
        channelSource.sourceImagePath = item.channelSourceImagePath;
        [item.targetChannelSourceView displayImageChannelSource:channelSource];
    }
}

#pragma mark NSToolbarDelegate

- (BOOL) validateToolbarItem:(NSToolbarItem *)theItem
{
    if( (theItem == self.removeToolbarItem || theItem == self.exportToolbarItem) && self.tableView.selectedRow == -1)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    Document *document = (Document *)self.document;
    return document.imageBlueprints.count;
}

#pragma mark NSTableViewDelegate

- (CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return tableView.selectedRow == row ? 182.0f : 30.0f;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Document *document = (Document *)self.document;
    KDEImageBlueprint *blueprint = document.imageBlueprints[ row];
    
    if( tableView.selectedRow == row)
    {
        KDEImageBlueprintEditCellView *selectedCell = (KDEImageBlueprintEditCellView *)[tableView makeViewWithIdentifier:@"DetailCell"
                                                                                                                   owner:self];
        selectedCell.outputFilename.stringValue = blueprint.outputPath ? blueprint.outputPath.lastPathComponent : @"";
        selectedCell.outputFullPath.stringValue = blueprint.outputPath ? blueprint.outputPath : @"";
        
        [selectedCell.redChannel displayImageChannelSource:blueprint.redChannel];
        [selectedCell.greenChannel displayImageChannelSource:blueprint.greenChannel];
        [selectedCell.blueChannel displayImageChannelSource:blueprint.blueChannel];
        [selectedCell.alphaChannel displayImageChannelSource:blueprint.alphaChannel];
        
        self.imageChannelSourceViewToModel = [NSMapTable weakToWeakObjectsMapTable];
        [self.imageChannelSourceViewToModel setObject:blueprint.redChannel
                                               forKey:selectedCell.redChannel];
        [self.imageChannelSourceViewToModel setObject:blueprint.greenChannel
                                               forKey:selectedCell.greenChannel];
        [self.imageChannelSourceViewToModel setObject:blueprint.blueChannel
                                               forKey:selectedCell.blueChannel];
        [self.imageChannelSourceViewToModel setObject:blueprint.alphaChannel
                                               forKey:selectedCell.alphaChannel];
        
        selectedCell.redChannel.delegate = self;
        selectedCell.greenChannel.delegate = self;
        selectedCell.blueChannel.delegate = self;
        selectedCell.alphaChannel.delegate = self;
        
        return selectedCell;
    }
    
    KDEImageBlueprintCellView *cell = (KDEImageBlueprintCellView *)[tableView makeViewWithIdentifier:@"Cell"
                                                                                               owner:self];
    cell.outputFilename.stringValue = blueprint.outputPath ? blueprint.outputPath.lastPathComponent : @"";
    cell.outputFullPath.stringValue = blueprint.outputPath ? blueprint.outputPath : @"";
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    NSIndexSet *columns = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
    NSMutableIndexSet *rows = [NSMutableIndexSet indexSet];
    NSTableRowView *rowView;
    
    if( self.tableView.selectedRow > -1)
    {
        rowView = [self.tableView rowViewAtRow:self.tableView.selectedRow
                                          makeIfNecessary:NO];
        rowView.backgroundColor = [NSColor colorWithDeviceRed:0.959 green:0.967 blue:0.977 alpha:1.000];//[NSColor colorWithDeviceRed:0.911 green:0.936 blue:0.964 alpha:1.000];
        [rows addIndex:tableView.selectedRow];
    }
    
    if( self.previousSelectedRow > -1)
    {
        rowView = [self.tableView rowViewAtRow:self.previousSelectedRow
                               makeIfNecessary:NO];
        rowView.backgroundColor = [NSColor whiteColor];
        [rows addIndex:self.previousSelectedRow];
    }
    
    self.previousSelectedRow = tableView.selectedRow;
    
    [tableView reloadDataForRowIndexes:rows
                         columnIndexes:columns];
    [tableView noteHeightOfRowsWithIndexesChanged:rows];
}

#pragma mark KDEImageChannelSourceViewDelegate

- (void) presentMenuForImageChannelSourceView:(KDEImageChannelSourceView *)channelSourceView
                               withImagePaths:(NSArray *)paths
{
    KDEImageChannelSource *channelSource = [self.imageChannelSourceViewToModel objectForKey:channelSourceView];
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *item;
    
    item = [[NSMenuItem alloc] initWithTitle:@"Pick new image..."
                                      action:@selector(pickSourceImage:)
                               keyEquivalent:@""];
    item.representedObject = channelSourceView;
    [menu addItem:item];
    
    if( paths.count)
    {
        [menu addItem:[NSMenuItem separatorItem]];
        
        for( NSString *imagePath in paths)
        {
            [menu addItem:[KDEImageChannelSourceMenuItem menuItemWithTargetChannelSourceView:channelSourceView
                                                                                   imagePath:imagePath
                                                                                      action:@selector(assignSourceImageFromMenuItem:)]];
        }
    }
    
    if( channelSource.sourceImagePath.length)
    {
        [menu addItem:[NSMenuItem separatorItem]];
        
        item = [[NSMenuItem alloc] initWithTitle:@"Clear image"
                                          action:@selector(clearSourceImage:)
                                   keyEquivalent:@""];
        item.representedObject = channelSourceView;
        [menu addItem:item];
    }
    
    NSView *targetView = channelSourceView.changeButton;
    NSPoint result = [targetView convertPoint:NSMakePoint(NSMinX(targetView.bounds), NSMaxY(targetView.bounds))
                                       toView:nil];
    NSEvent *event = [NSApplication sharedApplication].currentEvent;
    
    NSEvent *newEvent = [NSEvent mouseEventWithType: [event type]
                                           location: result
                                      modifierFlags: [event modifierFlags]
                                          timestamp: [event timestamp]
                                       windowNumber: [event windowNumber]
                                            context: [event context]
                                        eventNumber: [event eventNumber]
                                         clickCount: [event clickCount]
                                           pressure: [event pressure]];
    
    [NSMenu popUpContextMenu:menu
                   withEvent:newEvent
                     forView:targetView];
}

- (void) imageChannelSourceViewDidReceiveClick:(KDEImageChannelSourceView *)channelSourceView
{
    KDEImageChannelSource *channelSource = [self.imageChannelSourceViewToModel objectForKey:channelSourceView];
    NSMutableArray *paths = [[channelSource.blueprint allChannelSourceImagePaths] mutableCopy];
    [paths removeObject:channelSource.sourceImagePath];
    
    if( channelSource.sourceImagePath || paths.count)
    {
        [self presentMenuForImageChannelSourceView:channelSourceView
                                    withImagePaths:paths];
    }
    else
    {
        [self presentImageOpenPanelWithInitialPath:nil
                                 completionHandler:^(NSString *filePath){
                                     channelSource.sourceImagePath = filePath;
                                     [channelSourceView displayImageChannelSource:channelSource];
                                 }];
    }
}

- (void) imageChannelSourceView:(KDEImageChannelSourceView *)channelSourceView didChangeSourceChannel:(KDEImageChannel)newChannel
{
    KDEImageChannelSource *channelSource = [self.imageChannelSourceViewToModel objectForKey:channelSourceView];
    channelSource.sourceImageChannel = newChannel;
}

- (void) imageChannelSourceView:(KDEImageChannelSourceView *)channelSourceView didChangeClearValue:(uint8_t)newClearValue
{
    KDEImageChannelSource *channelSource = [self.imageChannelSourceViewToModel objectForKey:channelSourceView];
    channelSource.clearValue = newClearValue;
}


@end
