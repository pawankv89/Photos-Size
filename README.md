# Photos-Size

## We are showing your Photo Size in our Application. 

Added Some screens here.

![](https://github.com/pawankv89/Photos-Size/blob/master/images/screen_1.png)


## Usage

#### Controller

```swift

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
}extension ViewController {

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
}

```

## Requirements

### Build

Xcode Version 11.3 (11C29), iOS 13.2.0 SDK

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each this release can be found in the [CHANGELOG](CHANGELOG.mdown). 



