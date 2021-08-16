//
//  ViewController.swift
//  Photos_Demo
//
//  Created by Pramod Shukla on 16/08/21.
//

import UIKit
import ImageViewer_swift

class PhotoGallaryVC: UIViewController {

    //MARK:- IBoutlets
    @IBOutlet weak var photoCollectionVIew : UICollectionView!
    
    //MARK: - Properties
      var photoArr = [Media]()
    
    //MARK: View life Cycel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getPhotoData_ApiCall()
    }
    
    //MARK:- API CALL
    
    func getPhotoData_ApiCall()  {
        if !InternetConnectionManager.isConnectedToNetwork(){
            self.showAlertWith(message: AlertMessage.init(title: "Alert", body: "Please check your internet connection."))
            return
        }
        LoadingOverlay.shared.showOverlay(view: self.view)
        NetworkManager.shared.dataTask(serviceURL: "fetch-images", httpMethod: .post, parameters: ["user_id" : "cWeIJ16047629128AfCp"]) { (response, error) in
            LoadingOverlay.shared.hideOverlayView()
            if error != nil {
                print("Error Occoured")
                return
            }
            if let photo = response as? Photo{
                if photo.status == "success"{
                    self.photoArr = photo.media
                }
                DispatchQueue.main.async {
                    self.photoCollectionVIew.reloadData()
                }
               
            }
            
        }
    }

}

//MARK:- UICollectionView Delegate and datasource

extension PhotoGallaryVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoCell  = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        cell.configure(media: photoArr[indexPath.item])
        cell.img.setupImageViewer(urls: photoArr.map({URL(string: $0.media)!}), initialIndex: indexPath.item, options: [], placeholder: nil, from: self)
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth: CGFloat = UIScreen.main.bounds.width
        // Replace photoMedias.count with the number of cells in one row
        // if that changes or if a row is not constrained to a single line
        let cellWidth: CGFloat = (collectionViewWidth - 8) / CGFloat(photoArr.count)

        // Replace the divisor with the column count requirement. Make sure to have it in float.
        let size: CGSize = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
    
}
