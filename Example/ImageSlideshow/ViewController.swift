//
//  ViewController.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 30.07.15.
//  Copyright (c) 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import ImageSlideshow
import GoogleMobileAds

class ViewController: UIViewController, GADInterstitialDelegate {

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let semaphore = DispatchSemaphore(value: 0)
    
    var names = [] as [String]
    
    var interstitial: GADInterstitial!
    
    let url=URL(string:"https://mei12356.com/ios")
  
    //let localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    //let afNetworkingSource = [AFURLSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AFURLSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AFURLSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    //let alamofireSource = [AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    //let sdWebImageSource = [SDWebImageSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, SDWebImageSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, SDWebImageSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    /*
    var kingfisherSource = [KingfisherSource(urlString: "https://ig-s-b-a.akamaihd.net/hphotos-ak-xta1/t51.2885-15/e35/926192_672631346105510_1427417519_n.jpg")!,
                            KingfisherSource(urlString: "https://ig-s-b-a.akamaihd.net/hphotos-ak-xta1/t51.2885-15/e35/14240945_1171949289530600_1901063664_n.jpg")!,
                            KingfisherSource(urlString: "https://ig-s-b-a.akamaihd.net/hphotos-ak-xta1/t51.2885-15/e35/15625196_1778934412372265_3149268281412550656_n.jpg")!,
                            KingfisherSource(urlString: "https://ig-s-b-a.akamaihd.net/hphotos-ak-xta1/t51.2885-15/e35/14482928_396641540460049_2613024859839528960_n.jpg")!,
                            KingfisherSource(urlString: "https://ig-s-b-a.akamaihd.net/hphotos-ak-xta1/t51.2885-15/e35/10251507_268890833291947_1265792874_n.jpg")!,]
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = createAndLoadInterstitial()

        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.currentPageChanged = { page in
            print("current page:", page)
            print("ww", self.slideshow.images.count)
            if page == self.slideshow.images.count - 1{
                self.getMore()
                if page % 20 == 4{
                    self.showX()
                }
            }
        }
        
        interstitial = createAndLoadInterstitial()
        
        self.getMore()
        bannerView.adUnitID = "ca-app-pub-7366328858638561/2735123532"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        showX()
        
        //slideshow.setImageInputs(kingfisherSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }

    func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-7366328858638561/5688589939")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitial = createAndLoadInterstitial()
    }
    
    func showX() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            interstitial = createAndLoadInterstitial()
        }
        // Rest of game over logic goes here.
    }
    
    func getMore() {
        var kSource = [] as! [KingfisherSource]
        do {
            let allContactsData = try Data(contentsOf: self.url!)
            let allContacts = try JSONSerialization.jsonObject(with: allContactsData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            if let arrJSON = allContacts["data"] as! [String]?{
                for index in 0...arrJSON.count-1 {
                    
                    let aObject = arrJSON[index] as String
                    
                    names.append(aObject as String)
                }
            }
            print(names)
            
            for index in 0...names.count-1 {
                
                kSource.append(KingfisherSource(urlString: names[index])!)
            }
            
            //self.kingfisherSource.append(KingfisherSource(urlString: parsedData!)!)
            slideshow.setImageInputs(kSource)
            
            
        }
        catch {
            
        }
    }
    
    
    func getMoreAsync() {
        var names = [] as [String]
        URLSession.shared.dataTask(with:self.url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    //let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    print("!!!!")
                    //let parsedData = String(data: data!, encoding: String.Encoding.utf8)
                    //print(parsedData!)
                    //self.kingfisherSource.append(KingfisherSource(urlString: parsedData!)!)
                    
                    let allContacts = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
                    if let arrJSON = allContacts["data"] as! [String]?{
                        for index in 0...arrJSON.count-1 {
                            
                            let aObject = arrJSON[index] as String
                            
                            names.append(aObject as String)
                        }
                    }
                    print(names)
                    var kSource = [] as! [KingfisherSource]
                    for index in 0...names.count-1 {
                        
                        kSource.append(KingfisherSource(urlString: names[index])!)
                    }
                    
                    //self.kingfisherSource.append(KingfisherSource(urlString: parsedData!)!)
                    self.slideshow.setImageInputs(kSource)

                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            //self.semaphore.signal()
            
            }.resume()
        
        //_ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
