//
//  RadioButtonView.swift
//  TCHClone
//
//  Created by Trần Huy on 6/20/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

class RadioButtonView: UIView, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var radioButtons = [RadioButton]()
    
    @IBInspectable var buttonHeight: CGFloat = 35 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBInspectable var radioButtonColor: UIColor = UIColor.orange {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBInspectable var titleSize: CGFloat = 13 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBInspectable var cellBackgrounColor: UIColor = UIColor.white {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBInspectable var isScrollable: Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBInspectable var showSeperator: Bool = false {
        didSet {
            if showSeperator {
                self.tableView.separatorStyle = .singleLine
            } else {
                self.tableView.separatorStyle = .none
            }
            self.tableView.reloadData()
        }
    }
    
    var radioButtonLeftTitles = [String]()
    var radioButtonRightTitles = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        tableView = UITableView()
        tableView.frame = self.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
    }
    
    func addButtons(radioButtonLeftTitles: [String], radioButtonRightTitles:[String]) {
        self.radioButtonLeftTitles = radioButtonLeftTitles
        self.radioButtonRightTitles = radioButtonRightTitles
        if showSeperator {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
        
        for (index, radioButtonLeftTitle) in radioButtonLeftTitles.enumerated() {
            let radioButton = RadioButton()
            radioButton.titleText = radioButtonLeftTitle
            radioButton.titleTextTail = radioButtonRightTitles[index]
            radioButton.addTarget(self, action: #selector(updateButtons(button:)), for: .touchUpInside)
            radioButton.contentHorizontalAlignment = .left
            radioButton.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            self.radioButtons.append(radioButton)
        }
        setHeightOfCellIfScrollingIsDisabled()
        self.tableView.reloadData()
        
    }
    func setHeightOfCellIfScrollingIsDisabled()  {
        if !isScrollable {
            buttonHeight = self.bounds.height/CGFloat(radioButtonLeftTitles.count)
        }
    }
    
    //MARK: - Selector
    @objc func updateButtons(button: RadioButton) {
        for lbutton in radioButtons {
            if lbutton != button {
                lbutton.isSelected = false
            } else {
                lbutton.isSelected = true
            }
        }
    }
    
    //MARK: - Delegae
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(buttonHeight)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioButtonLeftTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.detailTextLabel?.text = radioButtonLeftTitles[indexPath.row]
        let radioButton = radioButtons[indexPath.row]
        radioButton.frame = cell.contentView.bounds
        cell.contentView.backgroundColor = cellBackgrounColor
        cell.contentView.addSubview(radioButton)
        return cell
    }
}
