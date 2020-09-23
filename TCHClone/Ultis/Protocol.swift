//
//  Protocol.swift
//  TCHClone
//
//  Created by Trần Huy on 5/6/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
protocol NewsHeaderDelegate {
    func handlerOrderTapped(for header: NewsHeader)
}
protocol AccountFooterDelegate {
    func handlerLogout(for header: AccountFooter)
}
protocol AccountCellDelegate {
    func handlerAccountCellTapped(forMenuCell: AccountSettingSection)
}
protocol RequestLogInDelegate {
//    func handlerOrderTapped()
    func handlerLoginTapped()
}
protocol OrderHistoryDelegate {
    func handlerOrderTapped()

}
protocol AccountHeaderDelegate {
    func setHeader(for header: AccountHeader)
    func handlerHeaderAccountLoginTapped(for header: AccountHeader)
    func handlerHeaderAccountInforTapped(for header: AccountHeader)
}

protocol NewsVCDelegate: class {
    func updateUI()
}

protocol OrderCelldDelegate {
    func handlerCellOrderTapped(with item: ItemData)
}
protocol PopupViewChooseNationalDelegate {
    func handlerCancelBtnPopUpTapped()
    
}
protocol PopupLogInEmailDelegate {
    func handlerCancelBtnPopUpTapped()
    func handlerLoginBtnTapped()
    func handlerSignUpBtnTapped()
    
}

protocol SendUserDataDelegate {
    func sendUser(with user: User)
}

protocol EditInforDelegate {
    func updateUser(user: User)
}
protocol AccountVCDelegate {
    func openInforView(user: User)
}

