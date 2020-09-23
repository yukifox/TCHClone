//
//  NewsMusicCell.swift
//  TCHClone
//
//  Created by Trần Huy on 7/29/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SwiftyGif
class NewsMusicCell: UICollectionViewCell {

    @IBOutlet weak var lblNowPlaying: UILabel!
    @IBOutlet weak var lblActist: UILabel!
    @IBOutlet weak var lblMusic: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgMusic: UIImageView!
    @IBOutlet weak var imgNowPlaying: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.layer.cornerRadius = 5
        viewContainer.clipsToBounds = true
        imgMusic.layer.cornerRadius = 35
        imgMusic.clipsToBounds = true
        self.lblMusic.text = "Dancing With Your Ghost"
        lblActist.text = "Sasha Sloan"
        self.imgMusic.image = #imageLiteral(resourceName: "image_album")
        lblNowPlaying.text = "Now Playing"
        imgMusic.layer.cornerRadius = imgMusic.frame.height / 2
        imgMusic.clipsToBounds = true
        imgMusic.startRotating()
        
        let imageWaveMusic = try! Data(contentsOf: Bundle.main.url(forResource: "resources_images_icons_audio_wave", withExtension: "gif")!)
        imgNowPlaying.image = UIImage.gifImageWithData(imageWaveMusic)
        imgNowPlaying.startAnimatingGif()
        
        
    }

   
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    
}
