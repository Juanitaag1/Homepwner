//This class will conform to the UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate.
//Will have a UIImageView to store a thumbnail of the video, a videoFileName,
//conform to the UITextFieldDelegate protocol to dismiss the keyboard when return key is pressed
//Will take a picture for the Gallery if the camera is available. Will take a video for the Gallery if the camera is available. Will have the app access the Photo Library if the camera is not available.
//Will get the selected video and Save video to the main photo album and puts that image on the screen in the image view.
//Will turn the video into a thumbnail save a video to the photos library. Will add a property observer to the itemproperty that updates the title of the navigationItem. Will dismiss the keyboard when return key is pressed. Will let the user dismiss the keyboard by touching any part of the background DetailsView - keyboard doesnt show up in the simulator.
//This will allow the values in the items viewTable to be updated when user taps Back button The text of the text fields to the corresponding item properties will be set to the values in the function

//
//  DetailViewController.swift
//  Homepwner
//
//  Created by juanita aguilar on 5/15/19.
//  Copyright © 2019 none. All rights reserved.
//

import AVFoundation
import Photos
import UIKit
import MobileCoreServices

//Hve to conform to the UITextFieldDelegate protocol to dismiss the keyboard when return key is pressed
//implement the UITextFieldDelegate's textFieldshouldReturn() fn ch14 p249
//Has to conform to the  UINavigationControllerDelegate, UIImagePickerControllerDelegate  for delegate to work picker = self
class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //adding the connection from imageView pg 261 ch15 Control+Drag from uiimageView to top of this controller. option+Click on vc to open assistant  Now add a camera buton
    @IBOutlet var imageView: UIImageView!

   let videoFileName = "/video.mp4"
    //pg 265 ch15 connection of UIBarbutton of the UTToolBar to the CAMERA icon to the vc. the button needs a target and an action.
    //instantiate a UIIMagePickerController and present it on the screen. When creating an instanc of UIIPIcerController must set it's sourceType property and assign it a delegate- pg265.
    //Need to setup picker controller programatically
    //3 sourcetypes .camera - take a pic .photoLibrary .savedPhotosAlbum.
    //BEFORE Need to check if have camera so call FX isSourceTypeAvailable(_:) on the UIImagePickerController Class
    //class func isSourceTypeAvailable(_: UIImagePickerControllerSourceType) -> Bool
    //This FX came from setting the BarButton item's System Item to camera
    //The IImagePickerController's DELEGATE will be the instancd of the DetailViewController set to self
    //Then present the imagePickerC  view controller modally on screen
    //Now have to go to the Homepwner project and click and add the permissions and usage Description - pg269
    //now implement thedidFinishPickingMediaWithInfo called when user selects a photo
    //UIImagePickerControllerDidCancel(_:) is called if the user clicks cancel the
    //Purpose: To take a picture for the Gallery if the camera is available
    //Precondition: needs the privacy - camera usage in the info.plist
    //Postcondition: A photo will be taken or selected from the photos library
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        //create ImagePicker
       let imagePicker = UIImagePickerController()
    
        //if the device has a camera, take picture, otherwise just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePicker.sourceType = .camera
        }else{
            imagePicker.sourceType = .photoLibrary
        }
        //need to conform to  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        imagePicker.delegate = self
        //place the picker on screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    //setting camera button to take a video
    //will first chect to see if a camera is available
    //will set the array to contain movies as the mediaTypes
    //Purpose: To take a video for the Gallery if the camera is available
    //Precondition: needs the privacy - camera usage in the info.plist
    //Postcondition: A video will be taken or selected from the photos library
    @IBAction func takeVideo(_ sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        
        // 1 Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // 2 Present UIImagePickerController to take video
            controller.sourceType = .camera
            controller.mediaTypes = [kUTTypeMovie as String]
            controller.delegate = self
            
            present(controller, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
            viewLibrary(controller)
        }
    }
    
    //Purpose: To have the app access the Photo Library if the camera is not available
    //Precondition: The device does not have a camera
    //Postcondition: The photo library is presented
    //if the camera is not available check in the library to get Videos
    func viewLibrary(_ controller: UIImagePickerController) {
        // Display Photo Library
        controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        //get mediatyepes that are movies
        controller.mediaTypes = [kUTTypeMovie as String]
          
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    //Purpose: To get the selected video and Save video to the main photo album and puts that image on the screen in the image view
    //Precondtion: needs the privacy - photo library usage in the info.plist
    //Postcondtion: The selected video will be added to the photos directory, turned into a thumbnail and put on screen in the Gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            //calls the videoSaved fx
            let selectorToCall = #selector(self.videoSaved(_:didFinishSavingWithError:context:))
            
            // 2
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            // Save the video to the app directory
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
            
            let videoThumbnail = turnVideoToThumbnail(selectedVideo)
            if videoThumbnail != nil{
                
                //put that image on the screen in the image view
                imageView.image = videoThumbnail
            }
        }
        // 3
        picker.dismiss(animated: true)
    }
    
    
    //Purpose: To save a video to the photos library
    //Precondition: needs the privacy - photo libraryadditon in the info.plist
    //Postcondtion:
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
    
    //Purpose: To turn the video into a thumbnail
    //Precondition: There is a video
    //Postcondtion: A thumbnail will be created and returned from the video or nil if video does not exist
    func turnVideoToThumbnail(_ videoURL: URL) -> UIImage? {
        
            do {
                let asset = AVURLAsset(url: videoURL, options: nil)
                 print("THis is the duration of the video: \(asset.duration)")
                 convertCMTime(duration: asset.duration)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                
                return thumbnail
                
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
                return nil
            }
        
    }
    //the delegate fx to get a reference to the photo once the imagePicker is dismissed. This FX is called on the method to dismiss the image picker.
    //Will put the image into the UIImageView and then call the method to dismiss the image picker - p271 ch15
   /* func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
     
     //get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //put that image on the screen in the image view
        imageView.image = image
    }*/
    
    //the delegate fx to get a reference to the photo once the imagePicker is dismissed. This FX is called on the method to dismiss the image picker.
    //Will put the image into the UIImageView and then call the method to dismiss the image picker - p271 ch15
    //This is the updated fx
  /**  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if imageView.image != nil{
            imageView.backgroundColor = UIColor.red
        }else{
            imageView.backgroundColor = UIColor.blue
        }
     
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
         fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
      }
        
       // let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       // let selectedImage = info[UIImagePickerController.InfoKey.imageURL] as! UIImage
        // Set photoImageView to display the selected image.
       
        self.imageView.image = selectedImage
     
     
     if imageView.image != nil{
            imageView.backgroundColor = UIColor.red
        }else{
        imageView.backgroundColor = UIColor.blue
        }
        
        //Take image picker off the screen
        //you must call this dismiss method
       dismiss(animated: true, completion: nil)
    }*/
    
    //Ch14 pg250 -instructions on hooking up lets the user dismiss the keyboard by touching any part of the background DetailsView - keyboard doesnt show up in the simulator
    //now go to down to viewWillDisappear to implement that the keyboard will go away when the user pushes backbutton
    //Purpose: To let the user dismiss the keyboard by touching any part of the background DetailsView - keyboard doesnt show up in the simulator
    //Precondition: the user was in editing mode
    //Postcondition: the keyboard will be dismissed
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    // to dismiss the keyboard when return key is pressed
    //implement the UITextFieldDelegate's textFieldshouldReturn() fn ch14 p249
    //now open mainStoryBoard and connect the delegate property of ea textfield to the DetailViewCont by Control-Drag from each UITextField to the DetailViewC and choose Delegate
    //Purpose: to dismiss the keyboard when return key is pressed
    //Precondition: the user was in editing mode, this class conforms to the UITextFieldDelegate protocol
    //Postcondition: the keyboard will be dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var SerialNumberField: UITextField!
    @IBOutlet var ValueField: UITextField!
    @IBOutlet var DateLabel: UILabel!
    
    //reference to item being displayed
    //adding a property observer to the itemproperty that updates the title of the navigationItem ch14 pg253
    //There are 3 customizable areas for each UINavigationItem 
   // var item: Item! code before adding observer
    //Purpose: To add a property observer to the itemproperty that updates the title of the navigationItem
    //Precondition:
    //Postcondition: The title of the navigationItem will be updated
    var item: Item!{
        didSet{
            navigationItem.title = item.name
        }
    }
    
    //instance of NumberFormatter to format the value field
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
        
    }()
    
    //instance of DateFormatter to format the  DATE field
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    //when view is loaded will set the text  of the text fields to the corresponding item properties
    //Ch14 pg 246 When the UINavigationController is about to swap views, it calls 2 Fx
    //1. viewWillDissaperar and 2. viewWillAppear. the Vc that is pushed on
    // Will have viewWillApper called on it
    //Purpose: To set the text of the text fields to the corresponding item properties when the view is loaded
    //Precondition: Needs a UINavigationController to call this function when its about to swap views
    //Postcondition: The text of the text fields to the corresponding item properties will be set to the values in the function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        SerialNumberField.text = item.serialNumber
        //ValueField.text = "\(item.valueInDollars)"
       // DateLabel.text = "\(item.dateCreated)"
        //use the date and number formatters created above to show content
        ValueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        DateLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    //Ch14 pg 246 When the UINavigationController is about to swap views, it calls 2 Fx
    //1. viewWillDissaperar and 2. viewWillAppear
    //The VC that is about to be popped off the stack will have its viewWillDisappera and the Vc that is pushed on
    // Will have viewWillApper called on it
    //This will allow the values in the items viewTable to be updated when user taps Back button
    //now go to ItemsVC and override the viewWillDisappear
    //ch14 pg 251- now go to down to viewWillDisappear to implement that the keyboard will go away when the user pushes backbutton
    //Purpose: To save changes to item to allow the values in the items viewTable to be updated when user taps Back button
    //Precondition: Needs a UINavigationController to call this function when its about to swap views
    //Postcondition: This will allow the values in the items viewTable to be updated when user taps Back button
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //clear first responder to dismiss keyboard pg251
        view.endEditing(true)
        
        //save changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = SerialNumberField.text
        
        if let valueText = ValueField.text,
            let value = numberFormatter.number(from: valueText){
            item.valueInDollars = value.intValue
        }else{
            item.valueInDollars = 0
        }
        
        
    }
    //Purpose: converts the assest.duration to be in
    //Precondition:
    //Postcondition:
    func convertCMTime(duration: CMTime){
        //****get the TimeInterval(TimeInterval is a double)and convert it to a CMTime
        //let timeInterval3: TimeInterval = 119
       // let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
        let videoDuration = duration
        //USED let maxDuration = CMTime(seconds: Double(seconds), preferredTimescale: 1)
        //UPDATED Used .seconds of the CMTime
        let convertToTimeInterval: TimeInterval = videoDuration.seconds
        print(convertToTimeInterval)
        print(videoDuration)
        //print the duration so it looks like min:sec
        //have to get the remainer and format
        //cast minutes into an Int to truncate
        let minutes: Int = Int(convertToTimeInterval/60)
        let seconds: Int = Int(convertToTimeInterval.truncatingRemainder(dividingBy: 60))
        if(seconds < 10){
            print("\(minutes):0\(seconds)")
        }else{
            print("\(minutes):\(seconds)")
        }
    }
    
}
