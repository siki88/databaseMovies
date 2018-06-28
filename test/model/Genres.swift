//
//  Genres.swift
//  test
//
//  Created by Lukas Spurny on 27.06.18.
//  Copyright © 2018 spurny.lukas@post.cz. All rights reserved.
//

import Foundation

class Genres {
    var id:Int?
    var name:String?
    
    init(id:Int,
         name:String){
        
        self.id = id
        self.name = name

    }
    init?(json: [String:Any]){
        if let id = json["id"],
            let name = json["name"]{
            
            self.id = id as? Int
            self.name = name as? String
            
        }else{
            return nil
        }
    }
}
