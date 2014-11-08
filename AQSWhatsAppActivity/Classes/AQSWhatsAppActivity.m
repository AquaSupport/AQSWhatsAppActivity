//
//  AQSWhatsAppActivity.m
//  AQSWhatsAppActivity
//
//  Created by kaiinui on 2014/11/08.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQSWhatsAppActivity.h"

NSString *const kAQSWhatsAppURLScheme = @"whatsapp://";

@interface AQSWhatsAppActivity () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property (nonatomic, assign) BOOL isPerformed;

@end

@implementation AQSWhatsAppActivity

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    [super prepareWithActivityItems:activityItems];
    
    self.activityItems = activityItems;
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (NSString *)activityType {
    return @"org.openaquamarine.whatsapp";
}

- (NSString *)activityTitle {
    return @"WhatsApp";
}

- (UIImage *)activityImage {
    if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 8) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"color_%@", NSStringFromClass([self class])]];
    } else {
        return [UIImage imageNamed:NSStringFromClass([self class])];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return [self isWhatsAppInstalled];
}

- (void)performActivity {
    NSString *text = [self nilOrFirstStringFromArray:_activityItems];
    UIImage *image = [self nilOrFirstImageFromArray:_activityItems];
    NSURL *URL = [self nilOrFirstURLFromArray:_activityItems];
    
    if (!!image) {
        [self performWithImage:image];
    } else if (!!text && !!URL) {
        NSString *body = [NSString stringWithFormat:@"%@ %@", text, URL];
        [self performWithText:body];
    } else if (!!text) {
        [self performWithText:text];
    } else if (!!URL) {
        [self performWithText:URL.absoluteString];
    } else {
        [self activityDidFinish:NO];
    }
}

# pragma mark - Helpers (Share)

- (void)performWithText:(NSString *)text {
    [self activityDidFinish:YES];
    [[UIApplication sharedApplication] openURL:[self whatsAppShareURLWithText:text]];
}

- (void)performWithImage:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    
    NSURL *URL = [self nilOrFileURLWithImageDataTemporary:data];
    self.controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
    UIView *currentView = [self currentView];
    [self.controller presentOpenInMenuFromRect:CGRectMake(0, 0, currentView.bounds.size.width, currentView.bounds.size.width) inView:currentView animated:YES];
}

# pragma mark - Helpers (View)

- (UIView *)currentView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.rootViewController.view;
}

# pragma mark - Helpers (WhatsApp)

- (BOOL)isWhatsAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kAQSWhatsAppURLScheme]];
}

- (NSURL *)whatsAppShareURLWithText:(NSString *)text {
    NSString *encoded = [self stringByEncodingString:text];
    return [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", encoded]];
}

# pragma mark - Helpers (WhatsApp + Document)

- (NSURL *)nilOrFileURLWithImageDataTemporary:(NSData *)data {
    NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"whatsapp.wai"];
    if (![data writeToFile:writePath atomically:YES]) {
        [self activityDidFinish:NO];
        return nil;
    }
    
    return [NSURL fileURLWithPath:writePath];
}

- (UIDocumentInteractionController *)documentInteractionControllerForInstagramWithFileURL:(NSURL *)URL {
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
    [controller setUTI:@"net.whatsapp.image"];
    
    return controller;
}

# pragma mark - Helpers (UIActivity)

- (NSString *)nilOrFirstStringFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[NSString class]]) {
            return item;
        }
    }
    return nil;
}

- (UIImage *)nilOrFirstImageFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[UIImage class]]) {
            return item;
        }
    }
    return nil;
}

- (NSURL *)nilOrFirstURLFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[NSURL class]]) {
            return item;
        }
    }
    return nil;
}

# pragma mark - Helpers (String)

- (NSString *)stringByEncodingString:(NSString *)string {
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return CFBridgingRelease(encodedString);
}

# pragma mark - UIDocumentInteractionControllerDelegate

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    if ([application isEqualToString:@"net.whatsapp.whatsapp"]) {
        self.isPerformed = YES;
    }
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    [self activityDidFinish:self.isPerformed];
}

@end
