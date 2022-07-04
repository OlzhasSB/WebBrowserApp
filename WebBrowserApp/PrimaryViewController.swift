//
//  PrimaryViewController.swift
//  WebBrowserApp
//
//  Created by Olzhas on 03.07.2022.
//

import UIKit

struct Site {
    var url: URL?
    var title: String?
}

class PrimaryViewController: UIViewController {

    let segmentedControl = UISegmentedControl (items: ["List","Favourite"])
    let tableView = UITableView()
    
    var list = [
        Site(url: URL(string: "https://www.apple.com"), title: "Apple"),
        Site(url: URL(string: "https://www.google.com/?client=safari"), title: "Google"),
        Site(url: URL(string: "https://www.youtube.com"), title: "YouTube")
    ]
    
    var favSites: [Site] = []
    
    var sites: [Site] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        makeConstraints()
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            sites = list
        } else {
            sites = favSites
        }
        tableView.reloadData()
    }
    
    @objc func addSite() {
        let alert  = UIAlertController(title: "Add website", message: "Fill all the fields", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter title"
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter URL"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [self] (action: UIAlertAction) in
            guard let title = alert.textFields?.first?.text else { return }
            guard let url = alert.textFields?[1].text else { return }
            
            let site = Site(url: URL(string: url), title: title)
            list.append(site)
            tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        title = "Websites"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSite))
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: UIControl.State.normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WebsiteCell.self, forCellReuseIdentifier: "websiteCell")
        sites = list
    }
    
    private func makeConstraints() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}

// MARK: - TableView Delegates

extension PrimaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteCell") as! WebsiteCell
        cell.textLabel?.text = sites[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SecondaryViewController()
        vc.site = sites[indexPath.row]
        vc.delegate = self
    }
}

extension PrimaryViewController: AddSiteDelegate {
    func addToFavourite(_ site: Site) {
        favSites.append(site)
        tableView.reloadData()
    }
}
