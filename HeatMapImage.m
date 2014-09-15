//
//  HeatMapImage.m
//  CoreImageFilterTest01
//
//  Created by Vlad on 07/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeatMapImage.h"

@implementation HeatMapImage
@synthesize resolution=_resolution;
@synthesize radius=_radius;
@synthesize pointsArray=_pointsArray;
@synthesize gamma=_gamma;
@synthesize blobImage=_blobImage;
@synthesize useStencil=_useStencil;
@synthesize stencilImageName=_stencilImageName;
@synthesize maxPointNumber=_maxPointNumber;
@synthesize startPointNumber=_startPointNumber;


-(HeatMapImage*) init
{

    if (self = [super init]) {
        //self=[[HeatMapImage alloc]init ];
        [self setResolution:CGSizeMake(400, 600)];
        [self setUseStencil:true];
        [self setRadius:0.02];
        [self setGamma:1.0];
        [self setUseStencil:true];
        [self setUseStencil:true];
        [self setMaxPointNumber:500];
        [self setStartPointNumber:0];

    }
    return self;
}

- (HeatMapImage*)initWithCoder:(NSCoder *)decoder {
    if (self=[super initWithCoder:decoder]){
        [self setResolution:CGSizeMake(400, 600)];
        [self setUseStencil:true];
        [self setRadius:0.02];
        [self setGamma:1.0];
        [self setUseStencil:true];
        [self setUseStencil:true];
        [self setMaxPointNumber:500];
        [self setStartPointNumber:0];

    }
    return self;
}

- (CGSize)resolution
{
    return _resolution;
}
- (void)setResolution:(CGSize)resolution
{
    _resolution=resolution;
}

- (CGFloat)radius
{
    return _radius;
}
- (void)setRadius:(CGFloat)radius
{
    _radius=radius;
    //[self rerenderHeatmap];
}

- (CGFloat)gamma
{
    return _gamma;
}
- (void)setGamma:(CGFloat)gamma
{
    _gamma=gamma;
    //[self rerenderHeatmap];
}
- (Boolean)useStencil
{
    return _useStencil;
}
- (void)setUseStencil:(Boolean)useStencil
{
    _useStencil=useStencil;
    //[self rerenderHeatmap];
}



- (UIImage *)drawHeightMapUsingStencil
{
    self.blobImage = [UIImage imageNamed:self.stencilImageName] ;
    
    // Initialise
    UIGraphicsBeginImageContextWithOptions(self.resolution, YES, 1);

    
    // Grab it as an autoreleased image
        
    float resolutionDependantWidth = self.radius*5*MAX(self.resolution.height, self.resolution.width);
    for (int i=self.startPointNumber; i<MIN(self.pointsArray.count,self.maxPointNumber+self.startPointNumber);i++) {
        //NSValue *val = [self.pointsArray objectAtIndex:i];
        //CGPoint p = [val CGPointValue];
        CGPoint point = [[self.pointsArray objectAtIndex:i] CGPointValue];
        point.x = point.x*self.resolution.width  -resolutionDependantWidth*0.5;
        point.y = point.y*self.resolution.height -resolutionDependantWidth*0.5;
        //NSLog(@"%f, %f", point.x, point.y);
        //[self.blobImage drawAtPoint:point];  
        [self.blobImage drawInRect:CGRectMake(point.x, point.y, resolutionDependantWidth,resolutionDependantWidth)];  
        
    }
    
    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //CGContextRestoreGState(context);
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
    //colors[0]=self.gamma;
    //[self setBackgroundColor:[UIColor clearColor]];
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 4);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CGContextSaveGState(context);
    float resolutionDependantRadius = self.radius*MAX(self.resolution.height, self.resolution.width);
    for (int i=self.startPointNumber; i<MIN(self.pointsArray.count,self.maxPointNumber+self.startPointNumber);i++) {
        //NSValue *val = [self.pointsArray objectAtIndex:i];
        //CGPoint p = [val CGPointValue];
        
        CGPoint point = [[self.pointsArray objectAtIndex:i] CGPointValue];
        point.x *= self.resolution.width;
        point.y *= self.resolution.height;
        CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, point,
                                     0, point, resolutionDependantRadius,
                                     kCGGradientDrawsAfterEndLocation);
        
    }
    
    
    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient), gradient = NULL;
    
    //CGContextRestoreGState(context);
    UIGraphicsEndImageContext(); // Clean up
    return image;
}



-(void) rerenderHeatmap
{
    //CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"heightMap_red_and_alpha.png"]];
    CIImage *inputImage;
    if (self.useStencil) {
        inputImage = [[CIImage alloc] initWithImage:[self drawHeightMapUsingStencil]];
    }
    else {
        inputImage = [[CIImage alloc] initWithImage:[self drawHeightMapUsingGradients]];
        
    }
    //CIImage *inputImage = [self radialGradientImage:CGSizeMake(512 ,512) start:12 end:24 centre:CGPointMake(120, 120) radius:64];
    
    // Make tone filter filter
    // See mentioned link for visual reference
    CIFilter *cubeHeatmapLookupFilter = [CIFilter filterWithName:@"CIColorCube"];
    //[cubeHeatmapLookupFilter setDefaults];
    
    /*
    int dimension = 8;  // Must be power of 2, max of 128 (max of 64 on ios)
    int cubeDataSize = 4 * dimension * dimension * dimension;
    
    unsigned char cubeDataBytes[cubeDataSize];

    cubeDataBytes[0] = 0;
    cubeDataBytes[1] = 0;
    cubeDataBytes[2] = 0;
    cubeDataBytes[3] = 0;
    
    cubeDataBytes[4] = 60;
    cubeDataBytes[5] = 0;
    cubeDataBytes[6] = 0;
    cubeDataBytes[7] = 180;
 
    cubeDataBytes[8] = 80;
    cubeDataBytes[9] = 0;
    cubeDataBytes[10] = 0;
    cubeDataBytes[11] = 190;
    
    cubeDataBytes[12] = 130;
    cubeDataBytes[13] = 10;
    cubeDataBytes[14] = 0;
    cubeDataBytes[15] = 210;
    
    
    cubeDataBytes[16] = 210;
    cubeDataBytes[17] = 33;
    cubeDataBytes[18] = 15;
    cubeDataBytes[19] = 220;
    
    cubeDataBytes[20] = 220;
    cubeDataBytes[21] = 110;
    cubeDataBytes[22] = 20;
    cubeDataBytes[23] = 230;    
    
    cubeDataBytes[24] = 230;
    cubeDataBytes[25] = 160;
    cubeDataBytes[26] = 30;
    cubeDataBytes[27] = 230;
    
    cubeDataBytes[28] = 255;
    cubeDataBytes[29] = 240;
    cubeDataBytes[30] = 210;
    cubeDataBytes[31] = 240;    
    
    
    for (int i = 32; i < cubeDataSize; i += 4)
    {
        cubeDataBytes[i] = 0;
        cubeDataBytes[i+1] = 0;
        cubeDataBytes[i+2] = 0;
        cubeDataBytes[i+3] = 0;
    }
    */
    /*
    int dimension = 4;  // Must be power of 2, max of 128 (max of 64 on ios)
    int cubeDataSize = 4 * dimension * dimension * dimension;
    
    unsigned char cubeDataBytes[cubeDataSize];
    
    cubeDataBytes[0] = 0;
    cubeDataBytes[1] = 0;
    cubeDataBytes[2] = 0;
    cubeDataBytes[3] = 0;
    
    cubeDataBytes[4] = 60;
    cubeDataBytes[5] = 0;
    cubeDataBytes[6] = 0;
    cubeDataBytes[7] = 200;
    
    cubeDataBytes[8] = 200;
    cubeDataBytes[9] = 160;
    cubeDataBytes[10] = 0;
    cubeDataBytes[11] = 230;
    
    cubeDataBytes[12] = 175;
    cubeDataBytes[13] = 255;
    cubeDataBytes[14] = 207;
    cubeDataBytes[15] = 255;
     
    //burning paper
     cubeDataBytes[0] = 0;
     cubeDataBytes[1] = 0;
     cubeDataBytes[2] = 0;
     cubeDataBytes[3] = 0;
     
     cubeDataBytes[4] = 64;
     cubeDataBytes[5] = 10;
     cubeDataBytes[6] = 0;
     cubeDataBytes[7] = 230;
     
     cubeDataBytes[8] = 190;
     cubeDataBytes[9] = 255;
     cubeDataBytes[10] = 0;
     cubeDataBytes[11] = 230;
     
     cubeDataBytes[12] = 230;
     cubeDataBytes[13] = 255;
     cubeDataBytes[14] = 249;
     cubeDataBytes[15] = 255;
     //
     
     //batman green-yellow-red
     
     cubeDataBytes[4] = 2;  //0
     cubeDataBytes[5] = 30; //37
     cubeDataBytes[6] = 40; //56
     cubeDataBytes[7] = 230;//230
     
     cubeDataBytes[8] = 255;
     cubeDataBytes[9] = 255;
     cubeDataBytes[10] = 0;
     cubeDataBytes[11] = 230;
     
     cubeDataBytes[12] = 255;
     cubeDataBytes[13] = 0;
     cubeDataBytes[14] = 0;
     cubeDataBytes[15] = 255;
     
    
    for (int i = 16; i < cubeDataSize; i += 4)
    {
        cubeDataBytes[i] = 0;
        cubeDataBytes[i+1] = 0;
        cubeDataBytes[i+2] = 0;
        cubeDataBytes[i+3] = 0;
    }
    */
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
    
    
    //CIImage *outputImage= inputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    [self setImage:[UIImage imageWithCGImage:cgImg]];
    
    CGImageRelease(cgImg);
    
}

@end
