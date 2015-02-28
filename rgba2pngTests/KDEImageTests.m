//
//  KDEImageTests.m
//  rgba2png
//
//  Created by Benjamin S Hopkins on 2/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "KDEImage.h"
#import "KDEImage+Private.h"


@interface KDEImageTests : XCTestCase

@end


@implementation KDEImageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testBitShiftForChannel
{
    XCTAssertEqual( [KDEImage bitShiftForChannel:KDEImageChannelRed],    0, @"Red channel bit shift is incorrect.");
    XCTAssertEqual( [KDEImage bitShiftForChannel:KDEImageChannelGreen],  8, @"Green channel bit shift is incorrect.");
    XCTAssertEqual( [KDEImage bitShiftForChannel:KDEImageChannelBlue],  16, @"Blue channel bit shift is incorrect.");
    XCTAssertEqual( [KDEImage bitShiftForChannel:KDEImageChannelAlpha], 24, @"Alpha channel bit shift is incorrect.");
}

- (void) testBitMaskForChannel
{
    XCTAssertEqual( [KDEImage bitMaskForChannel:KDEImageChannelRed],   0xff000000, @"Red channel bit mask is incorrect.");
    XCTAssertEqual( [KDEImage bitMaskForChannel:KDEImageChannelGreen], 0x00ff0000, @"Green channel bit mask is incorrect.");
    XCTAssertEqual( [KDEImage bitMaskForChannel:KDEImageChannelBlue],  0x0000ff00, @"Blue channel bit mask is incorrect.");
    XCTAssertEqual( [KDEImage bitMaskForChannel:KDEImageChannelAlpha], 0x000000ff, @"Alpha channel bit mask is incorrect.");
}

- (void) testInitWithContentsOfFile
{
    KDEImage *image = [[KDEImage alloc] initWithContentsOfFile:[self pathForImageNamed:@"TestImage_Same1"]];
    XCTAssertNotNil( image, @"Couldn't load test image.");
}

- (void) testIsEqualToImage
{
    KDEImage *same1 = [[KDEImage alloc] initWithContentsOfFile:[self pathForImageNamed:@"TestImage_Same1"]];
    KDEImage *same2 = [[KDEImage alloc] initWithContentsOfFile:[self pathForImageNamed:@"TestImage_Same2"]];
    KDEImage *different = [[KDEImage alloc] initWithContentsOfFile:[self pathForImageNamed:@"TestImage_Different"]];
    
    XCTAssertTrue( [same1 isEqualToImage:same1], @"Same instances should return equal");
    XCTAssertTrue( [same1 isEqualToImage:same2], @"Identical images should return equal");
    XCTAssertFalse( [same1 isEqualToImage:different], @"Non-identical images should return not-equal");
}

- (NSString *) pathForImageNamed:(NSString *)imageName
{
    return [[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"];
}

@end
