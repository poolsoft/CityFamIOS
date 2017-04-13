//
//  ProfileVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var userNameLbl: UILabelFontSize!
    @IBOutlet var userLocationLbl: UILabelFontSize!
    @IBOutlet var photosBgView: UIViewCustomClass!
    @IBOutlet var seeAllPhotosBtn: UIButtonCustomClass!
    @IBOutlet var addBtn: UIButtonCustomClass!
    @IBOutlet var editBtn: UIButtonFontSize!
    @IBOutlet var addPhotosBtn: UIButtonCustomClass!
    @IBOutlet var manageConnectionBtn: UIButtonCustomClass!
    @IBOutlet var tableView: UITableView!
    
    var profileTableViewArray = ["My Groups", "My Plans", "My Friends"]
    var imagesArray = ["user","user","user","user"]

    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageConnectionBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)

    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: UITableView Delagtes & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return profileTableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabelFontSize
        label.text = profileTableViewArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = UIViewController()
        switch indexPath.row {
        case 0:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "myGroupsVc") as! MyGroupsVC
        case 1:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "myPlansVc") as! MyPlansVC
        case 2:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "myPlansVc") as! MyPlansVC
        default:
            break
        }
        self.navigationController?.pushViewController(obj, animated: true)

    }
    
    //MARK: UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: imagesArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = (collectionView.frame.size.width-30)/4
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }

    
    //MARK:- View life cycle

    
    @IBAction func backBtnAction(_ sender: UIButton) {
    }
    
    func unfriendBtnAction(sender:UIButton){
        
    }
    
    func shareBtnAction(sender:UIButton){
        
    }
    
    func editBtnAction(sender:UIButton){
        
    }
    
    func addBtnAction(sender:UIButton){
        
    }
    

}
