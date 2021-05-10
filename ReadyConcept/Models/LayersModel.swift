//
//  LayersModel.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 5.05.21.
//

import Foundation

class LayersModel: NSObject {
    var layersName: String
    var isSelected: Bool
    
    init(name: String, selected: Bool) {
        layersName = name
        isSelected = selected
    }
}
