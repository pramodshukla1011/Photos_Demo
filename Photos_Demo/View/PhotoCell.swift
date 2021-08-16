//
//  PhotoCell.swift
//  Photos_Demo
//
//  Created by Pramod Shukla on 16/08/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var img : UIImageView!
    
    func configure(media : Media) {
        img.sd_setImage(with: URL(string: media.media), completed: nil)
    }
}
extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
