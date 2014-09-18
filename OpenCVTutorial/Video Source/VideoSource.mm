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
@interface VideoSource () <AVCaptureVideoDataOutputSampleBufferDelegate>

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
        /*
         *  create new instance of AVCaptureSession and configures it to accept video input at the standard VGA resolution of 640X480 pixels.
         */
        AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
        if ([captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
            NSLog(@"Capturing video at 640X480");
        } else {
            NSLog(@"Could not configure AVCaptureSession video input");
        }
        _captureSession = captureSession;
    }
    return self;
}

- (void)dealloc
{
    [_captureSession stopRunning];
}

#pragma mark -
#pragma mark Public Interface
- (BOOL)startWithDevicePosition:(AVCaptureDevicePosition)devicePosition {
    // TODO: Add code here
    // 1 Find camera device at the specific position
    /*
     *  returns with a reference to the camera device located at the specified position and you save this reference in videoDevice.
     */
    AVCaptureDevice *videoDevice = [self cameraWithPosition:devicePosition];
    if (!videoDevice) {
        NSLog(@"Could not initialize camera at position %d", devicePosition);
        return FALSE;
    }
    
    // 2 Obtain input port for camera device
    /*
     *  configures and returns an input port for videoDevice, and saves it in a local variable named videoInput. If the port can't be configured, then log an error.
     */
    NSError *error;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (!error) {
        [self setDeviceInput:videoInput];
    } else {
        NSLog(@"Could not open input port for device %@ (%@)", videoDevice, [error localizedDescription]);
        return FALSE;
    }
    
    // 3 Configure input prot for captureSession
    if ([self.captureSession canAddInput:videoInput]) {
        [self.captureSession addInput:videoInput];
    } else {
        NSLog(@"Could not add input port to capture session %@", self.captureSession);
        return FALSE;
    }
    
    // 4 Configure input port for captureSession
    [self addVideoDataOutput];
    
    // 5 start captureSession running
    [self.captureSession startRunning];
    return FALSE;
}

#pragma mark -
#pragma mark Helper Methods
- (AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position {
    // TODO: Add code here
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (void)addVideoDataOutput {
    // TODO: Add code here
    // 1 Instantiate a new video data output object
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    // improve performance at the risk of occasionally losing late frames
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // 2 The sample buffer delegate requires a serial dispatch queue
    dispatch_queue_t queue;
    queue = dispatch_queue_create("com.raywenderlich.tutorials.opencv", DISPATCH_QUEUE_SERIAL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    // 3 Define the pixel format for the video data output
    NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *settings = @{key:value};
    [captureOutput setVideoSettings:settings];
    
    // 4 configure the output port on the captureSession property
    [self.captureSession addOutput:captureOutput];
}

#pragma mark -
#pragma mark Sample Buffer Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // 1 convert CMSampleBufferRef to CVImageBufferRef
    /*
     *  dispatch video data to the delegate in the form of a CMSampleBuffer which is subsequently converted to a pixel buffer of type CVImageBuffer named imageBuffer.
     */
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // 2 LOCK PIXEL BUFFER
    /*
     *  must lock the pixel buffer until you're done using it since you're working with pixel data on the CPU. As you're not going to modify the buffer while you're holding the lock, you invoke the method with kCVPixelBufferLock_ReadOnly for added performance.
     */
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    
    // 3 Contruct VideoFrame struct
    uint8_t *baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t stride = CVPixelBufferGetBytesPerRow(imageBuffer);
    VideoFrame frame = {width, height, stride, baseAddress};
    
    // 4 Dispatch VideoFrame to VideoSource delegate
    [self.delegate frameReady:frame];
    
    // 5 Unlock pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}


@end
