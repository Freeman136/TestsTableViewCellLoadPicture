//
//  cell.swift
//  CellNEw
//
//  Created by Andrew on 11.09.2023.
//

import UIKit

// MARK: CastomCEll
class CustomCell: UITableViewCell {
    static let reuseIdentifire = "CastomCell"
    private lazy var label = UILabel()
    
	let imageCell = UIImageView()

    private lazy var button: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(someTouch), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.3890899062, green: 0.634764474, blue: 1, alpha: 1)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
	
	// MARK: - LayoutSubView
	override func layoutSubviews() {
		super.layoutSubviews()
		setupLayer()
		setupConstraint()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		print("reuse")
		imageCell.image = nil
//        imageCell.layer.removeAllAnimations()
	}
    
    private func addSubViews() {
        contentView.addSubview(button)
        contentView.addSubview(imageCell)
        contentView.addSubview(label)
    }
    
    
    // MARK: Buttom ACTION
    @objc func someTouch() {
        animateButton()
    }
    
    private func setupLayer() {
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        imageCell.layer.cornerRadius = 20
        imageCell.contentMode = .scaleToFill
        imageCell.layer.masksToBounds = false
        imageCell.layer.shadowColor = UIColor.black.cgColor
        imageCell.layer.shadowOpacity = 0.5
        imageCell.layer.shadowOffset = CGSize(width: 5, height: 5)
        imageCell.clipsToBounds = true

        // MARK: BUTTON
        button.setTitle("Press", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        
    }
    
    private func setupConstraint() {
        // MARK: imageCell
        NSLayoutConstraint.activate([
            imageCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCell.widthAnchor.constraint(equalToConstant: 110),
            imageCell.heightAnchor.constraint(equalToConstant: bounds.height - 5)
        ])
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: bounds.height - 10)
        ])
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            label.heightAnchor.constraint(equalToConstant: bounds.height - 99)
        ])
    }
    
    private func animateButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
			
			if self.button.backgroundColor != .gray {
				self.button.backgroundColor = .gray
			} else {
				self.button.backgroundColor = #colorLiteral(red: 0.3890899062, green: 0.634764474, blue: 1, alpha: 1)
			}
			
        }) { (_) in
            UIView.animate(withDuration: 0.16) {
                self.button.transform = .identity
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
