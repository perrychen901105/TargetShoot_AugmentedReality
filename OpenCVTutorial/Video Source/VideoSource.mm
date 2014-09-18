//
//  VideoSource.m
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "VideoSource.h"

#pragma mark -
#pragma mark VideoSource Class Extension
@interface VideoSource ()

@end

#pragma mark -
#pragma mark VideoSource Implementation
@implementation VideoSource

#pragma mark -
#pragma mark Object Lifecycle
- (id)init {
    self = [super init];
    if ( self ) {
        // TODO: Add code here
    }
    return self;
}

#pragma mark -
#pragma mark Public Interface
- (BOOL)startWithDevicePosition:(AVCaptureDevicePosition)devicePosition {
    // TODO: Add code here
    return FALSE;
}

#pragma mark -
#pragma mark Helper Methods
- (AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position {
    // TODO: Add code here
    return nil;
}

- (void)addVideoDataOutput {
    // TODO: Add code here
}

@end
