//
//  MainTableViewController.swift
//  iTunesSearchAPI_iOS22
//
//  Created by Ivan Ramirez on 10/18/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBarOutLet: UISearchBar!
    @IBOutlet weak var segmentedButtons: UISegmentedControl!
    
    // NOTE: different way to do this, usually we put it in the controller
    var appStoreItems: [AppStoreItem] = []
    
    // MARK: - Life Cyles
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarOutLet.delegate = self
       
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return appStoreItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itunesItemCell", for: indexPath) as? ItunesItemTableViewCell else {return UITableViewCell()}
        
        let appStoreItem = appStoreItems[indexPath.row]
        cell.item = appStoreItem
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}//🔥


extension MainTableViewController: UISearchBarDelegate {
    // MARK Functions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBarOutLet.text, !searchText.isEmpty else {return}
        searchBarOutLet.resignFirstResponder()
        // if its 0 use the music segmented option, if its not 0 use the app option
        
        let itemType: AppStoreItem.itemType = (segmentedButtons.selectedSegmentIndex == 0) ? .song : .app
        
        AppStoreItemController.fetchItemsOf(type: itemType, searchText: searchText) { (items) in
            
            print(items.count)
            self.appStoreItems = items
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchBarOutLet.text = ""
            }
        }
    }
}

