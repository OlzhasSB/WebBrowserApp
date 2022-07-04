//
//  SecondaryViewController.swift
//  WebBrowserApp
//
//  Created by Olzhas on 03.07.2022.
//

import UIKit
import WebKit

protocol AddSiteDelegate: AnyObject {
    func addToFavourite(_ site: Site)
}

class SecondaryViewController: UIViewController {

    let webView = WKWebView()
    let label = UILabel()
    
    weak var delegate: AddSiteDelegate?

    var site: Site? {
        didSet {
            webView.load(URLRequest(url: (site?.url)!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        webView.load(URLRequest(url: URL(string: "https://www.youtube.com")!))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        webView.addGestureRecognizer(tap)
    }
    
    @objc func doubleTapped() {
        delegate?.addToFavourite(site!)
    }

}
