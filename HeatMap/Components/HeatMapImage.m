//
//  HeatMapImage.m
//  CoreImageFilterTest01
//
//  Created by KN on 07/07/2014.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeatMapImage.h"

@interface HeatMapImage()
@property(nonatomic, strong)NSArray *pointsArray;
@end

@implementation HeatMapImage

-(HeatMapImage*) initWithFrame:(CGRect) initFrame
{
    self = [super initWithFrame:initFrame];
    
    if (self) {
        self.frame = initFrame;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self setResolution:initFrame.size];
        [self setUseStencil:true];
        [self setRadius:0.05];//0.02
        [self setGamma:2.5];//1.0
    }
    
    return self;
}

- (HeatMapImage*)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    if (self){
        [self setResolution:CGSizeMake(400, 600)];
        [self setUseStencil:true];
        [self setRadius:0.02];
        [self setGamma:1.0];
    }

    return self;
}

- (UIImage *)drawHeightMapUsingStencil
{
    UIImage *blobImage = [UIImage imageNamed:@"redDot_06.png"] ;
    
    // Initialise
    UIGraphicsBeginImageContextWithOptions(self.resolution, YES, 1);
    
    // Grab it as an autoreleased image
    float resolutionDependantWidth = self.radius * 5 * MAX(self.resolution.height, self.resolution.width);
    
    for (int i = 0; i < _pointsArray.count; i++) {

        CGPoint point = [[_pointsArray objectAtIndex:i] CGPointValue];
        
        point.x = point.x * _resolution.width - resolutionDependantWidth * 0.5;
        point.y = point.y * _resolution.height - resolutionDependantWidth * 0.5;
        
        [blobImage drawInRect:CGRectMake(point.x, point.y,
                                         resolutionDependantWidth,
                                         resolutionDependantWidth)];
        
    }
    
    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); // Clean up
    return image;

}

- (UIImage *)drawHeightMapUsingGradients
{
    // Initialise
    UIGraphicsBeginImageContextWithOptions(self.resolution, YES, 1);
    
    //float maxIntens=1.0;
    CGFloat colors [] = { 
        1.0, 0.0, 0.0, 0.85, 
        1.0, 0.0, 0.0, 0.7,
        1.0, 0.0, 0.0, 0.33,
        1.0, 0.0, 0.0, 0.0, 
    };

    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 4);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    float resolutionDependantRadius = self.radius * MAX(_resolution.height, _resolution.width);
    
    for (int i = 0; i < _pointsArray.count; i++) {

        CGPoint point = [[_pointsArray objectAtIndex:i] CGPointValue];
        point.x *= _resolution.width;
        point.y *= _resolution.height;
        CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, point,
                                     0, point, resolutionDependantRadius,
                                     kCGGradientDrawsAfterEndLocation);
        
    }
    
    
    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient), gradient = NULL;
    
    UIGraphicsEndImageContext(); // Clean up
    return image;
}



-(void)rerenderHeatmap:(NSArray *)pointsArray
{
    _pointsArray = pointsArray;
    
    CIImage *inputImage;

    if (self.useStencil) {
        inputImage = [[CIImage alloc] initWithImage:[self drawHeightMapUsingStencil]];
    }
    else {
        inputImage = [[CIImage alloc] initWithImage:[self drawHeightMapUsingGradients]];
        
    }
    
    // Make tone filter filter
    // See mentioned link for visual reference
    
    CIFilter *cubeHeatmapLookupFilter = [CIFilter filterWithName:@"CIColorCube"];
    
    int dimension = 4;  // Must be power of 2, max of 128 (max of 64 on ios)
    int cubeDataSize = 4 * dimension * dimension * dimension;
    
    unsigned char cubeDataBytes[cubeDataSize];
    
    cubeDataBytes[0] = 0;
    cubeDataBytes[1] = 0;
    cubeDataBytes[2] = 0;
    cubeDataBytes[3] = 0;
    
    cubeDataBytes[4] = 255;  //>150
    cubeDataBytes[5] = 0;  //4 makes a more realistic effect
    cubeDataBytes[6] = 0; 
    cubeDataBytes[7] = 170;//150
    
    cubeDataBytes[8] = 255;
    cubeDataBytes[9] = 250;
    cubeDataBytes[10] = 0;
    cubeDataBytes[11] = 200;
    
    cubeDataBytes[12] = 255;
    cubeDataBytes[13] = 255;
    cubeDataBytes[14] = 255;
    cubeDataBytes[15] = 255;
    
    for (int i = 16; i < cubeDataSize; i += 4)
    {
        cubeDataBytes[i] = 0;
        cubeDataBytes[i+1] = 0;
        cubeDataBytes[i+2] = 0;
        cubeDataBytes[i+3] = 0;
    }
    
    NSData *cube_data = [NSData dataWithBytes:cubeDataBytes length:(cubeDataSize*sizeof(char))];

    CIFilter *gammaFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
    
    [gammaFilter setValue:inputImage forKey:@"inputImage"];
    [gammaFilter setValue:[NSNumber numberWithFloat:self.gamma] forKey:@"inputPower"];    
    
    [cubeHeatmapLookupFilter setValue:[gammaFilter outputImage] forKey:@"inputImage"];
    [cubeHeatmapLookupFilter setValue:cube_data forKey:@"inputCubeData"];
    [cubeHeatmapLookupFilter setValue:[NSNumber numberWithFloat:dimension] forKey:@"inputCubeDimension"];
    
    CIImage *outputImage = [cubeHeatmapLookupFilter outputImage];
    
    CIContext *context = [CIContext contextWithOptions : nil];
    CGImageRef cgImg = [context createCGImage:outputImage fromRect : [outputImage extent]];
    
    [self setImage:[UIImage imageWithCGImage:cgImg]];
    
    CGImageRelease(cgImg);
}

@end
