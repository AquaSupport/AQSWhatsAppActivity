//
//  AQSWhatsAppActivityTests.m
//  AQSWhatsAppActivityTests
//
//  Created by kaiinui on 2014/11/08.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock.h>

#import "AQSWhatsAppActivity.h"

@interface AQSWhatsAppActivity (Test) <UIDocumentInteractionControllerDelegate>

- (BOOL)isWhatsAppInstalled;
- (NSURL *)nilOrFileURLWithImageDataTemporary:(NSData *)data;
- (UIDocumentInteractionController *)documentInteractionControllerForInstagramWithFileURL:(NSURL *)URL;

@end

@interface AQSWhatsAppActivityTests : XCTestCase

@property AQSWhatsAppActivity *activity;

@end

@implementation AQSWhatsAppActivityTests

- (void)setUp {
    [super setUp];
    
    _activity = [[AQSWhatsAppActivity alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItsActivityCategoryIsShare {
    XCTAssertTrue(AQSWhatsAppActivity.activityCategory == UIActivityCategoryShare);
}

- (void)testItReturnsItsImage {
    XCTAssertNotNil(_activity.activityImage);
}

- (void)testItReturnsItsType {
    XCTAssertTrue([_activity.activityType isEqualToString:@"org.openaquamarine.whatsapp"]);
}

- (void)testItReturnsItsTitle {
    XCTAssertTrue([_activity.activityTitle isEqualToString:@"WhatsApp"]);
}

- (void)testItCanPerformActivityWithImage {
    id activity = [OCMockObject partialMockForObject:_activity];
    OCMStub([activity isWhatsAppInstalled]).andReturn(YES);
    
    NSArray *activityItems = @[@"hoge", [UIImage imageNamed:@"test.jpg"]];
    XCTAssertTrue([activity canPerformWithActivityItems:activityItems]);
}

- (void)testItCannotPerformActivityWithURLAndText {
    id activity = [OCMockObject partialMockForObject:_activity];
    OCMStub([activity isWhatsAppInstalled]).andReturn(YES);
    
    NSArray *activityItems = @[@"hoge", [NSURL URLWithString:@"http://google.com/"]];
    XCTAssertTrue([activity canPerformWithActivityItems:activityItems]);
}

- (void)testItCannotPerformActivityWithoutAppWithImage {
    id activity = [OCMockObject partialMockForObject:_activity];
    OCMStub([activity isWhatsAppInstalled]).andReturn(NO);
    
    NSArray *activityItems = @[@"hoge", [UIImage imageNamed:@"test.jpg"]];
    XCTAssertFalse([activity canPerformWithActivityItems:activityItems]);
}

- (void)testItCannotPerformActivityWithoutAppWithoutImage {
    id activity = [OCMockObject partialMockForObject:_activity];
    OCMStub([activity isWhatsAppInstalled]).andReturn(NO);
    
    NSArray *activityItems = @[@"hoge", [NSURL URLWithString:@"http://google.com/"]];
    XCTAssertFalse([activity canPerformWithActivityItems:activityItems]);
}

- (void)testItReturnsFileURLForWritingImageDataTemporary {
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"test.jpg"], 0.9);
    XCTAssertNotNil([_activity nilOrFileURLWithImageDataTemporary:data]);
}

- (void)testItReturnsDocumentInteractionControllerForInstagramSharing {
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"test.jpg"], 0.9);
    NSURL *URL = [_activity nilOrFileURLWithImageDataTemporary:data];
    
    UIDocumentInteractionController *controller = [_activity documentInteractionControllerForInstagramWithFileURL:URL];
    
    XCTAssertTrue([controller.UTI isEqualToString:@"net.whatsapp.image"]);
    XCTAssertEqual(controller.URL, URL);
}

- (void)testItInvokeDidFinishWithYESWhenThePressedAppIsInstagram {
    id activity = [OCMockObject partialMockForObject:_activity];
    [[activity expect] activityDidFinish:YES];
    
    [activity documentInteractionController:nil willBeginSendingToApplication:@"net.whatsapp.whatsapp"];
    [activity documentInteractionControllerDidDismissOpenInMenu:nil];
    
    [activity verify];
}

- (void)testItInvokeDidFinishWithNOIfThePressedAppIsNotInstagram {
    id activity = [OCMockObject partialMockForObject:_activity];
    [[activity expect] activityDidFinish:NO];
    
    [activity documentInteractionController:nil willBeginSendingToApplication:@"com.example.app"];
    [activity documentInteractionControllerDidDismissOpenInMenu:nil];
    
    [activity verify];
}

- (void)testItInvokeDidFinishWithNOIfTheMenuDismissed {
    id activity = [OCMockObject partialMockForObject:_activity];
    [[activity expect] activityDidFinish:NO];
    
    [activity documentInteractionControllerDidDismissOpenInMenu:nil];
    
    [activity verify];
}

@end
