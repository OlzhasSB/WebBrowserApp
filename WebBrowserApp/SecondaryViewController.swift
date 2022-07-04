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

    private let webView = WKWebView()
    private let indicator = UIActivityIndicatorView()
    
    weak var delegate: AddSiteDelegate?

    var site: Site?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        makeConstraints()
        addGesture()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        webView.navigationDelegate = self
    }
    
    func loadPage() {
        let request = URLRequest(url: (site?.url)!)
        webView.load(request)
    }
    
    @objc private func doubleTapped() {
        if navigationController?.navigationBar.backgroundColor != .yellow {
            navigationController?.navigationBar.backgroundColor = .yellow
        } else {
            navigationController?.navigationBar.backgroundColor = .white
        }
        delegate?.addToFavourite(site!)
    }
    
    private func addGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    private func makeConstraints() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}

// MARK: - Indicator Delegate

extension SecondaryViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
    }
    
}

// MARK: - GestureRecognizer Delegate

extension SecondaryViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
