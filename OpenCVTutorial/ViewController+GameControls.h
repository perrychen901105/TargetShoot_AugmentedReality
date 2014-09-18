//
//  ViewController+GameControls.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (GameControls)

#pragma mark -
#pragma mark Game Controls
- (void)loadGameControls;

#pragma mark -
#pragma mark Game Play
- (NSInteger)selectRandomRing;
- (void)showFloatingScore:(NSInteger)points;
- (void)showExplosion;

@end
