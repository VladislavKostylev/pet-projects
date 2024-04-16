//
//  ViewController.swift
//  M17_Concurrency
//
//  Created by Владислав on 10.02.2024
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let service = Service()
    var images: [Data] = []
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var stackWithImages: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 140, height: 140))
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        onLoad()
    }
    
    private func addImage( data: Data) {
        
        let view = UIImageView(image: UIImage (data: data))
        view.contentMode = .scaleAspectFit
        self.stackWithImages.addArrangedSubview(view)
        print("Image is added")
    }
    
    private func onLoad() {
        let dispatchGroup = DispatchGroup()
        for _ in 0 ... 4 {
            dispatchGroup.enter()
            service.getImageURL { urlString, error in
                guard let urlString = urlString else {return}
                let image = self.service.loadImage(urlString: urlString)
                self.images.append(image ?? Data())
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else {return}
            self.activityIndicator.stopAnimating()
            self.stackWithImages.removeArrangedSubview(self.activityIndicator)
            for i in 0 ... 4 {
                self.addImage(data: self.images[i])
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(stackWithImages)
        stackWithImages.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.left.right.equalToSuperview()
        }
        
        stackWithImages.addArrangedSubview(activityIndicator)

        activityIndicator.startAnimating()
    }
}

