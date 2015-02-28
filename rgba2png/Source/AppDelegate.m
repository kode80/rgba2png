//
//  AppDelegate.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "AppDelegate.h"
#import "KDEImage.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *desktopPath = paths[0];
    
    KDEImage *image = [[KDEImage alloc] initWithContentsOfFile:[desktopPath stringByAppendingPathComponent:@"imtest/input.png"]];
    [image convertToLuminosity];
    [image savePNGToPath:[desktopPath stringByAppendingPathComponent:@"imtest/output.png"]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
