//
//  HMViewController.swift
//  HeatMap
//
//  Created by Katerina Nerush on 07/10/2014.
//  Copyright (c) 2014 Katerina Nerush. All rights reserved.
//

import UIKit

class HMViewController : UIViewController {

    var model:HMDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bounds = view.bounds.size

        self.model = HMDataModel(n:100, maxX:bounds.width, maxY:bounds.height)

        self.doTheMagic()
    }

    func doTheMagic() {
        var heatMap = HeatMapImage(frame:view.frame)
        view.addSubview(heatMap)

        heatMap.rerenderHeatmap(self.model!.data)
    }
}
