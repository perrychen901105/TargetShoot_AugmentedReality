//
//  UIImage+OpenCV.m
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "UIImage+OpenCV.h"

@implementation UIImage (OpenCV)

// TODO: Add code here

+ (cv::Mat)toCVMat:(UIImage *)image
{
    // 1 Get image dimensions
    /*
     *  You retrieve the width and height attributes of the UIImage.
     */
    
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    // 2 Create OpenCV image container, 8 bits per component, 4 channels
    /*
     *  You then construct a new OpenCV image container of the specified width and height. The CV_8UC4 flag indicates that the image consists of 4 color channels, and each channel consists of 8 bits per component.
     */
    cv::Mat cvMat(rows, cols, CV_8UC4);
    
    // 3 Create CG context and draw the image
    /*
     *  create a Core Graphics context and draw the image data from the UIImage object into that context.
     */
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, cols, rows, 8
                                                    , cvMat.step[0], CGImageGetColorSpace(image.CGImage), kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    // 4 Return OpenCV image container reference
    /*
     *  return the OpenCV image container refernce to the caller.
     */
    return cvMat;
}

- (cv::Mat)toCVMat
{
    return [UIImage toCVMat:self];
}

+ (UIImage *)fromCVMat:(const cv::Mat&)cvMat
{
    // 1 Construct the correct color space
    /*
     *  creates a new color space.If the image has only one color channel,
     */
    CGColorSpaceRef colorSpace;
    if (cvMat.channels() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    // 2 Create image data reference
    /*
     *  the method creates a new Core Foundation data reference that points to the image container's data. 
        elemsize() returns the size of an image pixel in bytes, while total() returns the total number of pixels
        in the image. The total size of the byte array to be allocated comes from multiplying these two numbers.
     */
    CFDataRef data = CFDataCreate(kCFAllocatorDefault, cvMat.data, (cvMat.elemSize() * cvMat.total()));
    
    // 3 Create CGImage from cv::Mat container
    /*
     *  constructs a new CGImage reference that points to the OpenCV image container
     */
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGImageRef imageRef = CGImageCreate(cvMat.cols
                                        , cvMat.rows
                                        , 8
                                        , 8 * cvMat.elemSize()
                                        , cvMat.step[0]
                                        , colorSpace
                                        , kCGImageAlphaNone | kCGBitmapByteOrderDefault
                                        , provider
                                        , NULL
                                        , false, kCGRenderingIntentDefault);
    
    // 4 Create UIImage from CGImage
    /*
     *  constructs a new UIImage object from the CGImage reference.
     */
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    
    // 5 Release the references
    /*
     *  it releases the locally defined Core Foundation objects before exiting the method.
     */
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CFRelease(data);
    CGColorSpaceRelease(colorSpace);
    
    // 6 return the UIImage instance
    /*
     *  it returns the newly-constructed UIImage instance to the caller.
     */
    return finalImage;
    
}

@end
