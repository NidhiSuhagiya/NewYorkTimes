//
//  NewsCell.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var autherNameLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var onReuse: () -> Void = {}
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        //        Cells are reused quite often so doing the appropriate cleanup in prepareForReuse is crucial to prevent artifacts from old data on a cell from showing up when you don’t want to
        itemImgView.image = nil
    }
    
    func configureCell(newsItem: NewsResults) {
        
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        //        Set title and author name
        self.newsTitleLbl.text = newsItem.title
        let authorName = newsItem.authorName ?? "Unknown"
        self.autherNameLbl.text = ((authorName.count > 0) ? authorName : "Unknown")
        
        //        Load image from the url if it exist otherwise set placeholder image
        DispatchQueue.global().async {
            if let mediaArr = newsItem.multimedia, let index = mediaArr.firstIndex(where: { item in
                item.format == ImageFormat.thumbnail.description
            }) {
                let smallImgData = mediaArr[index]
                if let url = URL(string: smallImgData.url!) {
                    self.loadImage(url: url)
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.itemImgView.image = UIImage(named: "placeholder_bg")
                }
            }
        }
    }
    
    /// Load image from url
    /// - Parameter url: image url
    func loadImage(url: URL) {
        //    UUID returned by the loader is stored in a constant
        let token = ImageLoader.sharedInstance.loadImage(url) { result in
            switch result {
            case .success(let img):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.itemImgView.image = img
                }
            case .failure(let error):
                //            On failure, print the error and set default placeholder image
                print("Error in fetching images: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.itemImgView.image = UIImage(named: "placeholder_bg")
                }
            }
        }
        
        //    Use UUID to cancel the loader’s load operation for that UUID
        self.onReuse = {
            if let token = token {
                ImageLoader.sharedInstance.cancelLoad(token)
            }
        }
        
    }
}
