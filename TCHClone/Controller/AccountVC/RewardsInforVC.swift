//
//  RewardsInforVC.swift
//  TCHClone
//
//  Created by Trần Huy on 5/15/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

class RewardsInforVC: UIViewController {
    

    //MARK: - Properties
   
    
    @IBOutlet weak var imgCardMember: UIImageView!
    @IBOutlet weak var viewMoreInforProgram: UIView!
    @IBOutlet weak var viewHistory: UIView!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    
    @IBOutlet weak var widthSegment: NSLayoutConstraint!
    @IBOutlet weak var heightSegment: NSLayoutConstraint!
    @IBOutlet weak var segmentControll: CustomSegmentControll!
    
    @IBOutlet weak var memberLevelHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var noticeViewHeightConstranit: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var tableMT: UITableView!
    @IBOutlet weak var lblMemberLever: UILabel!
    var user: User? {
        didSet {
            userLevel = user?.userLever()
        }
    }
    var userLevel: UserLevel?
    var imageUnlockLevel: UIImage?
    var endows: [String]? = []
    let seg = UISegmentedControl()
//    let imageLockEndow: UIImage?
    
    
    @IBOutlet weak var lblNoti: UILabel!
    @IBOutlet weak var lblVoucher: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableMT.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        configNavigationBar()
        configView()
        // Do any additional setup after loading the view.
    }
    
    
    func configView() {
        self.tabBarController?.tabBar.isHidden = true
        if user != nil {
            userLevel = user?.userLever()
        } else {
            userLevel = nil
        }
        imgCardMember.image = userLevel?.backgroundCardMember
        if userLevel!.rawValue == "new" {
            lblWelcome = nil
            noticeViewHeightConstranit.constant = 0
            
        } else {
            let attributes = NSMutableAttributedString(string: "Bạn đang là thành viên \(userLevel!.level) \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            attributes.append(NSAttributedString(string: "Chúc mừng! Bạn đã tích luỹ đủ BEAN để giữ hạng. Hãy tiếp tục ghé Nhà để tận hưởng những ưu đãi từ quyền lợi thành viên của bạn nhé", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
            lblWelcome.attributedText = attributes
            lblWelcome.numberOfLines = 0
            lblWelcome.layoutIfNeeded()
//            lblWelcome.sizeToFit()
//            lblWelcome.lineBreakMode = .byWordWrapping
            print(lblWelcome.frame.height)
            noticeViewHeightConstranit.constant = lblWelcome.frame.height
        }
        
        
        lblName.text = user?.name ?? user?.fbname
        lblLevel.text = userLevel?.description
        lblPoint.text = (user!.points != nil) ? "\(user!.points!)" : ""
        configMemberLevelView()
        segmentControll.imageButtons = [#imageLiteral(resourceName: "resources_images_icons_mem_new"),#imageLiteral(resourceName: "resources_images_icons_mem_bronze"), #imageLiteral(resourceName: "resources_images_icons_mem_silver"), #imageLiteral(resourceName: "resources_images_icons_mem_gold"), #imageLiteral(resourceName: "resources_images_icons_mem_diamond")]
        if let startBtnIdx = UserLevel(rawValue: userLevel!.rawValue)?.index {
            segmentControll.startButton = startBtnIdx
            handlerButtonSegment(with: startBtnIdx)
        }
        
    }
    func configMemberLevelView() {
        tableMT.delegate = self
        tableMT.dataSource = self
//        tableMT.sizeToFit()
//        tableMT.invalidateIntrinsicContentSize()
        tableMT.layoutIfNeeded()
        tableMT.allowsSelection = false
        tableMT.isScrollEnabled = false
        
        let tableHeight = tableMT.contentSize.height
        
        memberLevelHeightConstrant.constant = 150 + tableHeight
    }
    func configNavigationBar() {
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1"), style: .plain, target: self, action: #selector(handlerClose))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Member Information"
    }
    func handlerButtonSegment(with indexButton: Int) {
        switch indexButton {
        case 0:
            lblNoti.text = "Bạn đã đạt hạng Mới"
            endows = UserLevel(rawValue: "new")?.endow as! [String]
            imageUnlockLevel = #imageLiteral(resourceName: "unlock_new")
            tableMT.reloadData()
            configMemberLevelView()
        case 1:
            if let point = user?.points {
                if point >= 100 {
                    imageUnlockLevel = #imageLiteral(resourceName: "unlock_brozen")
                    lblNoti.text = "Bạn đã đạt hạng Đồng"
                } else {
                    lblNoti.text = "Còn \(100 - point) BEAN nữa bạn sẽ thăng hạng Đồng"
                    imageUnlockLevel = #imageLiteral(resourceName: "lock_bronze")
                }
                
            }
            endows = UserLevel(rawValue: "bronze")!.endow
            tableMT.reloadData()
            configMemberLevelView()
        case 2:
            if let point = user?.points {
                if point >= 200 {
                    imageUnlockLevel = #imageLiteral(resourceName: "unlock_silver")
                    lblNoti.text = "Bạn đã đạt hạng Bạc"
                } else {
                    lblNoti.text = "Còn \(100 - point) BEAN nữa bạn sẽ thăng hạng Bạc"
                    imageUnlockLevel = #imageLiteral(resourceName: "lock_silver")
                }
                
            }
            endows = UserLevel(rawValue: "silver")!.endow
            tableMT.reloadData()
            configMemberLevelView()
        case 3:
            if let point = user?.points {
                if point >= 500 {
                    lblNoti.text = "Bạn đã đạt hạng Vàng"
                    imageUnlockLevel = #imageLiteral(resourceName: "unlock_gold")
                } else {
                    lblNoti.text = "Còn \(500 - point) BEAN nữa bạn sẽ thăng hạng Vàng"
                    imageUnlockLevel = #imageLiteral(resourceName: "lock _gold")
                }
                
            }
            endows = UserLevel(rawValue: "gold")!.endow
            tableMT.reloadData()
            configMemberLevelView()
        default:
            if let point = user?.points {
                if point >= 3000 {
                    imageUnlockLevel = #imageLiteral(resourceName: "unlock_diamond")
                    lblNoti.text = "Bạn đã đạt hạng Kim Cương"
                } else {
                    lblNoti.text = "Còn \(3000 - point) BEAN nữa bạn sẽ thăng hạng Kim Cương"
                    imageUnlockLevel = #imageLiteral(resourceName: "lockdiamond")
                }
            }
            endows = UserLevel(rawValue: "diamond")!.endow
            tableMT.reloadData()
            configMemberLevelView()
        }

    }
//    func genderImageLockEndow(point : Int?, in level: Int) -> UIImage {
//        switch level {
//        case 0:
//            return #imageLiteral(resourceName: <#T##String#>)
//        default:
//            <#code#>
//        }
//    }
    @IBAction func customSegmentValueChange(_ sender: CustomSegmentControll) {
        handlerButtonSegment(with: sender.selectedSegmentIndex)
    }
    

    @IBAction func moreInforViewTap(_ sender: Any) {
        let moreInforView = WebView()
        moreInforView.keepTabbar = false
        moreInforView.url = URL(string: "https://thecoffeehouse.com/pages/rewards")
        moreInforView.showOrderButton = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(moreInforView, animated: true)
    }
    
    /*
    // MARK: - Navigation

     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func handlerClose() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

}
//class RewardsInforLevelCell: UITableViewCell {
//    //MARK: - Properties
//    var imageView: UIImageView = {
//       let iv = UIImageView()
//        return iv
//    }()
//    //MARK: - Init
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - Delegate
//    
//}
extension RewardsInforVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endows!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = endows![indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.font = UIFont.systemFont(ofSize: 11)
        cell.imageView?.image = imageUnlockLevel
        return cell
    }
    
    
}
