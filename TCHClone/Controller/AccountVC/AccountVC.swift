//
//  AccountVC.swift
//  TCHClone
//
//  Created by Trần Huy on 7/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"
private let reuseHeaderIdentifier = "Header"
private let reuseFooterIdentifier = "Footer"

class AccountVC: UITableViewController, AccountFooterDelegate, AccountHeaderDelegate, RequestLogInDelegate {
    //MARK: - Properties
    var isLogIn: Bool = false
    var user: User?
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        if Utilities.shared.checkIfUserIsLogIn() == true {
            isLogIn = true
        }
        initView()
        fetchUserData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserData), name: Notification.Name(rawValue: "com.user.change.success"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: - Handler
    func initView() {
        
        tableView.backgroundColor = .groupTableViewBackground
        
        navigationController?.navigationBar.isHidden = true
        let nib = UINib(nibName: "AccountCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(AccountFooter.self, forHeaderFooterViewReuseIdentifier: reuseFooterIdentifier)
        tableView.register(AccountHeader.self, forHeaderFooterViewReuseIdentifier: reuseHeaderIdentifier)
        tableView.separatorColor = .clear
//        tableView.contentInset
        
        
    }
    func fetchUserData(){
        
        if Utilities.shared.checkIfUserIsLogIn() == true {
            guard let curUid = Auth.auth().currentUser?.uid else { return }
            USER_REF.child(curUid).observeSingleEvent(of: .value, with: {(snapshot) in
                let uid = snapshot.key
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let user = User(uid: uid, dictionary: dictionary)
                self.user = user
                self.tableView.reloadData()
            })
            
        } else {
            self.tableView.reloadData()
        }
    }
    
    func handlerDidSelectMenu(forMenuOption menuOpt: AccountSettingSection) {
        switch menuOpt {
        case .Rewards:
            if isLogIn {
                let rewardsInforVC = RewardsInforVC()
                rewardsInforVC.user = self.user
                self.navigationController?.pushViewController(rewardsInforVC, animated: true)
            } else {
                let rqLogIn = RequestLogIn()
                rqLogIn.delegate = self
                rqLogIn.viewingMode = RequestLogIn.ViewingMode(index: 0)
                self.navigationController?.pushViewController(rqLogIn, animated: true)
            }
            
        case .Infor:
            if isLogIn {
                let inforAccountVC = InforAccount()
                inforAccountVC.user = user
                self.navigationController?.pushViewController(inforAccountVC, animated: true)
            } else {
                let rqLogIn = RequestLogIn()
                rqLogIn.delegate = self
                rqLogIn.viewingMode = RequestLogIn.ViewingMode(index: 1)
                self.navigationController?.pushViewController(rqLogIn, animated: true)
                
            }
        case .Music:
            let musicVC = MusicPlayingNowController()
            self.navigationController?.pushViewController(musicVC, animated: true)
        case .History:
            if isLogIn {
                
            } else {
                let historyOrderVC = OrderHistoryVC()
                historyOrderVC.delegate = self
                self.navigationController?.pushViewController(historyOrderVC, animated: true)
                
            }
        case .Help:
            let webView = WebView()
            webView.keepNavigationBar = false
            webView.showOrderButton = false
            webView.url = URL(string: "https://order.thecoffeehouse.com/help.html")
            self.navigationController?.pushViewController(webView, animated: true)
        case .Setting:
            let settingsVC = SettingVC()
            settingsVC.isLogin = isLogIn
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    //MARK: - AccoundUserDelegate
    func setHeader(for header: AccountHeader) {
        if (header.user != nil) {
            
            header.configHeaderHasLogIn()
        } else {
            
            header.configHeaderNoLogIn()
        }
    }
    
    func handlerHeaderAccountLoginTapped(for header: AccountHeader) {
        let loginVC = UINavigationController(rootViewController: LoginVC())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    func handlerHeaderAccountInforTapped(for header: AccountHeader) {
        let inforAccountVC = InforAccount()
        inforAccountVC.user = user
        self.navigationController?.pushViewController(inforAccountVC, animated: true)
    }
    
    //MARK: - TableViewControllerDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountSettingSection.allCases.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AccountCell
        let menuCell = AccountSettingSection(rawValue: indexPath.row)
        cell.menucell = menuCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.gray
        cell.isHighlighted = false
        return cell
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseHeaderIdentifier) as? AccountHeader
        view?.delegate = self
        view?.user = user
//        tableView.reloadData()
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Utilities.shared.checkIfUserIsLogIn() ? 80 : 60
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseFooterIdentifier) as? AccountFooter
        view?.delegate = self
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Utilities.shared.checkIfUserIsLogIn() ? 30 : 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuSettingOpt = AccountSettingSection(rawValue: indexPath.row)
        handlerDidSelectMenu(forMenuOption: menuSettingOpt!)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Delegate
    func handlerLogout(for header: AccountFooter) {
        let alertController = UIAlertController(title: "Xác nhận", message: "Bạn có chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Đồng ý", style: .default, handler: {(_ ) in
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.setValue(nil, forKey: "userID")
                self.isLogIn = false
                NotificationCenter.default.post(name: Notification.Name("com.user.logout.success"), object: nil)
                self.tabBarController?.selectedIndex = 0
                self.user = nil
                self.tableView.reloadData()
            } catch {
                
            }
        })
        let cancelAction = UIAlertAction(title: "Huỷ bỏ", style: .cancel, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func handlerLoginTapped() {
        let loginVC = UINavigationController(rootViewController: LoginVC())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: false)
    }
    //MARK: - Handler
    
    //MARK: - Selector
    @objc func updateUserData() {
        self.fetchUserData()
    }
}
extension AccountVC: OrderHistoryDelegate {
    func handlerOrderTapped() {
        self.tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 1
    }
}


