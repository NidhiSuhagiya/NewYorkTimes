//
//  ViewController.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit

class NewsController: UIViewController {
    
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    private var newsListViewModel: NewsListViewModel!
    let refreshControl = UIRefreshControl()
    var selectedSection: String = "home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setNavBar()
        self.fetchNews()
    }
    
    private func setUI() {
        menuBar.delegate = self
        //        Configure tableview
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //        Add activity indicator
        self.tableView.backgroundView = activityIndicator
        self.activityIndicator.center = self.tableView.backgroundView!.center
        activityIndicator.hidesWhenStopped = true
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.fetchNews(isRefresh: true)
    }

    //    Set navigation bar
    private func setNavBar() {
        self.navigationItem.title = "The New York Times"
        self.navigationItem.backButtonTitle = ""
    }
    
    //    #MARK: Fetch Top news
    private func fetchNews(isRefresh: Bool = false) {
        if !isRefresh {
            self.newsListViewModel = nil
            self.tableView.reloadData()
            self.tableView.separatorStyle = .none
            activityIndicator.startAnimating()
        }
        NewsWebServices().getTopStories(selectedSection: self.selectedSection) { newsList in
            if let newsArr = newsList {
                self.newsListViewModel = NewsListViewModel(newsList: newsArr)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.activityIndicator.stopAnimating()
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//#MARK: Table view delegate and data source methods
extension NewsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListViewModel == nil ? 0 : newsListViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let item = newsListViewModel.newsAtIndex(indexPath.row)
        cell.configureCell(newsItem: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = newsListViewModel.newsAtIndex(indexPath.row)
        guard let title = item.title, title.count > 0 else { return }
        let detailVC = mainStoryBoard.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        detailVC.newsDetail = item
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//#MARK: MenuBar delegate
extension NewsController: MenuBarDelegate {
    
//    Fetch news based on section selection
    func newsSectionSelected(section: String) {
        self.selectedSection = section
        self.fetchNews()
    }
}
