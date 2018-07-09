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
            
            self.id = id as! Int
            self.title = title as! String
            
            if let image = (json["poster_path"] as? String) {
                self.image = image
            }else{
                self.image = ""
            }
      
        }else{
            return nil
        }
    }
}
