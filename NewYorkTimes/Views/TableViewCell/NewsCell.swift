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

    var onReuse: () -> Void = {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
//        Cells are reused quite often so doing the appropriate cleanup in prepareForReuse is crucial to prevent artifacts from old data on a cell from showing up when you don’t want to
        itemImgView.image = nil
    }
    
    func configureCell(newsItem: NewsResults) {
        self.newsTitleLbl.text = newsItem.title
        let authorName = newsItem.authorName ?? "Unknown"
        self.autherNameLbl.text = ((authorName.count > 0) ? authorName : "Unknown")
        DispatchQueue.global().async {
            if let mediaArr = newsItem.multimedia, let index = mediaArr.firstIndex(where: { item in
                item.format == ImageFormat.thumbnail.description
            }) {
                let smallImgData = mediaArr[index]
                if let url = URL(string: smallImgData.url!) {
                    self.loadImage(url: url)
                }
//                    , let imgData = try? Data.init(contentsOf: url), let img = UIImage(data: imgData) {
//                    DispatchQueue.main.async {
//                        self.itemImgView.image = img
//                    }
                } else {
                    DispatchQueue.main.async {
                        self.itemImgView.image = UIImage(named: "placeholder_bg")
                    }
                }
            }
            
        }
    
    
func loadImage(url: URL) {
//    UUID returned by the loader is stored in a constant
    let token = ImageLoader.sharedInstance.loadImage(url) { result in
    
        do {
//            Extract the result
            let img = try result.get()
//            On success, display image using main thread
            DispatchQueue.main.async {
                self.itemImgView.image = img
            }
        } catch {
//            On failure, print the error
            print("Error in fetching images: \(error.localizedDescription)")
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
