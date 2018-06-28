//
//  Trailers.swift
//  test
//
//  Created by Lukas Spurny on 28.06.18.
//  Copyright © 2018 spurny.lukas@post.cz. All rights reserved.
//

import Foundation

class Trailers {

    var id:Int?
    var iso_639_1:String?
    var iso_3166_1:String?
    var key:String?
    var name:String?
    var site:String?
    var size:Int?
    var type:String?
    
    init(id:Int,
         iso_639_1:String,
         iso_3166_1:String,
         key:String,
         name:String,
         site:String,
         size:Int,
         type:String){
        
        self.id = id
        self.iso_639_1 = iso_639_1
        self.iso_3166_1 = iso_3166_1
        self.key = key
        self.name = name
        self.site = site
        self.size = size
        self.type = type
        
    }
    init?(json: [String:Any]){
        if let id = json["id"],
            let iso_639_1 = json["iso_639_1"],
            let iso_3166_1 = json["iso_3166_1"],
            let key = json["key"],
            let name = json["name"],
            let site = json["site"],
            let size = json["size"],
            let type = json["type"]{
            
            self.id = id as? Int
            self.iso_639_1 = iso_639_1 as? String
            self.iso_3166_1 = iso_3166_1 as? String
            self.key = key as? String
            self.name = name as? String
            self.site = site as? String
            self.size = size as? Int
            self.type = type as? String
            
        }else{
            return nil
        }
    }
}
