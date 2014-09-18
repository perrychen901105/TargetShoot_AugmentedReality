//
//  AppDelegate.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark Hardware Detection
static inline BOOL IS_IPAD()     { return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad; }
static inline BOOL IS_IPHONE()   { return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone; }
static inline BOOL IS_IPHONE_5() { return IS_IPHONE() && [[UIScreen mainScreen] bounds].size.height == 568.0f; }
static inline BOOL IS_IPHONE_4() { return IS_IPHONE() && [[UIScreen mainScreen] bounds].size.height == 480.0f; }

#pragma mark -
#pragma mark AppDelegate Interface
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
