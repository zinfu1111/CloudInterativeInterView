//
//  HomeViewController.swift
//  CloudInterativeInterView
//
//  Created by 連振甫 on 2021/4/14.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var photoCollectionView:UICollectionView!
    
    var spinner = UIActivityIndicatorView()
    var data:[Photo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.photoCollectionView.register(UINib(nibName:"PhotoLibraryCell",bundle: nil), forCellWithReuseIdentifier: "PhotoLibraryCell")
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        view.addSubview(spinner)
        
        //旋轉視圖的約束條件
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        //啟用旋轉視圖
        spinner.startAnimating()
        
        
        
        refreshData()
    }
    
    func refreshData() {
        
        DataManager.shared.queryData(completionHandler: { data in
            DispatchQueue.main.async {
                self.data = data
                self.photoCollectionView.reloadData()
                self.spinner.stopAnimating()
            }
        })
    }
    
}

//MARK: - CollectionViewProtocol

extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCell", for: indexPath) as! PhotoLibraryCell
        
        let photo = data[indexPath.row]
        
        
        cell.titleLabel.text = String((photo.id ?? 0))
        cell.subtitleLabel.text = photo.title ?? ""
        cell.spinner.hidesWhenStopped = true
        cell.spinner.startAnimating()
        if let imgUrl = URL(string: photo.thumbnailUrl ?? "") {
            RestManager.shared.fetchImage(url: imgUrl, completionHandler: {[weak self] (image) in
                guard self != nil else { return }
                DispatchQueue.main.async {
                    cell.spinner.stopAnimating()
                    cell.thubnailImageView.image = image
                }
            })
        }
        
        return cell
        
        
    }
    
}


// MARK: - 設定間距、距確 Super View 的距離
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
