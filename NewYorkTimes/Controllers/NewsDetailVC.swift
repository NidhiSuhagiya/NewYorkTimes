//
//  NewsDetailVC.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit

class NewsDetailVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var seeMoreBtn: UIButton!
    @IBOutlet weak var newsSectionLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsDescriptionLbl: UILabel!
    @IBOutlet weak var publishedDateTimeLbl: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newsDetail: NewsResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNavBar()
        self.setUI()
        self.setNewsData()
    }
    
    private func setNavBar() {
        self.navigationItem.title = "The New York Times"
        self.navigationItem.backButtonTitle = ""
    }
    
    private func setUI() {
        self.imageView.layer.cornerRadius = 15
        self.activityIndicator.hidesWhenStopped = true
    }
    
    //    Set news data
    private func setNewsData() {
        guard let newsData = newsDetail else { return }
        activityIndicator.startAnimating()
        
        if let url = newsData.url, url.count == 0 {
            self.seeMoreBtn.isHidden = true
        }
        
        self.newsSectionLbl.text = newsData.section?.uppercased()
        self.newsTitleLbl.text = newsData.title
        self.newsDescriptionLbl.text = newsData.abstract
        self.publishedDateTimeLbl.text = newsData.formattedPublishedDate
        self.authorNameLbl.text = newsData.authorName
        
        //        Load image from the url if it exist otherwise set placeholder image
        if let mediaArr = newsData.multimedia, let index = mediaArr.firstIndex(where: { item in
            item.format == ImageFormat.largeImage.description
        }) {
            let largeImgData = mediaArr[index]
            if let url = URL(string: largeImgData.url!) {
                self.loadImage(url: url)
            }
        } else {
            self.activityIndicator.stopAnimating()
            self.imageView.image = UIImage(named: "placeholder_bg")
        }
    }
    
    //    Load image from the given url
    func loadImage(url: URL) {
        //    UUID returned by the loader is stored in a constant
        let _ = ImageLoader.sharedInstance.loadImage(url) { result in
            switch result {
            case .success(let img):
                //            On success, display image using main thread
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = img
                }
            case .failure(let error):
                //            On failure, Set default placeholder image
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = UIImage(named: "placeholder_bg")
                }
                //            On failure, print the error
                print("Error in fetching images: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func seeMoreNewsBtnPressed(_ sender: Any) {
        self.readMoreNews()
    }
    
    private func readMoreNews() {
        guard let newsData = newsDetail, let url = newsData.url, url.count > 0 else {
            return
        }
        let webViewVC = mainStoryBoard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        webViewVC.newsBlogUrl = url
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
}

