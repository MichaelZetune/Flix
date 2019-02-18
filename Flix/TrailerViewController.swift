//
//  TrailerViewController.swift
//  Flix
//
//  Created by Michael Zetune on 2/15/19.
//  Copyright © 2019 Michael Zetune. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var movie: [String: Any]!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieId = movie["id"] as! Int
        print("MOVIEID: \(movieId)")
        let youtubeBaseUrl = "https://www.youtube.com/watch?v="
        
        let requestUrl = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: requestUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let videos = dataDictionary["results"] as! [[String: Any]]
                let trailerVideo = videos[0]
                let trailerVideoKey = trailerVideo["key"] as! String
                let fullURL = "\(youtubeBaseUrl)\(trailerVideoKey)"
                let trailerRequestUrl = URL(string: fullURL)!
                let trailerRequest = URLRequest(url: trailerRequestUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                self.webView.load(trailerRequest)
            }
        }
        task.resume()
        

        // Do any additional setup after loading the view.
    }
}
