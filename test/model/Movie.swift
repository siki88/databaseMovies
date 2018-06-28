//
//  Movie.swift
//  test
//
//  Created by Lukas Spurny on 27.06.18.
//  Copyright © 2018 spurny.lukas@post.cz. All rights reserved.
//

import Foundation

class Movie {
    var id:Int?
    var title:String?
    var image:String?
    var genres:[String] = []
    var date:String?
    var overview:String?
    
    init(id:Int,
         title:String,
         image:String,
         genres:[String],
         date:String,
         overview:String){
        
        self.id = id
        self.title = title
        self.image = image
        self.genres = genres
        self.date = date
        self.overview = overview
        
    }
    init?(json: [String:Any]){
        if let id = json["id"],
            let title = json["title"],
            let image = json["poster_path"],
            let genres = json["genres"],
            let date = json["release_date"],
            let overview = json["overview"]{
            
            self.id = id as? Int
            self.title = title as? String
            self.image = image as? String
            self.date = date as? String
            self.overview = overview as? String
            
            for genre in genres as! [[String:Any]]{
                self.genres.append(genre["name"]! as! String)
            }
        }else{
            return nil
        }
    }
}
