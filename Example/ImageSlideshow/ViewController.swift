//
//  ViewController.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 30.07.15.
//  Copyright (c) 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import ImageSlideshow

class ViewController: UIViewController {

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @IBOutlet var slideshow: ImageSlideshow!
    
    let semaphore = DispatchSemaphore(value: 0)
    
    let url=URL(string:"https://mei12356.com/ios")
    
    var names: [String] = []
  
    let localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    let afNetworkingSource = [AFURLSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AFURLSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AFURLSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    let alamofireSource = [AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    let sdWebImageSource = [SDWebImageSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, SDWebImageSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, SDWebImageSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    var kingfisherSource = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, KingfisherSource(urlString: "https://ig-s-b-a.akamaihd.net/hphotos-ak-xta1/t51.2885-15/e35/15875744_1842216066032723_3213522409499918336_n.jpg")!, KingfisherSource(urlString: "https://ig-s-b-a.akamaihd.net/hphotos-ak-xta1/t51.2885-15/e35/15875744_1842216066032723_3213522409499918336_n.jpg")!]

    override func viewDidLoad() {
        super.viewDidLoad()

        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        
        do {
            let allContactsData = try Data(contentsOf: self.url!)
            let allContacts = try JSONSerialization.jsonObject(with: allContactsData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            if let arrJSON = allContacts["data"] as! [String]?{
                for index in 0...arrJSON.count-1 {
                    
                    let aObject = arrJSON[index] as! String
                    
                    names.append(aObject as! String)
                }
            }
            print(names)
            self.kingfisherSource = [] as! [KingfisherSource]
            for index in 0...names.count-1 {
                
                self.kingfisherSource.append(KingfisherSource(urlString: names[index])!)
            }

            //self.kingfisherSource.append(KingfisherSource(urlString: parsedData!)!)
            
            
        }
        catch {
            
        }

        
        

        
        slideshow.setImageInputs(kingfisherSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }

    func didTap() {
        do {
            let allContactsData = try Data(contentsOf: self.url!)
            let allContacts = try JSONSerialization.jsonObject(with: allContactsData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            if let arrJSON = allContacts["data"] as! [String]?{
                for index in 0...arrJSON.count-1 {
                    
                    let aObject = arrJSON[index] as! String
                    
                    names.append(aObject as! String)
                }
            }
            print(names)
            self.kingfisherSource = [] as! [KingfisherSource]
            for index in 0...names.count-1 {
                
                self.kingfisherSource.append(KingfisherSource(urlString: names[index])!)
            }
            
            //self.kingfisherSource.append(KingfisherSource(urlString: parsedData!)!)
            
            
        }
        catch {
            
        }
        slideshow.setImageInputs(kingfisherSource)
        slideshow.presentFullScreenController(from: self)
    }
}
