//
//  ViewController.m
//  HeatMap
//
//  Created by Katerina Nerush on 15/09/2014.
//  Copyright (c) 2014 Katerina Nerush. All rights reserved.
//

#import "ViewController.h"
#import "HeatMapImage.h"

@interface ViewController ()
{
    NSArray *dataArray;
}
@property (nonatomic, strong)UIActivityIndicatorView *spinner;
@property (nonatomic, strong)HeatMapImage *heatMapRendererView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //populating random data
    CGSize bounds = self.view.bounds.size;
    dataArray = [self populateRandPointForMaxX:bounds.width andMaxY:bounds.height capacity:100];
    
    [self configureHeatmapView:dataArray];
    
}

-(UIActivityIndicatorView *)spinner
{
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner setBackgroundColor:[UIColor grayColor]];
        _spinner.center = self.view.center;
        [_spinner startAnimating];
    }
    
    return _spinner;
}


-(NSArray *)populateRandPointForMaxX:(CGFloat)max_x andMaxY:(CGFloat)max_y capacity:(int)capacity
{
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:capacity];
    
    for (int i = 0; i < capacity; i++) {
        CGPoint randPoint = CGPointMake(arc4random_uniform(max_x)/max_x, arc4random_uniform(max_y)/max_y);
        [result addObject:[NSValue valueWithCGPoint:randPoint]];
    }
    
    return result;
}

-(void)configureHeatmapView:(NSArray *)heatmapData
{
    self.heatMapRendererView = [[HeatMapImage alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.heatMapRendererView];

    [self.view addSubview:self.spinner];

    self.heatMapRendererView.pointsArray = heatmapData;
    self.heatMapRendererView.radius = 0.0125;
    self.heatMapRendererView.resolution = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);//CGSizeMake(829, 520);
    self.heatMapRendererView.radius = 0.05;
    self.heatMapRendererView.gamma = 2.5;
    self.heatMapRendererView.useStencil =TRUE;
    self.heatMapRendererView.stencilImageName=@"redDot_06.png";
    
    if (heatmapData.count > 0)
        [self.heatMapRendererView rerenderHeatmap];
    
    [self.spinner removeFromSuperview];
}

@end
