//
//  ViewController.swift
//  WeatherApp
//
//  Created by Павел on 02.10.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var temperatureLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))&appid=5ae9f27280f8aaedaaac1083a474266b"
        let url = URL.init(string: urlString)
        
        var locationName: String?
        var temperature: Double?
        var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let _ = json["message"] {
                    errorHasOccured = true
                }
                if let main = json["main"] {
                    temperature = main["temp"] as? Double
                }
                if let _ = json["name"] {
                locationName = json["name"] as? String
                }
                                
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLable.text = "Error has occrured"
                        self?.temperatureLable.isHidden = true
                        
                    } else {
                        self?.cityLable.text = locationName
                        self?.temperatureLable.text = String(format: "%.2f", temperature! - 273) + "C"
                        
                        self?.temperatureLable.isHidden = false
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}

