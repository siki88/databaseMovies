//
//  detailMovieViewController.swift
//  test
//
//  Created by Lukas Spurny on 27.06.18.
//  Copyright © 2018 spurny.lukas@post.cz. All rights reserved.
//

import UIKit
import Alamofire
import XCDYouTubeKit

class detailMovieViewController: UIViewController, MovieDetailListener{
  
    var idMovie:Int?
    var idYoutube:String?
    var language:String = ""
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGeneres: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    @IBOutlet weak var watchTrailer: UIButton!
    @IBAction func watchTrailerFunc(_ sender: Any) {
        if self.idYoutube == nil {
            alert(title:"Trailer není dostupný",message:"")
        }else{
        let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: self.idYoutube)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayerPlaybackDidFinish(_:)), name: .MPMoviePlayerPlaybackDidFinish, object: videoPlayerViewController.moviePlayer)
        presentMoviePlayerViewControllerAnimated(videoPlayerViewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //activity indicator start
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if let selectLanguage = UserDefaults.standard.object(forKey: "selectLanguage") as? String,UserDefaults.standard.object(forKey: "selectLanguage") as? String != "", selectLanguage != "" {
            self.language = "&language=\(selectLanguage)"
        }
        
        if let idSingleMovie = self.idMovie, self.idMovie != nil {
            API.getMovieDetail(selectLanguage: self.language,idMovie: idSingleMovie, completionHandler: self)
            API.loadIDFormMovie(idMovie: idSingleMovie, completionHandler: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     activityIndicator.stopAnimating()
    }
    
    
    
    // MARK: XCDYouTubeKit  !!!!! WARNING !!!!! - eprecated !!!!
    @objc func moviePlayerPlaybackDidFinish(_ notification: Notification?) {
        NotificationCenter.default.removeObserver(self, name: .MPMoviePlayerPlaybackDidFinish, object: notification?.object)
        let finishReason = MPMovieFinishReason(rawValue: Int(notification?.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! Int ))
        if finishReason == .playbackError {
            let error = notification?.userInfo![XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey] as? Error
            print("error: \(String(describing: error))")
        }
    }
    
    // MARK: REQUEST ON YOUTUBE ID
    func loadIDFormMovie(trailers: [Trailers]) {
        if trailers.count == 0 {
            navigationController?.popViewController(animated: true)
        }else{
            if trailers[0].key == nil {
                self.watchTrailer.isHidden = true
            }else{
                self.idYoutube = trailers[0].key    // FIRST ID !!!
            }
        }
    }
    
    // MARK: MAIN EXTRACT
    func getMovieDetail(movie: Movie) {
        
        if let image = movie.image {
            alamofireImage(movieImage: image)
        }
        self.movieTitle.text = movie.title
        self.movieGeneres.text = genresFunc(movieGenres: movie.genres)
        if let date = movie.date, date != "" {
            self.movieDate.text =  convertDateFormater(date)
        }
        self.movieOverview.text = movie.overview
    }
    
    
    // MARK: ALAMOFIRE - IMAGE
    func alamofireImage(movieImage:String){
    
        if movieImage != "" {
            let imageAlamo = ("https://image.tmdb.org/t/p/w342\(String(describing: movieImage))")
            Alamofire.request(imageAlamo).responseImage { response in
                if let image = response.result.value {
                    self.movieImage.image = image
                }
            }
        }
    }
    
    // MARK: grouping - generes
    func genresFunc(movieGenres:[String]) -> String {
        
        var generesReturn:String = ""
        for movieGenre in movieGenres { 
            generesReturn += "\(movieGenre),"
        }
        
        return(generesReturn)
    }
    
    // MARK: Date formated:  yyyy-MM-dd -> dd.MM.yyyy
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    //MARK: ALERT
    func alert(title:String,message:String){
        // MARK : START ERROR
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        // MARK : END ERROR
    }
   
}

