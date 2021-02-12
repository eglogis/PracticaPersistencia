//
//  PhotoCell.swift
//  ProyectoPersistencia
//
//  Created by Samuel Bautista Sánchez on 11/2/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var photo: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo?.image = nil
    }

    func configureViews(image: UIImage?) {
        photo?.image = image
    }
}
