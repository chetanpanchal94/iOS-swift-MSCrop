//
//  MSCropView.swift
//  MSCrop
//
//  Created by ChetanPanchal on 2/6/17.
//  Copyright © 2017 ChetanPanchal. All rights reserved.
//

import UIKit

class MSCropView: UIView, UIGestureRecognizerDelegate {
    
    private var imageView = UIImageView()
    private var cropView = UIView()
    
    var isRounded = Bool()
    
    private var tapGesture = UITapGestureRecognizer()
    private var panGesture = UIPanGestureRecognizer()
    private var pinchGesture = UIPinchGestureRecognizer()
    
    private var lastScale = CGFloat()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layoutIfNeeded()
    }
    
    func setup(image: UIImage) {
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        
        self.addSubview(imageView)
        addCropView()
    }
    
    private func addCropView() {
        
        cropView.frame = CGRect(x: (imageView.image?.size.width)!/2, y: (imageView.image?.size.height)!/2, width: 200, height: 200)
        cropView.layer.borderWidth = 2
        cropView.layer.borderColor = UIColor.white.cgColor
        cropView.alpha = 0.2
        cropView.backgroundColor = UIColor.black
        cropView.center = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        cropView.isUserInteractionEnabled = true
        
        if(isRounded) {
            cropView.layer.cornerRadius = cropView.frame.size.width/2
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.delegate = self
        cropView.addGestureRecognizer(tapGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        cropView.addGestureRecognizer(panGesture)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchGesture.delegate = self
        cropView.addGestureRecognizer(pinchGesture)
        
        imageView.addSubview(cropView)
        imageView.bringSubview(toFront: cropView)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        
        cropImage()
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in:imageView)
        let cropViewPosition: CGPoint? = cropView.center
        var recognizerFrame = gestureRecognizer.view?.frame
        recognizerFrame?.origin.x += translation.x
        recognizerFrame?.origin.y += translation.y
        cropView.center = cropViewPosition!
        
        if (imageView.bounds.contains(recognizerFrame!)) {
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
        }
        else {
            
            if ((recognizerFrame?.origin.y)! < imageView.bounds.origin.y) {
                
                recognizerFrame?.origin.y = 0
            }
            else if ((recognizerFrame?.origin.y)! + (recognizerFrame?.size.height)! > imageView.bounds.size.height) {
                
                recognizerFrame?.origin.y = imageView.bounds.size.height - (recognizerFrame?.size.height)!
            }
            if ((recognizerFrame?.origin.x)! < imageView.bounds.origin.x) {
                
                recognizerFrame?.origin.x = 0
            }
            else if ((recognizerFrame?.origin.x)! + (recognizerFrame?.size.width)! > imageView.bounds.size.width ) {
                
                recognizerFrame?.origin.x = imageView.bounds.size.width - (recognizerFrame?.size.width)!
            }
        }
        
        gestureRecognizer.setTranslation(CGPoint(x: CGFloat(0), y: CGFloat(0)), in: gestureRecognizer.view?.superview)
    }
    
    @objc private func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        
        adjustAnchorPoint(for: gestureRecognizer)
        
        if gestureRecognizer.state == .began {
            
            lastScale = gestureRecognizer.scale
        }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let widthScale: CGFloat = imageView.image!.size.width / imageView.frame.size.width
            let heightScale: CGFloat = imageView.image!.size.height / imageView.frame.size.height
            let maxScale =  max(widthScale, heightScale);
            
            let currentScale: CGFloat = gestureRecognizer.view!.layer.value(forKeyPath: "transform.scale") as! CGFloat
            
            let kMaxScale: CGFloat = ceil(maxScale)
            let kMinScale: CGFloat = 1.0
            var newScale = 1 - (lastScale - gestureRecognizer.scale)
            
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let tempTransform = (gestureRecognizer.view?.transform)!
            gestureRecognizer.view?.transform = gestureRecognizer.view!.transform.scaledBy(x: newScale, y: newScale)
            
            if (!imageView.bounds.contains((gestureRecognizer.view?.frame)!)) {
                gestureRecognizer.view?.transform = tempTransform
            }
            
            lastScale = gestureRecognizer.scale
        }
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.view! != otherGestureRecognizer.view! {
            
            return false
        }
        
        if (gestureRecognizer is UILongPressGestureRecognizer) || (otherGestureRecognizer is UILongPressGestureRecognizer) {
            
            return false
        }
        
        return true
    }
    
    private func adjustAnchorPoint(for gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            let piece = gestureRecognizer.view!
            let locationInView = gestureRecognizer.location(in: piece)
            let locationInSuperview = gestureRecognizer.location(in: piece.superview!)
            piece.layer.anchorPoint = CGPoint(x: CGFloat(locationInView.x / piece.bounds.size.width), y: CGFloat(locationInView.y / piece.bounds.size.height))
            piece.center = locationInSuperview
        }
    }
    
    private func cropImage() {
        
        cropView.backgroundColor = UIColor.clear
        cropView.layer.borderColor = UIColor.clear.cgColor
        
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, (imageView.image?.scale)!)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let originalImage = UIGraphicsGetImageFromCurrentImageContext();
        let contextImage: UIImage = originalImage!
        let cropRect: CGRect = CGRect(origin: cropView.frame.origin, size: cropView.frame.size)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: cropRect)!
        let croppedImage = UIImage(cgImage: imageRef, scale: (originalImage?.scale)!, orientation: originalImage!.imageOrientation)
        UIGraphicsEndImageContext()
        
        cropView.backgroundColor = UIColor.black
        cropView.layer.borderColor = UIColor.white.cgColor
        
        if(isRounded) {
            
            let imageLayer = CALayer()
            imageLayer.frame = CGRect(x: 0, y: 0, width: croppedImage.size.width, height: croppedImage.size.height)
            imageLayer.contents = (croppedImage.cgImage)
            imageLayer.masksToBounds = true
            imageLayer.backgroundColor = UIColor.clear.cgColor
            imageLayer.cornerRadius = croppedImage.size.width/2.0
            
            UIGraphicsBeginImageContextWithOptions(croppedImage.size, false, 5)
            imageLayer.render(in: UIGraphicsGetCurrentContext()!)
            let roundedCroppedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            UIImageWriteToSavedPhotosAlbum(roundedCroppedImage!, nil, nil, nil)
        }
        else {
            
            UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
        }
        
        let lblNotify = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        lblNotify.text = "Image Cropped and Saved !!!"
        lblNotify.backgroundColor =  UIColor.black
        lblNotify.textColor = UIColor.white
        lblNotify.center = CGPoint(x: imageView.center.x - lblNotify.frame.size.width/2, y: imageView.center.y)
        lblNotify.sizeToFit()
        
        imageView.addSubview(lblNotify)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            lblNotify.removeFromSuperview()
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}

