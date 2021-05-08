//
//  MGLPolyLine + RiverRoutesAnnotations.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 8.05.21.
//

import Foundation
import Mapbox

extension MGLPolyline {
    
    func returnRoutesPolylineAnnotationsArray() -> [MGLPolyline] {
        
        let viliaRoute = MGLPolyline(coordinates: RiversRoutesCoordinates.viliaRoutesCoordinates, count: UInt(RiversRoutesCoordinates.viliaRoutesCoordinates.count))
        viliaRoute.title = "Vilia Route"
        
        let berezinaRoute = MGLPolyline(coordinates: RiversRoutesCoordinates.berezinaCoordinates, count: UInt(RiversRoutesCoordinates.berezinaCoordinates.count))
        berezinaRoute.title = "Berezina Route"
        
        return [viliaRoute, berezinaRoute]
    }
}
