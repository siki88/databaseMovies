//
//  CatalogueMovie.swift
//  test
//
//  Created by Lukas Spurny on 27.06.18.
//  Copyright © 2018 spurny.lukas@post.cz. All rights reserved.
//

import Foundation

class CatalogueMovie {
    
    let id: Int
    let title: String
    let image: String
    
    init(id:Int,
         title:String,
         image:String){
        
        self.id = id
        self.title = title
        self.image = image
        
    }
    
    init?(json: [String:Any]){
        if let id = json["id"],
            let title = json["title"]{
            let image = json["poster_path"]
            
            self.id = id as! Int
            self.title = title as! String
            self.image = image as! String
            
        }else{
            return nil
        }
    }
}
