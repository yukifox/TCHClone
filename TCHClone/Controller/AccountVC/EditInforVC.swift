//
//  EditInforVC.swift
//  TCHClone
//
//  Created by Trần Huy on 9/7/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import NVActivityIndicatorView
import Reachability
class EditInforVC: UIViewController {
    //MARK: - Properties
    let mainView = UIScrollView()
    let btnSave: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Lưu thay đổi", for: .normal)
        btn.backgroundColor = .orange
        btn.setTitleColor(.white, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
        
        return btn
    }()
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.isScrollEnabled = false
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.estimatedRowHeight = 80
        
        return tv
    }()
    var delegate: EditInforDelegate?
    var result = [String]()
    var user: User? {
        didSet {
            result.append((user?.name ?? user?.fbname)!)
            result.append(user?.sex ?? "")
            tableView.reloadData()
        }
    }
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    //MARK: - Handler
    func initView() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Sửa thông tin"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "node_modules_reactnavigation_src_views_assets_backicon-1"), style: .done, target: self, action: #selector(backToPreviousVC))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        tableView.register(CustomCellWithTextField.self, forCellReuseIdentifier: "Cell")
        
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .white
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        tableView.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(mainView)
        mainView.backgroundColor = .groupTableViewBackground
        mainView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        mainView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        mainView.addSubview(tableView)
        tableView.layoutIfNeeded()
        
        tableView.setAnchor(top: mainView.contentLayoutGuide.topAnchor, left: mainView.frameLayoutGuide.leftAnchor, bottom: nil, right: mainView.frameLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: tableView.contentSize.height)
        
    }
    
    //MARK: - Selector
    @objc func backToPreviousVC() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    @objc func dismissKeyboard() {
        
           view.endEditing(true)
    }
    
    @objc func btnSaveTapped() {
        if result[0] == "" {
            let alert = UIAlertController(title: "Thông báo", message: "Vui lòng nhập thông tin đầy đủ", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(actionCancel)
            self.present(alert, animated: true)
            return
        }
        let editedName = result[0]
        let editedSex = result[1]
        guard let uid = user?.uid else { return }
        do {
            try Reachability().whenUnreachable = { (_ ) in
                return
            }
        } catch {
            
        }
        //create dictionary to update
        let dictionaryValue = ["fullname": editedName,
                               "sex": editedSex
        ] as! Dictionary<String, Any>
        //Handler btnSave
        DispatchQueue.main.async {
            let indicatorView = NVActivityIndicatorView(frame: .zero, type: .ballPulse, color: .darkText, padding: 0)
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            self.btnSave.backgroundColor = .darkGray
            self.btnSave.setTitle("", for: .normal)
            indicatorView.isHidden = false
                self.btnSave.addSubview(indicatorView)
            indicatorView.setAnchor(top: self.btnSave.topAnchor, left: self.btnSave.leftAnchor, bottom: self.btnSave.bottomAnchor, right: self.btnSave.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
            indicatorView.startAnimating()
        }
        //Update to database
        Database.database().reference().child("users").child(uid).updateChildValues(dictionaryValue, withCompletionBlock: {(error, dataRef) in
            self.user?.name = self.result[0]
            self.user?.sex = self.result[1]
            self.delegate?.updateUser(user: self.user!)
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    @objc func updateResult() {
        let indexPathName = IndexPath(row: 0, section: 0)
        let cellName = tableView.cellForRow(at: indexPathName) as! CustomCellWithTextField
        let indexPathSex = IndexPath(row: 1, section: 0)
        let cellSex = tableView.cellForRow(at: indexPathSex) as! CustomCellWithTextField
        
        result[0] = cellName.textField.text!
        result[1] = cellSex.textField.text!
    }
    //MARK: - Override method
    override var inputAccessoryView: UIView? {
        get {
//            inputAccessoryView?.addSubview(btnSave)
//            btnSave.setAnchor(top: nil, left: inputAccessoryView?.leftAnchor, bottom: inputAccessoryView?.bottomAnchor, right: inputAccessoryView?.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
            btnSave.widthAnchor.constraint(equalToConstant: view.frame.width * 6 / 7).isActive = true
            return btnSave
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableView.resignFirstResponder()
    }
    
}

extension EditInforVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCellWithTextField
        cell.textField.delegate = self
        if indexPath.row == 0 {
            cell.textField.placeholder = "Tên hiển thị"
            cell.textField.text = result[0]
            cell.textField.endEditing(false)
            cell.textField.addTarget(self, action: #selector(updateResult), for: .editingChanged)
            
        } else if indexPath.row == 1 {
            cell.textField.placeholder = "Giới tính"
            cell.textField.text = result[1] == "" ? "Không" : result[1]
            cell.textField.addTarget(self, action: #selector(updateResult), for: .valueChanged)
            cell.textField.isUserInteractionEnabled = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let alert = UIAlertController(title: "Giới tính của bạn?", message: nil, preferredStyle: .actionSheet)
            let acctionMale = UIAlertAction(title: "Nam", style: .default, handler: {(_ ) in
                self.result[1] = "Nam"
                self.tableView.reloadData()
            })
            let acctionFemale = UIAlertAction(title: "Nữ", style: .default, handler: {(_ ) in
                self.result[1] = "Nữ"
                self.tableView.reloadData()
            })
            let cancelAction = UIAlertAction(title: "Huỷ bỏ", style: .cancel, handler: {(_ ) in
                if (self.user?.sex == nil) || (self.result[1] == "Không") {
                    self.result[1] = "Nam"
                    self.tableView.reloadData()
                }
            })
            alert.addAction(acctionMale)
            alert.addAction(acctionFemale)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}
extension EditInforVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
extension EditInforVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === gestureRecognizer.view)
    }
    
}

class CustomCellWithTextField: UITableViewCell {
    //MARK: - Properties
    let textField: SkyFloatingLabelTextField = {
       let tf = SkyFloatingLabelTextField()
        tf.lineView.isHidden = true
        tf.titleColor = .gray
        tf.endEditing(false)
        tf.titleLabel.text?.lowercased()
        return tf
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handler
    func initView() {
        contentView.addSubview(textField)
        textField.setAnchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 10)
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}



