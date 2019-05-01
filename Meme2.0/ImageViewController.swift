//
//  ImageViewController.swift
//  Meme2.0
//
//  Created by Abdullah alammar on 15/04/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    var isUsingBottomDefaultText:Bool = true
    var isUsingTopDefaultText:Bool = true
    
    
    @IBOutlet weak var topTxt: UITextField!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var bottomTxt: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
     var btnShare: UIBarButtonItem?
    @IBOutlet weak var topNavigation: UINavigationItem!
    
    var meme: Meme?

    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white ,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5.0
        
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMemeTextField(textField: self.topTxt, text: self.topTxt.text ?? "TOP")
        configureMemeTextField(textField: self.bottomTxt, text: self.bottomTxt.text ?? "BOTTOM")
        
    }
    
    func configureMemeTextField(textField: UITextField, text: String) {
        textField.text = text
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
        textField.minimumFontSize = 1.0
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    
    
    @IBAction func cancelImage(_ sender: UIBarButtonItem) {
        
        self.topTxt.text = "TOP"
        self.bottomTxt.text = "BOTTOM"
        imagePickerView.image = nil
        self.btnShare = nil
        self.navigationItem.leftBarButtonItem = nil
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == bottomTxt && isUsingBottomDefaultText {
            textField.text = ""
            isUsingBottomDefaultText = false
        }
        
        if textField == topTxt && isUsingTopDefaultText {
            textField.text = ""
            isUsingTopDefaultText = false
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func pickAlbumImage(_ sender: UIBarButtonItem) {
        
          pickAnImage(sourceType: .photoLibrary)
        
    }
    

    @IBAction func pickCameraImage(_ sender: UIBarButtonItem) {
          pickAnImage(sourceType: .camera)
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyBoardNotifications()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyBoardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    func unsubscribeFromKeyboardNotifications(){
        
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    @objc func keyboardWillShow(_ notification : Notification) {
        if   bottomTxt.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
        
    }
    
    
    @objc func keyboardWillHide(_ notification : Notification) {
        if view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
        
    }
    
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    func generateMemedImage() -> UIImage {
        
        
        self.bottomToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,  afterScreenUpdates: true)
        
        
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.bottomToolbar.isHidden = true
        
        
        return memedImage
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker:
        
        UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            
        }
        self.btnShare = UIBarButtonItem(barButtonSystemItem:.action, target: self, action: #selector(shareFunction))
        self.navigationItem.leftBarButtonItem = btnShare
        
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    @objc func shareFunction(_ sender: UIImageView) {
        
        if let image = imagePickerView.image {
            let items : [Any] = ["This is my profile info", image]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            present(ac, animated: true)
            
        }
        
        
        save()
        
        
        
        
    }
    
    func save() {
         // Create the meme
         meme = Meme(topText:  topTxt.text!, bottomText: bottomTxt.text!, originalImage: (imagePickerView.image)!, memedImage : generateMemedImage()   )

      
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme!)
        
        
        
        
    }
    
   
    
}




