iOS-Swift-MSCrop
===================

A view allowing user to specify a square or circle area in an image for cropping. The user can drag, resize it, move the entire area or use 2 fingers like a pinch gesture to move and resize square or circle area. 

Screenshot
===================

Square
![alt text](https://github.com/chetanpanchal94/iOS-swift-MSCrop/blob/master/MSCropScreenshot.png)

Circle
![alt text](https://github.com/chetanpanchal94/iOS-swift-MSCrop/blob/master/MSCropRoundedScreenshot.png)

How to Use
===================
Very easy! It is created to be a drop-in component, so no static library, no extra dependencies.
Copy MSCropView.swift into your project. Assign MSCropView class to a UIView in a view controller.

Create outlet of UIVIew whose class is MSCropView.

class ViewController: UIViewController {

@IBOutlet weak var msCropView: MSCropView!

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        //msCropView.isRounded = true
        msCropView.setup(image: #imageLiteral(resourceName: "IMG.jpg"))
    }
}

For circular cropping set isRounded property to true.

License
===================

Copyright (C) 2017 Chetan Panchal

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
