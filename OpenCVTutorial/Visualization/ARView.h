//
//  ARView.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/18/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "CameraCalibration.h"

@interface ARView : UIView

#pragma mark -
#pragma mark Constructors
- (id)initWithSize:(CGSize)size calibration:(struct CameraCalibration)calibration;

#pragma mark -
#pragma mark Gameplay
- (int)selectBestRing:(CGPoint)point;

#pragma mark -
#pragma mark Display Controls
- (void)show;
- (void)hide;

@end
