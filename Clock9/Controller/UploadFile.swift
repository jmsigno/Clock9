//
//  UploadFile.swift
//  Clock9
//
//  Created by Jdrake on 1/20/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI
import UIKit

struct MyKeys {
    static let imagesFolder = "imagesFolder"
    static let imagesCollection = "imagesCollection"
    static let uid = "uid"
    static let imageUrl = "imageUrl"
}

class uploadFile {
    // Save the UIIMage to a local disk path and return the path to be uploaded to Firebase Storage
    func save(image profileImage: UIImage) -> URL {
        let uid = UUID().uuidString
        let name = "\(uid).png"
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        try! profileImage.jpegData(compressionQuality: 0.7)?.write(to: url)
        return url
    }
    
    // Upload the local saved image to Firebase Storage and return its URL
    func uploadImage(id: UUID, name: String, email: String, password: String, phone: String, type: Int, image profileImage: UIImage) {
        
        let urlString = save(image: profileImage)
        // print("saved image at disk path: \(urlString)")
        
        // Path to which the image needs to be uploaded i.e imagesFolder in the Firebase Storage
        let imageReference = Storage.storage().reference().child(MyKeys.imagesFolder).child("\(urlString)")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imageReference.putFile(from: urlString, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print ("error :\(error?.localizedDescription ?? "Error description not available.")")
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            print (size)
            // You can also access to download URL after upload.
            imageReference.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                let employeeManagerRef = EmployeeManager()
                employeeManagerRef.createEmployee(id: id, name: name, email: email, password: password, phone: phone, type: type, firebaseURL: "\(downloadURL)")
                print("Firebase Storage URL: \(downloadURL)")
            }
        }
        uploadTask.resume()
    }
    
}
