//
//  PhotoCell.swift
//  Photo Info
//
//  Created by Pawan kumar on 28/05/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    //@IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    //@IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
