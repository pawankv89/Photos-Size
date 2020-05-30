//
//  ViewController.swift
//  Photo Info
//
//  Created by Pawan kumar on 28/05/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberofimagesLabel: UILabel!
    
    var allPhotos : PHFetchResult<PHAsset>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let listCellNib = UINib(nibName: PhotoCell.identifier, bundle: nil)
            self.collectionView.register(listCellNib, forCellWithReuseIdentifier: PhotoCell.identifier)
                   
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
                    
            //FlowLayout for Managed Grid and List
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical //.horizontal
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            layout.minimumLineSpacing = 5.0
            layout.minimumInteritemSpacing = 5.0
            self.collectionView.setCollectionViewLayout(layout, animated: true)
                
            self.numberofimagesLabel.text = ""
        
            //Reload List items
            self.reload_list()
            
            self.loadPhotoTapped()
    }
    
    func reload_list() {
           
           DispatchQueue.main.async {
               
               self.collectionView.reloadData()
           }
       }
}

//#MARK:- TableView DataSource & Delegate

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
        if allPhotos == nil
        {
            return 0
        }
        return allPhotos!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        //For List & For Grid ( 1 -> List & 2 -> Grid)
        let cellWidth: CGFloat = self.collectionView.frame.size.width / 2  - 10
        //let cellheight: CGFloat = self.collectionView.frame.size.height / 3 - 6 //150
        let cellheight: CGFloat = 180
        let cellSize = CGSize(width: cellWidth , height: cellheight)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath as IndexPath) as! PhotoCell
        
        let asset = allPhotos?.object(at: indexPath.row)
        //cell.photoImageView.fetchImage(asset: asset!, contentMode: .aspectFit, targetSize: cell.photoImageView.frame.size)
        
        //Set Cell Data
        self.getPhotoDetailsWithImage(asset: asset!, cell: cell)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
           //let serviceItem = itemsList[indexPath.row]
           //print("didSelectItemAt:-\(indexPath.row) \(serviceItem)")
           
       }
}

extension UIImageView{
 func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
    let options = PHImageRequestOptions()
    options.version = .original
    PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
        guard let image = image else { return }
        switch contentMode {
        case .aspectFill:
            self.contentMode = .scaleAspectFill
        case .aspectFit:
            self.contentMode = .scaleAspectFit
        }
        self.image = image
    }
   }
}

extension ViewController {
    
    @IBAction func loadPhotoTapped( ) {
          
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            print("OKAY 1")
            self.fetchPhotos()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    print("OKAY 2")
                    self.fetchPhotos()
                } else if status == .notDetermined {
                     print("OKAY 3")
                } else if status == .denied {
                    print("OKAY 4")
                } else if status == .restricted {
                    print("OKAY 5")
                }
            })
        }
    }
    
    func fetchPhotos() -> () {
        
        let fetchOptions = PHFetchOptions()
       
        //Sort Options
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        //mediaType Options
        //fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        print("Found number of:  \(allPhotos!.count) images")
        
        self.numberofimagesLabel.text = "Found number of:  \(allPhotos!.count) images"
        
        //Reload List items
        self.reload_list()
    }
    
    func getPhotoDetailsWithImage(asset: PHAsset, cell: PhotoCell) {
        
        print("PHAsset Original Filename ", asset.originalFilename)
        
        // Creation Date
        let creationDate = asset.creationDate
        let creationDateString: String = (creationDate?.toString(dateFormat: "dd-MMM-yyyy hh:mm a"))!
        print("PHAsset Creation Date ", creationDateString)
        
        // Modification Date
         let modificationDate = asset.modificationDate
         let modificationDateString: String = (modificationDate?.toString(dateFormat: "dd-MMM-yyyy hh:mm a"))!
         print("PHAsset Modification Date ", modificationDateString)
        
        let pixelWidth = asset.pixelWidth
        let pixelHeight = asset.pixelHeight
        print("PHAsset Width * Height  \(pixelWidth) * \(pixelHeight)")
        
        let latitude = asset.location?.coordinate.latitude
        let longitude = asset.location?.coordinate.longitude
        print("PHAsset latitude,longitude \(latitude),\(longitude)")
        
        var img: UIImage?
        var size: String = ""
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            size = self.humanReadableByteCount(bytes: data!.count)
            print("File size before compression:\(size)")
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
         
       
        //cell.nameLabel.text = "Name: \(asset.originalFilename)"
        //cell.dateLabel.text = "Date: \(creationDateString)"
        
        
        cell.photoImageView.image = img
        cell.dateLabel.text = "\(creationDateString)"
        cell.sizeLabel.text = "Size: \(size)"
    }
    
    func humanReadableByteCount(bytes: Int) -> String {
        if (bytes < 1000) { return "\(bytes) B" }
        let exp = Int(log2(Double(bytes)) / log2(1000.0))
        let unit = ["KB", "MB", "GB", "TB", "PB", "EB"][exp - 1]
        let number = Double(bytes) / pow(1000, Double(exp))
        if exp <= 1 || number >= 100 {
            return String(format: "%.0f %@", number, unit)
        } else {
            return String(format: "%.1f %@", number, unit)
                .replacingOccurrences(of: ".0", with: "")
        }
    }
    
    /*
    @IBAction func loadPhotoTapped(_ sender: UIButton) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("OKAY")
                } else {
                    print("NOTOKAY")
                }
            })
        }
        checkLibrary()
        checkPermission()
    }
    
    func checkPermission() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            self.displayUploadImageDialog(btnSelected: self.loadPhoto)
        case .denied:
            print("Error")
        default:
            break
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func checkLibrary() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            switch photos {
            case .authorized:
                self.displayUploadImageDialog(btnSelected: self.loadPhoto)
            case .denied:
                print("Error")
            default:
                break
            }
        }
    }
    
    func displayUploadImageDialog(btnSelected: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        let alertController = UIAlertController(title: "", message: "Upload profile photo?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true) {() -> Void in }
        })
        alertController.addAction(cancelAction)
        let cameraRollAction = UIAlertAction(title: NSLocalizedString("Open library", comment: "Open library action"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UI_USER_INTERFACE_IDIOM() == .pad {
                OperationQueue.main.addOperation({() -> Void in
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true) {() -> Void in }
                })
            }
            else {
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true) {() -> Void in }
            }
        })
        alertController.addAction(cameraRollAction)
        alertController.view.tintColor = .black
        present(alertController, animated: true) {() -> Void in }
    }*/
}
