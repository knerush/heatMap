//
//  HMViewController.swift
//  HeatMap
//
//  Created by Katerina Nerush on 07/10/2014.
//  Copyright (c) 2014 Katerina Nerush. All rights reserved.
//

import UIKit

class HMViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bounds = view.bounds.size
        var model = HMDataModel(n:100, maxX:bounds.width, maxY:bounds.height)
        
//        run in separate thread
        var heatMap = HeatMapImage(frame:view.frame)
        view.addSubview(heatMap)
        heatMap.rerenderHeatmap(model.data)
    }
    
    // MARK: - private functions

//    -(void)configureHeatmapView:(NSArray *)heatmapData
//    {
//    self.heatMapRendererView = [[HeatMapImage alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:self.heatMapRendererView];
//    
//    self.heatMapRendererView.resolution =
//    CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//    
//    self.heatMapRendererView.radius = 0.05;
//    self.heatMapRendererView.gamma = 2.5;
//    
//    [self.view addSubview:self.spinner];
//    
//    if (heatmapData.count > 0)
//    [self.heatMapRendererView rerenderHeatmap:heatmapData];
//    
//    [self.spinner removeFromSuperview];
//    }


}
