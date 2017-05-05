//
//  SeeUserProfileImagesVC.swift
//  cityfam
//
//  Created by i mark on 05/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class SeeUserProfileImagesVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var collectionView: UICollectionView!
    
    var userAllPhotosArr = [String]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Collection View delegates & datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userAllPhotosArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UserAllProfilePhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserAllProfilePhotosCollectionViewCell
        //
        //        let dict = galleryImagesArr[indexPath.row]
        
        
        if self.userAllPhotosArr[indexPath.row] != ""{
            cell.userImageView.sd_setImage(with: URL(string: (userAllPhotosArr[indexPath.row])), placeholderImage: UIImage(named: "user.png"))
            cell.userImageView.setShowActivityIndicator(true)
            cell.userImageView.setIndicatorStyle(.gray)
        }
        else{
            cell.userImageView.image = UIImage(named: "user.png")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.bounds.width/2)-10, height: (self.collectionView.bounds.width/2)-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondViewController =  self.storyboard!.instantiateViewController(withIdentifier: "largeViewForImagesVc") as! LargeViewForImagesVC
        secondViewController.userAllPhotosArr = userAllPhotosArr
        secondViewController.selectedIndex = indexPath
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    //MARK:- button Actions
    @IBAction func backBtnAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)        
    }
    
}
