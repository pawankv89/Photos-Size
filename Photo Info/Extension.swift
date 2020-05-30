//
//  Extension.swift
//  Photo Info
//
//  Created by Pawan kumar on 30/05/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//


import UIKit
import Photos
import Foundation

// Date

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}


extension PHAsset {

    var originalFilename: String {

        var fname:String?

        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }

        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }

        return fname!
    }
}
