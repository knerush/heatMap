//
//  HeatMapImage.h
//  CoreImageFilterTest01
//
//  Created by Vlad on 07/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeatMapImage : UIImageView

@property CGSize resolution;
@property CGFloat radius;
@property CGFloat gamma;

@property int maxPointNumber;
@property int startPointNumber;

@property Boolean useStencil;

@property (nonatomic, strong) NSString *stencilImageName;
@property (nonatomic, strong) UIImage *blobImage;

//array of CGPoints
@property (nonatomic,strong) NSArray *pointsArray;

-(void) rerenderHeatmap;

@end
