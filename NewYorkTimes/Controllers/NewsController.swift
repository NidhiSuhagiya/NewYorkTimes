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
    @IBOutlet weak var noDataFoundLbl: UILabel!
    
    //    private var newsListViewModel: NewsListViewModel!
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
        newsListViewModel = NewsListViewModel()
        menuBar.delegate = self
        //        Configure tableview
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: NewsCell.self), bundle: nil), forCellReuseIdentifier: NewsCell.reuseIdentifier)
        
        //        Add activity indicator
        self.tableView.backgroundView = activityIndicator
        self.activityIndicator.center = self.tableView.backgroundView!.center
        activityIndicator.hidesWhenStopped = true
        
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
    
    /// Fetch top news
    /// - Parameter isRefresh: Used to clear the existing data to fetch new data from server based on section, if it is false otherwisr just refresh the existing section data
    private func fetchNews(isRefresh: Bool = false) {
        if !isRefresh {
            self.newsListViewModel.clearNewsListToLoadNewSection()
            self.tableView.reloadData()
            self.tableView.separatorStyle = .none
            activityIndicator.startAnimating()
        }
        newsListViewModel.fetchNews(selectedSection: self.selectedSection) { newsList in
            self.updateUI()
        }
    }
    
    //    Update UI after fetching the news from server
    private func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.tableView.separatorStyle = self.newsListViewModel.isNewsListEmpty ? .none : .singleLine
            self.noDataFoundLbl.isHidden = !self.newsListViewModel.isNewsListEmpty
        }
    }
}

//#MARK: Table view delegate and data source methods
extension NewsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListViewModel.numberOfRows//newsListViewModel == nil ? 0 : newsListViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as! NewsCell
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
