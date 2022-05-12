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
    @IBOutlet weak var newsSectionLbl: UILabel!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsDescriptionLbl: UILabel!
    @IBOutlet weak var publishedDateTimeLbl: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var seperationRoundLbl: UILabel! {
        didSet {
            self.seperationRoundLbl.layer.cornerRadius = self.seperationRoundLbl.frame.height / 2
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newsDetail: NewsResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "The New York Times"
        self.navigationItem.backButtonTitle = ""
        self.imageView.layer.cornerRadius = 15
        self.activityIndicator.hidesWhenStopped = true
        self.setNewsData()
    }
    
    //    Set news data
    private func setNewsData() {
        guard let newsData = newsDetail else { return }
        activityIndicator.startAnimating()
        
        self.newsSectionLbl.text = newsData.section?.uppercased()
        self.newsTitleLbl.text = newsData.title
        self.newsDescriptionLbl.text = newsData.abstract
        if let publishedDate = newsData.published_date {
            self.publishedDateTimeLbl.text = self.convertPublishDateToStr(dateStr: publishedDate)
        } else {
            self.publishedDateTimeLbl.text = ""
        }
        self.authorNameLbl.text = newsData.authorName
        if let mediaArr = newsData.multimedia, let index = mediaArr.firstIndex(where: { item in
            item.format == ImageFormat.largeImage.description
        }) {
            let largeImgData = mediaArr[index]
            if let url = URL(string: largeImgData.url!) {
                self.loadImage(url: url)
            }
        }
    }
    
    //    Load image from the given url
    func loadImage(url: URL) {
        //    UUID returned by the loader is stored in a constant
        let token = ImageLoader.sharedInstance.loadImage(url) { result in
            do {
                //            Extract the result
                let img = try result.get()
                //            On success, display image using main thread
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = img
                }
            } catch {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = UIImage(named: "placeholder_img")
                }
                //            On failure, print the error
                print("Error in fetching images: \(error.localizedDescription)")
            }
        }
    }
    
    //    Convert received date string to the custom string (10 May 2022)
    private func convertPublishDateToStr(dateStr: String) -> String {
        //        2022-05-09T04:39:33-04:00
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let convertedDate = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = "dd MMM YYYY"
        let newDateStr = dateFormatter.string(from: convertedDate!)
        return newDateStr
    }
    //APP ID: d16bc33c-751b-41bb-bfdb-7b97fda14f30
    //API KEY: nBAln1lClbtS9K5KPSHcFwzeGnKZOh5I
    
    
    @IBAction func seeMoreNewsBtnPressed(_ sender: Any) {
        self.readMoreNews()
    }
    
    private func readMoreNews() {
        guard let newsData = newsDetail, let url = newsData.url else {
            return
        }
        let webViewVC = mainStoryBoard.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        webViewVC.newsBlogUrl = url
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
}

