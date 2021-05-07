//
//  LayersCell.swift
//  ReadyConcept
//
//  Created by Eduard Ivash on 5.05.21.
//

import UIKit

class LayersCell: UITableViewCell {
    
    @IBOutlet weak var layerNameLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(layer: LayersModel) {
        layerNameLabel.text = layer.layersName
        layer.isSelected == true ?  checkmarkButton.setImage(UIImage(named: "checkmark"), for: .normal) :             checkmarkButton.setImage(UIImage(), for: .normal)
    }
}

