//
//  AppStoreItemController.swift
//  iTunesSearchAPI_iOS22
//
//  Created by Ivan Ramirez on 10/18/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class AppStoreItemController {
    
    // example of built URL
    //
    //https://itunes.apple.com/search?term=Kanye&entity=musicTrack
    
    static func fetchItemsOf(type: AppStoreItem.itemType, searchText: String, completion: @escaping ([AppStoreItem]) -> Void) {
        
        guard let baseURL = URL(string: "https://itunes.apple.com/search"),
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
                print("\n\nOur URL is not working\n\n")
                completion([]); return
        }
        
        print("\n\nThe base URL \(baseURL.absoluteString)\n\n")
        
        // THe name String is the key. On iTunes documentation for the API, the 'Parameter Key' is "term"
        let searchTermQuery = URLQueryItem(name: "term", value: searchText)
        
        // iTuens documentation: 'Parameter Key' is "entity" -> software
        // "type.rawValue" its coming from our enum
        let entityQuery = URLQueryItem(name: "entity", value: type.rawValue)
        
        // "queryItems" is an array. the query parameters need to be in the correct ordered
        components.queryItems = [searchTermQuery, entityQuery]
        //test what oure URL is at this point
        
        //**
        print(components.url ?? "\n\nThere's an issue with the URL, could be emtpy \n\n")
        //**
        
        guard let url = components.url else {
            print("\n\nOur query items are causing trouble\n\n")
            completion([]); return
        }
        
        // MARK: - URLSession
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("\n\n⭕️ There was an error with getting info back from Apple in:\(#function); \n\(error); \n\(error.localizedDescription) ❌\n\n")
                completion([]); return
            }
            guard let data = data else{
                print("\n\n No Data Received by Appl\n")
                completion([]); return
                
            }
            
            guard let topLevelJSON = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any] else {
                print("\n\nCOuld not convert data into JSON\n")
                completion ([])
                return
            }
            
            // NOTE: - "results" is in the JSON dictionary
            guard let appStoreItemDictionaries = topLevelJSON["results"] as? [[String:Any]] else {
                print("\n\nCould not get dictionaries from the results\n")
                completion([]); return
            }
            
            // NOTE: Part 1 - This will be our container
            var allItems: [AppStoreItem] = []
            
            // NOTE: PART 2- This is going to to filter through our dictioanries and get what we want
            for itemDictionary in appStoreItemDictionaries {
                if let newItemsWeGotFromTheWeb = AppStoreItem(itemType: type, dict: itemDictionary) {
                    allItems.append(newItemsWeGotFromTheWeb)
                }
            }
            // All items is an array of newItemsWeGotFromTheWeb
            completion(allItems)
            }.resume()
        
    }//👩🏽‍🚒
}//🔥

extension AppStoreItemController {
    
    static func fetchImageFromTheWeb(item: AppStoreItem, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageURLAsString = item.imageURL,
            imageURLAsString != "none",
            let url = URL(string: imageURLAsString)
            else {
                print("\n\n Item did not have an Image that Could be made into a URL")
                // no longer a completion of an array ([]) like above
                let errorImage = UIImage(named: "myLife")
                completion(errorImage); return
        }
        
        // NOTE: - This is a 'dataTask(with: 'URL'.....). No Longer Request
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("\n\n🚀 There was an error with data task in:\(#function); \n\(error); \n\(error.localizedDescription) 🚀\n\n")
                completion(nil); return
            }
            
            guard let data = data else {
                print("\n\nCould not get back an image\n")
                completion(nil); return
            }
            
            let image = UIImage(data: data)
            completion(image)
            
            }.resume()
    }
}//🍕

