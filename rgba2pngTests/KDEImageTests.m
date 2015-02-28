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
    XCTAssertEqual( [KDEImage bitShiftForChannel:KDEImageChannelRed],   24, @"Red channel bit shift is incorrect.");
    XCTAssertEqual( [KDEImage bitShiftForChannel:KDEImageChannelGreen], 16, @"Green channel bit shift is incorrect.");
    XCTAssertEqual( [KDEImage bitShiftForChannel:KDEImageChannelBlue],   8, @"Blue channel bit shift is incorrect.");
    XCTAssertEqual( [KDEImage bitShiftForChannel:KDEImageChannelAlpha],  0, @"Alpha channel bit shift is incorrect.");
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

- (void) testInitWithWidthHeightColor
{
    KDEImage *correctImage1 = [[KDEImage alloc] initWithContentsOfFile:[self pathForImageNamed:@"TestImage_r58g215b255"]];
    KDEImage *testImage1 = [[KDEImage alloc] initWithWidth:correctImage1.pixelWidth
                                                    height:correctImage1.pixelHeight
                                                     color:KDEImagePixelMake( 58, 215, 255, 255)];
    XCTAssertTrue( [testImage1 isEqualToImage:correctImage1], @"New color-filled image should be equal to from-disk image.");
    
    KDEImage *correctImage2 = [[KDEImage alloc] initWithContentsOfFile:[self pathForImageNamed:@"TestImage_r196g44b0"]];
    KDEImage *testImage2 = [[KDEImage alloc] initWithWidth:correctImage1.pixelWidth
                                                    height:correctImage1.pixelHeight
                                                     color:KDEImagePixelMake( 196, 44, 0, 255)];
    XCTAssertTrue( [testImage2 isEqualToImage:correctImage2], @"New color-filled image should be equal to from-disk image.");
    
    KDEImage *correctImage3 = [[KDEImage alloc] initWithContentsOfFile:[self pathForImageNamed:@"TestImage_r236g246b106"]];
    KDEImage *testImage3 = [[KDEImage alloc] initWithWidth:correctImage1.pixelWidth
                                                    height:correctImage1.pixelHeight
                                                     color:KDEImagePixelMake( 236, 246, 106, 255)];
    XCTAssertTrue( [testImage3 isEqualToImage:correctImage3], @"New color-filled image should be equal to from-disk image.");
}

- (void) testCopyChannels
{
    KDEImage *original = [[KDEImage alloc] initWithContentsOfFile:[self pathForImageNamed:@"TestImage_Same1"]];
    KDEImage *reconstructed = [[KDEImage alloc] initWithWidth:original.pixelWidth
                                                       height:original.pixelHeight
                                                        color:KDEImagePixelMake( 0, 0, 0, 0)];
    
    [reconstructed copyChannel:KDEImageChannelRed
                     fromImage:original
                     toChannel:KDEImageChannelRed];
    
    [reconstructed copyChannel:KDEImageChannelGreen
                     fromImage:original
                     toChannel:KDEImageChannelGreen];
    
    [reconstructed copyChannel:KDEImageChannelBlue
                     fromImage:original
                     toChannel:KDEImageChannelBlue];
    
    [reconstructed copyChannel:KDEImageChannelAlpha
                     fromImage:original
                     toChannel:KDEImageChannelAlpha];
    
    XCTAssertTrue( [reconstructed isEqualToImage:original], @"Image reconstructed by copying each channel should equal original.");
}

- (NSString *) pathForImageNamed:(NSString *)imageName
{
    return [[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"];
}

@end
