//
//  HMDataModel.swift
//  HeatMap
//
//  Created by Katerina Nerush on 07/10/2014.
//  Copyright (c) 2014 Katerina Nerush. All rights reserved.
//

import UIKit

class HMDataModel: NSObject {
   
    var data:[NSValue]!
    
    init(n:Int = 0, maxX: CGFloat, maxY:CGFloat) {
        super.init()
        
        var result : [NSValue] = []
        for(var i:Int = 0; i < n; i++)
        {
            var randomX = CGFloat(arc4random_uniform(UInt32(maxX)))/maxX
            var randomY = CGFloat(arc4random_uniform(UInt32(maxY)))/maxY
            
            var p = NSValue(CGPoint: CGPoint(x: randomX, y: randomY))//
            
            result.append(p)
        }
        
        self.data = result
    }
    
//    lazy var data: [CGPoint] = self.randomPointsInRange()
//
////  MARK: - private functions
//    func randomPointsInRange() -> [CGPoint] {
//            var result : [CGPoint] = []
//            
//            for(var i:Int = 0; i < n; i++)
//            {
//                var randomX = CGFloat(arc4random_uniform(maxX))///(CGFloat(maxX))
//                var randomY = CGFloat(arc4random_uniform(maxY))///(CGFloat(maxY))
//                
//                var p = CGPoint(x: randomX, y: randomY)
//                
//                result[i] = p
//            }
//
//        return result
//    }
    
    
}
