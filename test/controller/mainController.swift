//
//  mainViewController.swift
//  test
//
//  Created by Lukas Spurny on 27.06.18.
//  Copyright © 2018 spurny.lukas@post.cz. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class mainController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var catalogueMovie = [CatalogueMovie]()
    
    var page:Int = 1
    let api_key:String = "bae5ff7bac4feec8604266fabb028a17"
    var idMovie:Int?
    var language:String = ""
    
    var fetchongMore = false  // load on down scroll
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CONTROL CONNECT INTERNET
        if CheckInternet.Connection(){
            
            if let selectLanguage = UserDefaults.standard.object(forKey: "selectLanguage") as? String,UserDefaults.standard.object(forKey: "selectLanguage") as? String != "", selectLanguage != "" {
                self.language = selectLanguage
            }else{
                let alert = UIAlertController(title: "Zvolte jazyk", message: "Select language", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("EN", comment: "Default action"), style: .`default`, handler: { _ in
                    UserDefaults.standard.set("en", forKey: "selectLanguage")
                    self.language = "en"
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("CZ", comment: "Default action"), style: .`default`, handler: { _ in
                    UserDefaults.standard.set("cs", forKey: "selectLanguage")
                    self.language = "cs"
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            //load catalogs
            let urlCategoryFilter = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(self.api_key)&page=\(self.page)&language=\(self.language)")
            requestOnAlamofire(urlCategoryFilter:urlCategoryFilter!)
            
            UserDefaults.standard.set(self.api_key, forKey: "api_key")
        
        }else{
            alert(title:"Připojení k internetu není k dispozici.",message:"Zkuste to prosím později.")
            self.searchBar.isHidden = true
        }
        
        self.searchBar.delegate = self
        self.searchBar.center = self.view.center

    }

    
    //MARK: REQUEST ALAMOFIRE
    func requestOnAlamofire(urlCategoryFilter:URL){
        
        print("URL před odesláním: \(urlCategoryFilter)")
        
        Alamofire.request(urlCategoryFilter, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                if var catalogs = response.result.value as? [String:AnyObject]{
                        for catalog in (catalogs["results"] as? [[String: AnyObject]])! {
                            if let parsenew = CatalogueMovie(json: catalog as [String : Any]){
                                self.catalogueMovie.append(parsenew)
                            }
                        }
                }
                self.tableView.reloadData()
                
                if self.fetchongMore {
                    self.fetchongMore = false
                }
        }
    }
    
    
    // MARK: tableView
    // pocet polí
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogueMovie.count
    }
    
    // vyska jednoho pole
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
       
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableCell", for: indexPath) as! mainTableViewCell
        
        
        if self.catalogueMovie[indexPath.row].title != "" {
            cell.movieTitle.text = self.catalogueMovie[indexPath.row].title
        }else{
            cell.movieTitle.text = "N/A"
        }
        
        // alamofire image
        if self.catalogueMovie[indexPath.row].image != "" {
            let imageAlamo = ("https://image.tmdb.org/t/p/w342\(self.catalogueMovie[indexPath.row].image)")
            Alamofire.request(imageAlamo).responseImage { response in
                if let image = response.result.value {
                    cell.movieImage.image = image
                }
            }
        }else{
            cell.movieImage.image = UIImage(named: "the_movie_db.png")
        }
 
        cell.selectionStyle = .none
        return cell
    }
    
    // zjistiji idecko
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.idMovie = self.catalogueMovie[indexPath.row].id
    }
    
    //MARK: PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailShowSegue" {
            let updateViewController:detailMovieViewController = segue.destination as! detailMovieViewController
            updateViewController.idMovie = self.catalogueMovie[(self.tableView.indexPathForSelectedRow?.row)!].id
        }
    }
    
    //MARK: LOAD NEXT PAGE
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.height {
            if !self.fetchongMore{
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch(){
        print("self.fetchongMore \(self.fetchongMore) AND self.page \(self.page )")
        self.fetchongMore = true
        
        var urlCategoryFilter:URL?
        if let searchBarText = self.searchBar.text,self.searchBar.text != "", searchBarText != "" {
            urlCategoryFilter = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(self.api_key)&page=\(self.page)&language=\(self.language)&query=\(searchBarText)")
        }else{
            urlCategoryFilter = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(self.api_key)&page=\(self.page)&language=\(self.language)")
        }

        self.page = self.page + 1
        requestOnAlamofire(urlCategoryFilter:urlCategoryFilter!)
        
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
    
    //MARK: search function
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.page = 1
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.tableView.reloadData()
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if let searchBarText =  self.searchBar.text,!self.searchBar.text!.isEmpty {
            self.catalogueMovie.removeAll()
            let urlCategoryFilter = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(self.api_key)&page=1&language=\(self.language)&query=\(searchBarText)")
            self.page = 2
            requestOnAlamofire(urlCategoryFilter:urlCategoryFilter!)
        }else{
            print("!self.searchBar.text!.isEmpty else")
            self.catalogueMovie.removeAll()
            let urlCategoryFilter = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(self.api_key)&page=1&language=\(self.language)")
            requestOnAlamofire(urlCategoryFilter:urlCategoryFilter!)
        }
    }
    
}
