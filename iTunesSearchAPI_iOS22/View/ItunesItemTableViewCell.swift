//
//  ItunesItemTableViewCell.swift
//  iTunesSearchAPI_iOS22
//
//  Created by Ivan Ramirez on 10/18/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class ItunesItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itunesImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    let errorImage = UIImage(named: "myLife")
    
    // NOTE: - Landing Pad
    var item: AppStoreItem? {
        didSet {
            updateViews()
            fetchImages()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews(){
        guard let item = item else {return}
        titleLabel.text = item.title
        subTitleLabel.text = item.subtitle
        
        // the sizeToFit() is making the text go behind the imageView
        titleLabel.sizeToFit()
        subTitleLabel.sizeToFit()
        
        //Image help from flickering
        //        itunesImageView.image = nil
    }
    
    func fetchImages() {
        guard let item = item else { return }
        AppStoreItemController.fetchImageFromTheWeb(item: item) { (image) in
            
            if let image = image {
                DispatchQueue.main.async {
                    self.itunesImageView.image = image
                }
            }
            //            } else {
            //                if let _ = image ?? nil {
            //                    DispatchQueue.main.async {
            //                        self.itunesImageView.image = self.errorImage
            //                        print("\n\n Image was not there")
            //                    }
            //                }
            //            }
        }
    }
}
//AppStoreItemController.fetchImageFromTheWeb(item: item) { (image) in
//
//    if let image = image {
//        DispatchQueue.main.async {
//            self.itunesImageView.image = image
//        }
//
//    } else {
//
//        DispatchQueue.main.async {
//            if let image =
//                self.itunesImageView.image = self.errorImage
//            print("\n\n Image was not there")
