//
//  LargeViewForImagesVC.swift
//  cityfam
//
//  Created by i mark on 05/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class LargeViewForImagesVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate  {

    //MARK:- Outlets & Properties
    
    @IBOutlet var collectionView: UICollectionView!

    var selectedIndex = IndexPath()
    var userAllPhotosArr = [String]()

    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.scrollToItem(at: selectedIndex, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Collection View delegates & datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userAllPhotosArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:LargeViewForImagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LargeViewForImagesCollectionViewCell
        
        if self.userAllPhotosArr[indexPath.row] != ""{
            cell.largeImageview.sd_setImage(with: URL(string: (userAllPhotosArr[indexPath.row])), placeholderImage: UIImage(named: "user.png"))
            cell.largeImageview.setShowActivityIndicator(true)
            cell.largeImageview.setIndicatorStyle(.gray)
        }
        else{
            cell.largeImageview.image = UIImage(named: "user.png")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.bounds.width), height: (self.collectionView.bounds.height))
    }

    //MARK:- Button Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
