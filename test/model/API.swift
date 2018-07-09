//
//  API.swift
//  test
//
//  Created by Lukas Spurny on 27.06.18.
//  Copyright © 2018 spurny.lukas@post.cz. All rights reserved.
//

import Alamofire

class API {
    
    // MARK: LOAD ID MOVIE
    static func getMovieDetail(selectLanguage: String,idMovie:Int ,completionHandler: MovieDetailListener) {
        if let api_key = UserDefaults.standard.object(forKey: "api_key") as? String {

                let getURL =  URL(string:"https://api.themoviedb.org/3/movie/\(idMovie)?api_key=\(api_key)\(selectLanguage)")
            
                Alamofire.request(getURL!, method: .get, parameters: nil, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        if let movies = response.result.value as? [String:AnyObject]{
                            if let parsenew = Movie(json: movies ){
                                completionHandler.getMovieDetail(movie: parsenew)
                            }else{
                                print("je to null!")
                            }

                        }
                    }
           
        }else{
            //ALERT
            print("ALERT")
        }

    }
    
    
    // MARK: LOAD ID FOR MOVIE - ONLY FIRST ID
    static func loadIDFormMovie(idMovie:Int ,completionHandler: MovieDetailListener){
        if let api_key = UserDefaults.standard.object(forKey: "api_key") as? String {
            
            let urlCategoryFilter = URL(string: "https://api.themoviedb.org/3/movie/\(idMovie)/videos?api_key=\(api_key)")
            
            Alamofire.request(urlCategoryFilter!, method: .get, parameters: nil, encoding: JSONEncoding.default)
                .responseJSON { response in
                    if var trailers = response.result.value as? [String:AnyObject] {
                        if trailers["status_code"]  == nil {
                            var videosResult = [Trailers]()
                            for trailer in (trailers["results"] as? [[String: AnyObject]])! {
                                if let parsenew = Trailers(json: trailer as [String : Any]){
                                    videosResult.append(parsenew)
                                }
                            }
                            completionHandler.loadIDFormMovie(trailers: videosResult)
                        }else{
                            print("video není dostupné")
                        }
                    }
            }
        }
    }
}

protocol MovieDetailListener {
    func getMovieDetail(movie:Movie)
    func loadIDFormMovie(trailers:[Trailers])
}
