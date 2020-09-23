//
//  File.swift
//  TCHClone
//
//  Created by Trần Huy on 9/21/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class OnboardingViewController: UIViewController {
    //MARK: - Properties
    let btnContinue: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundColor(.orange, for: .normal)
        btn.setTitle("Tiếp tục", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnContinueTapped), for: .touchUpInside)
        return btn
        
    }()
    let btnSkip: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Bỏ qua", for: .normal)
        btn.addTarget(self, action: #selector(completeOnboarding), for: .touchUpInside)
        btn.setTitleColor(.blue, for: .normal)
        return btn
        
    }()
    let pageviewController: UIPageViewController = {
       let page = UIPageViewController()
        page.view.backgroundColor = .white
        return page
    }()
    
    let pageControll: UIPageControl = {
       let pageControll = UIPageControl()
        pageControll.currentPage = 0
        pageControll.numberOfPages = 4
        pageControll.currentPageIndicatorTintColor = .orange
        pageControll.pageIndicatorTintColor = .lightGray
        return pageControll
    }()
    let scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    var arraySlide: [SlideView] = []
    var curentIndex: Int? {
        didSet {
            if curentIndex == 3 {
                btnContinue.setTitle("Bắt đầu trải nghiệm", for: .normal)
                btnContinue.needsUpdateConstraints()
            } else {
                btnContinue.setTitle("Tiếp tục", for: .normal)
                btnContinue.needsUpdateConstraints()
                btnContinue.sizeToFit()
            }
        }
    }
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        arraySlide = createArraySlide()
        configScrollView(slides: arraySlide)
        scrollView.delegate = self
        
    }
    
    //MARK: - Handler
    func initView() {
        view.backgroundColor = .white
        
        view.addSubview(btnSkip)
        btnSkip.setAnchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 20, paddingRight: 20)
        view.addSubview(btnContinue)
        btnContinue.intrinsicContentSize.width
        btnContinue.setAnchor(top: nil, left: nil, bottom: view.safeBottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 0, width: btnContinue.intrinsicContentSize.width + 150 ,height:  50)
        btnContinue.clipsToBounds = true
        btnContinue.layer.cornerRadius = 25
        btnContinue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(pageControll)
        pageControll.setAnchor(top: nil, left: nil, bottom: btnContinue.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0)
        pageControll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    func slideView(image: UIImage, title: String, description: String) -> SlideView {
        let slideView = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! SlideView
        slideView.imageView.image = image
        slideView.lblTitle.text = title
        slideView.lblDescription.text = description
        return slideView
    }
    func createArraySlide() -> [SlideView] {
        var slides = [SlideView]()
        let slideView1 = slideView(image: #imageLiteral(resourceName: "resources_images_intro_onboadingbg1"), title: "Chương trình điểm thưởng", description: "Thưởng thức cafe hay chơi game đều được tích điểm")
        slides.append(slideView1 as! SlideView)
        let slideView2 = slideView(image: #imageLiteral(resourceName: "resources_images_intro_onboadingbg2"), title: "Giao hàng tận nơi", description: "Đặt món giao hàng tận nơi trong vòng 30 phút")
        slides.append(slideView2 as! SlideView)
        let slideView3 = slideView(image: #imageLiteral(resourceName: "resources_images_intro_onboadingbg3"), title: "Gọi món tại bàn", description: "Không cần xếp hàng, đặc quyền khác biệt")
        slides.append(slideView3 as! SlideView)
        let slideView4 = slideView(image: #imageLiteral(resourceName: "resources_images_intro_onboadingbg4"), title: "Tích điểm đổi quà", description: "Dùng điểm đổi hàng ngàn ưu đãi hấp dẫn")
        slides.append(slideView4 as! SlideView)
        return slides
    }
    func configScrollView(slides: [SlideView]) {
        view.addSubview(scrollView)
        scrollView.setAnchor(top: btnSkip.bottomAnchor, left: view.leftAnchor, bottom: pageControll.topAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 20, paddingRight: 0)
        scrollView.isPagingEnabled = true
        scrollView.contentSize.width = view.frame.width * CGFloat(arraySlide.count)
        for index in 0...arraySlide.count - 1 {
            arraySlide[index].frame = CGRect(x: view.frame.width * CGFloat(index), y: scrollView.frame.minY, width: view.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(arraySlide[index])
        }
    }
    
    
    //MARK: - Selector
    @objc func completeOnboarding() {
        UserDefaults.standard.setValue(true, forKey: "UserDidFinishOnBoarding")
        let mainVC = MainTabViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    @objc func btnContinueTapped() {
        if scrollView.contentOffset.x < scrollView.contentSize.width - view.frame.width {
            scrollView.contentOffset.x += view.frame.width
            let pageIndex = round(scrollView.contentOffset.x / view.frame.width )
            pageControll.currentPage = Int(pageIndex)
            curentIndex = Int(pageIndex)
        } else {
            completeOnboarding()
        }
    }
}
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width )
        pageControll.currentPage = Int(pageIndex)
        curentIndex = Int(pageIndex)
    }
}
