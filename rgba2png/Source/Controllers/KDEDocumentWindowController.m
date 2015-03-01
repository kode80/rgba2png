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


@interface KDEDocumentWindowController ()

@property (nonatomic, readwrite, assign) NSInteger previousSelectedRow;

@end


@implementation KDEDocumentWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.previousSelectedRow = 0;
    self.window.titleVisibility = NSWindowTitleHidden;
}

- (IBAction) addImageBlueprint:(id)sender
{
    Document *document = (Document *)self.document;
    KDEImageBlueprint *blueprint = [KDEImageBlueprint new];
    [document addImageBlueprint:blueprint];
    [self.tableView reloadData];
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

- (IBAction) pickImageBlueprintOutputPath:(id)sender
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = @[ @"png"];
    panel.nameFieldStringValue = @"Untitled.png";
    [panel beginSheetModalForWindow:self.window
                  completionHandler:^(NSInteger result){
                      if (result == NSFileHandlingPanelOKButton)
                      {
                          NSView *parent = [(NSView *)sender superview];
                          NSInteger row = [self.tableView rowForView:parent];
                          Document *document = (Document *)self.document;
                          KDEImageBlueprint *blueprint = document.imageBlueprints[ row];
                          blueprint.outputPath = panel.URL.filePathURL.path;
                          
                          [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row]
                                                    columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                      }
                  }];
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
    return tableView.selectedRow == row ? 100.0f : 40.0f;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Document *document = (Document *)self.document;
    KDEImageBlueprint *blueprint = document.imageBlueprints[ row];
    
    if( tableView.selectedRow == row)
    {
        NSTableCellView *selectedCell = [tableView makeViewWithIdentifier:@"DetailCell" owner:self];
        return selectedCell;
    }
    
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"Cell" owner:self];
    cell.textField.stringValue = blueprint.outputPath ? blueprint.outputPath : @"";
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    NSIndexSet *columns = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
    NSMutableIndexSet *rows = [NSMutableIndexSet indexSetWithIndex:self.previousSelectedRow];
    [rows addIndex:tableView.selectedRow];

    [tableView reloadDataForRowIndexes:rows
                         columnIndexes:columns];
    
    self.previousSelectedRow = tableView.selectedRow;
    [tableView noteHeightOfRowsWithIndexesChanged:rows];
}


@end
