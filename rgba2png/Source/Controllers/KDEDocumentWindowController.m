//
//  KDEDocumentWindowController.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEDocumentWindowController.h"


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
    NSLog(@"addImageBlueprint");
}

- (IBAction) removeSelectedImageBlueprint:(id)sender
{
    NSLog(@"removeSelectedImageBlueprint");
}

#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 50;
}

#pragma mark NSTableViewDelegate

- (CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return tableView.selectedRow == row ? 100.0f : 40.0f;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if( tableView.selectedRow == row)
    {
        NSTableCellView *selectedCell = [tableView makeViewWithIdentifier:@"DetailCell" owner:self];
        return selectedCell;
    }
    
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"Cell" owner:self];
    cell.textField.stringValue = [NSString stringWithFormat:@"cell #%d", (int)row];
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
