//
//  HeatMapImage.h
//  CoreImageFilterTest01
//
//  Created by KN on 07/07/2014.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeatMapImage : UIImageView

@property(assign, readwrite) CGSize resolution;
@property(assign, readwrite) CGFloat radius;
@property(assign, readwrite) CGFloat gamma;
@property(assign, readwrite) Boolean useStencil;

//array of CGPoints
-(void) rerenderHeatmap:(NSArray *)pointsArray;

@end
