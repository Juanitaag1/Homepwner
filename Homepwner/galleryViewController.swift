//
//  galleryViewController.swift
//  Homepwner
//
//  Created by juanita aguilar on 5/20/19.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit
import MobileCoreServices

//Hve to conform to the UITextFieldDelegate protocol to dismiss the keyboard when return key is pressed
//implement the UITextFieldDelegate's textFieldshouldReturn() fn ch14 p249
//Has to conform to the  UINavigationControllerDelegate, UIImagePickerControllerDelegate  for delegate to work picker = self
class galleryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //adding the connection from imageView pg 261 ch15 Control+Drag from uiimageView to top of this controller. option+Click on vc to open assistant  Now add a camera buton
    @IBOutlet var imageView: UIImageView!
    
    let videoFileName = "/video.mp4"
}
