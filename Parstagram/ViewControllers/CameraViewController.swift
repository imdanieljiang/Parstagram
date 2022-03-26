//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Daniel Jiang on 3/25/22.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // If we can use a camera, like on our own personal phone,
        // use the camera, otherwise, open the photo library app
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        // Resize the image
        let size = CGSize(width: 360, height: 360)
        let scaledImage = image.af.imageScaled(to: size)
        imageView.image = scaledImage
        
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        // Our Instagram post
        let post = PFObject(className: "Post")
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        // Our image saved as a .png file
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
