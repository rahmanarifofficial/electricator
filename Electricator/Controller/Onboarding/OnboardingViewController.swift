//
//  ViewController.swift
//  Electricator Project Dzaki
//
//  Created by Dzaki Izza on 03/04/21.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var oval: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    
    var titles = [
        "Welcome to Electricator ",
        "What are we going to do?",
        "Join us!"
    ]
    
    var desc = [
        "We are here to help you keep your electricity bill low.",
        "We will estimate your monthly electricity bills and provide suggestion based on your saving plan",
        "Now, tell us about your electricity data by filling the form on the next page."
    ]
    
    var imgs = ["1", "2", "3"]
    
    let vc = UINavigationController()
    
    override func viewDidLayoutSubviews() {
          scrollWidth = scrollView.frame.size.width
          scrollHeight = scrollView.frame.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()

        self.scrollView.delegate = self
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)
            
            let image = UIImageView(image: UIImage.init(named: imgs[index]))
            image.image = UIImage(named: imgs[index])
            image.frame = CGRect(x: 0, y: 0, width: 191, height: 191)
            image.contentMode = .scaleAspectFit
            image.center = CGPoint(x: scrollWidth / 2, y: scrollHeight / 2 - 167)

            let txt1 = UILabel(frame:CGRect(x: image.frame.minX - 50, y: self.view.center.y - 110, width: 300,height: 200))
            txt1.textAlignment = .center
            txt1.font = UIFont.boldSystemFont(ofSize: 41.0)
            txt1.numberOfLines = 0
            txt1.textColor = UIColor(rgb : 0x06224A) 
            txt1.text = titles[index]

            let txt2 = UILabel(frame: CGRect(x: txt1.frame.minX + 10, y: txt1.frame.maxY - 20, width: 300, height: 200))
            txt2.textAlignment = .center
            txt2.numberOfLines = 0
            txt2.font = UIFont.systemFont(ofSize: 22.0)
            txt2.textColor = UIColor(rgb : 0x06224A)
            txt2.text = desc[index]
            
            
            if index == 2 {
                let button = UIButton(frame: CGRect(x: self.view.center.x - 60, y: self.view.center.y + 170, width: 125, height: 40))
                button.backgroundColor = Constants.darkBlue
                button.setTitle("Get Started", for: .normal)
                button.layer.cornerRadius = 7
                button.isEnabled = true
                button.isUserInteractionEnabled = true
                button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
                
                slide.addSubview(button)
                
                txt2.frame = txt2.frame.offsetBy(dx: 10, dy: 0)
            }

            slide.addSubview(txt1)
            slide.addSubview(txt2)
            txt2.sizeToFit()
            slide.addSubview(image)
            scrollView.addSubview(slide)
        }

        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count) , height: scrollHeight)
        self.scrollView.contentSize.height = 1.0

        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
    }
    
    @objc func didTapButton() {
//        navigationController?.pushViewController(SecondController(), animated: true)
        performSegue(withIdentifier: "SetupScreen", sender: self)
    }
        
    @IBAction func pageChanged(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }

    func setIndiactorForCurrentPage()  {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
    }
}
