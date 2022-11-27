//
//  ViewController.swift
//  CuteKittens
//
//  Created by Neely Rhaego on 11/12/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let networker = NetworkManager.shared
    var posts: [Post] = []
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        setupViews()
        setupLayouts()
        populateData()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self //??
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }

    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `collectionView`
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as?  ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let post = posts[indexPath.item]
        
        let representedIdentifier = post.id
        cell.representedIdentifier = representedIdentifier
        cell.titleLabel.textColor = .black
        cell.titleLabel.text = post.description ?? "No description"
        
        func image(data: Data?) -> UIImage? {
            if let data = data {
                return UIImage(data: data)
            }
            return UIImage(systemName: "picture")
        }
        
       
        
        networker.image(post: post) { data, error in
            let img = image(data: data)
            DispatchQueue.main.async {
                if (cell.representedIdentifier == representedIdentifier) {
                    cell.imageView.image = img
                }
            }
        }
        
        
        
        networker.profileImage(post: post) { data, error in
            let img = image(data: data)
            DispatchQueue.main.async {
                if (cell.representedIdentifier == representedIdentifier) {
                    cell.badgeImageView.image = img
                }
            }
        }
        return cell
    }
    
    func endOfScrollView (_ collectionView: UIScrollView) {
            if !networker.fetchingMore {
                populateData()
            }
    }
    
    func populateData () {
        networker.fetchingMore = true
        networker.pageNumber += 1
        networker.posts(query: "Abyssinian kitten") { [weak self] posts, error in
            if let error = error {
                print("error", error)
                return
            }
            
            guard let posts = posts else { return }

            DispatchQueue.main.async {
                self?.posts += posts
                self?.collectionView.reloadData()
                NetworkManager.shared.fetchingMore = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == posts.count - 1 {
            endOfScrollView(collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 36, height: view.frame.width - 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
    
}
