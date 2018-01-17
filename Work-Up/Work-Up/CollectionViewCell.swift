//
//  CollectionViewCell.swift
//  CardView
//
//  Created by Simone Penna on 16/01/2018.
//  Copyright © 2018 Simone Penna. All rights reserved.
//

import UIKit
import CoreMotion

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var labelScheda: UILabel!
    @IBOutlet weak var labelPeriodo: UILabel!
    
    let shadowLayer = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.white
        
//        self.layer.cornerRadius = 20.0
//        shadowLayer.frame = self.layer.bounds
//        shadowLayer.shadowColor = UIColor.gray.cgColor
//        shadowLayer.shadowRadius = 5.0
//        shadowLayer.shadowOpacity = 1.0
//        shadowLayer.shadowOffset = CGSize.zero
//        shadowLayer.backgroundColor = UIColor.black.cgColor
//        self.layer.addSublayer(shadowLayer)
    }
   
   
  
}
