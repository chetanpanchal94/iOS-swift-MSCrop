//
//  AppDelegate.swift
//  MSCrop
//
//  Created by ChetanPanchal on 2/6/17.
//  Copyright © 2017 ChetanPanchal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var msCropView: MSCropView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
//        msCropView.isRounded = true
        msCropView.setup(image: #imageLiteral(resourceName: "IMG.jpg"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
