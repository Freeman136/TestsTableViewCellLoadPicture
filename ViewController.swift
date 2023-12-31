//
//  ViewController.swift
//  TAbleViewLeoosnEzDev
//  Created by Andrew on 07.09.2023.

import UIKit


class MyTableView: UITableView {
    var models: [Cat] = []
    let imageCache = NSCache<NSString, UIImage > ()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func loadImage(_ url: String, image: UIImageView) {
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            image.image = cachedImage
            return
        }
    }
        
    private func setup() {
        separatorStyle = .singleLine
        backgroundColor = UIColor.red
        
        register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifire)
        dataSource = self
        delegate = self
        frame = bounds
    }
}

extension MyTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Возвращает количество строк в таблице
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Возвращает ячейку для каждой строки
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseIdentifire, for: indexPath)
        return cell
    }
}



//MARK: ViewController
class ViewController: UIViewController {
    let imageCache = NSCache<NSString, UIImage > ()
    
    let tableView = MyTableView()
    
    
    private var models: [Cat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCats()
        setupBinding()
    }
    
    
    
    private func setupBinding() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            image.image = cachedImage
            return
        }
        DispatchQueue.global(qos: .utility).async {
            if let imageUrl = URL(string: url),
               let data = try? Data(contentsOf: imageUrl),
               let downloadedImage = UIImage(data: data) {
                
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
        loadImage(models[indexPath.row].url, image: cell.imageCell)
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 150 }
}

