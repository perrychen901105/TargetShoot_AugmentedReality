//
//  VideoSource.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "VideoFrame.h"

#pragma mark -
#pragma mark VideoSource Delegate
@protocol VideoSourceDelegate <NSObject>

@required
- (void)frameReady:(VideoFrame)frame;

@end

#pragma mark -
#pragma mark VideoSource Interface
@interface VideoSource : NSObject


// coordinate the flow of video data between the the rear-facing camera on your iOS device, the output ports that you're going to configure below, and ultimately OpenCV.
@property (nonatomic, strong) AVCaptureSession * captureSession;

// acts as an input port that can attach to the various A/V hardware components on your iOS device. In the next section, you're going to associate thisproperty with the rear-facing camera and add it as an input port for captureSession.
@property (nonatomic, strong) AVCaptureDeviceInput * deviceInput;

// This protocol is the 'glue' between the output ports for captureSession and OpenCV. Whenever one of your output ports is ready to dispatch a new video frame to OpenCV. it will invoke the frameReady: callback on the delegate member of VideoSource.
@property (nonatomic, weak) id<VideoSourceDelegate> delegate;

- (BOOL)startWithDevicePosition:(AVCaptureDevicePosition)devicePosition;

@end

