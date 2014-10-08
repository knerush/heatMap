//
//  HeatMapImage.h
//  CoreImageFilterTest01
//
//  Created by KN on 07/07/2014.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeatMapImage : UIImageView

@property CGSize resolution;
@property CGFloat radius;
@property CGFloat gamma;

@property Boolean useStencil;

//array of CGPoints
-(void) rerenderHeatmap:(NSArray *)pointsArray;

@end
