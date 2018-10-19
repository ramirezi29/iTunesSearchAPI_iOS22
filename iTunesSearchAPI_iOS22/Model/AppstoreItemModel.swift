//
//  AppstoreItemModel.swift
//  iTunesSearchAPI_iOS22
//
//  Created by Ivan Ramirez on 10/18/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation

struct AppStoreItem {
    let title: String
    let subtitle: String
    let imageURL: String?
    
    enum itemType: String {
        // now evertime you want music track you just call song
        case song = "musicTrack"
        case app = "software"
    }
}

extension AppStoreItem {
    
    //itemType so we can differeentiate between app and song
    init?(itemType: AppStoreItem.itemType, dict: [String : Any]){
        
        //put outside in order for both options to be able to call upon the imageURL let statement
        if let imageURL = dict["artworkUrl100"] as? String {
            self.imageURL = imageURL
        } else {
            self.imageURL = "none"
        }
        
        //NOTE: - Song
        if itemType == .song{
            
            guard let titleFromDictionary = dict["artistName"] as? String,
                let subtitle = dict["trackName"] as? String else {return nil}
            
            title = titleFromDictionary
            self.subtitle = subtitle
            
            //NOTE: - App
        } else if itemType == .app {
            
            guard let titleFromDictionary = dict["trackName"] as? String,
                let subtitle = dict["description"] as? String else {return nil}
            
            title = titleFromDictionary
            //Now it knows which "title" it is, with out the use of typing in 'Self'
            //self.title = tittitleFromDictionaryle
            self.subtitle = subtitle
            
        } else {
            print("\nforgot to add availablity for other types of items. Sorry Bro")
            return nil
        }
    }
}



