//
//  ViewController.swift
//  TAbleViewLeoosnEzDev
//  Created by Andrew on 07.09.2023.

import UIKit

class MyTableView: UITableView  {
    
}


//MARK: ViewController
class ViewController: UIViewController {
    let imageCache = NSCache<NSString, UIImage > ()
    let tableView = UITableView()
    
    //	let tableView = MyTableView()
    
    
    private var models: [Cat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCats()
        setupTableView()
        setupBinding()
    }
    
    private func setupTableView() {
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifire)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
    }
    
    private func setupBinding() {
        view.addSubview(tableView)
    }
    
    private func loadCats() {
        DispatchQueue.global().async {
            //			for _ in 0...50 {
            Network.getCats(str: Endpoints.defaultEndpoint.rawValue) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let cats):
                    DispatchQueue.main.async {
                        self.models.append(contentsOf: cats)
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
            //			}
        }
    }
    
    private func loadImage(_ url: String, image: UIImageView) {
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            image.image = cachedImage
            return
        }
        DispatchQueue.global(qos: .utility).async {
            if let imageUrl = URL(string: url),
               let data = try? Data(contentsOf: imageUrl),
               let downloadedImage = UIImage(data: data) {
                
                // Cache the downloaded image
                DispatchQueue.main.async { [self] in
                    imageCache.setObject(downloadedImage, forKey: imageUrl.absoluteString as NSString)
                    image.image = downloadedImage
                }
            }
        }
    }
}
    // MARK: ViewController: UITableViewDataSource
    extension ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { models.count }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseIdentifire, for: indexPath) as? CustomCell else {
                return UITableViewCell()
            }
            if models.count < indexPath.row {
                loadImage(models[indexPath.row].url, image: cell.imageCell)
            }
                return cell
        }
    }
    extension ViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 150 }
    }
    
