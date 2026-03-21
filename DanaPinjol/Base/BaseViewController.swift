//
//  BaseViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import Combine
import TYAlertController

class BaseViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    private let locationManager = LocationManager()
    
    lazy var headView: AppHeadView = {
        let headView = AppHeadView(frame: .zero)
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension BaseViewController {
    
    func toLoginPage() {
        let loginVc = BaseNavigationController(rootViewController: LoginViewController())
        loginVc.modalPresentationStyle = .overFullScreen
        self.present(loginVc, animated: true)
    }
    
    func alertDpcView() {
        let popView = PopDpaView(frame: self.view.bounds)
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.confirmBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.toProductStepPage()
            }
        }
    }
    
    func toProductStepPage() {
        guard let nav = navigationController else { return }
        
        if let productVC = nav.viewControllers.first(where: { $0 is ProductViewController }) {
            nav.popToViewController(productVC, animated: true)
        } else {
            nav.popToRootViewController(animated: true)
        }
    }
    
    func toOrderListPage() {
        guard let nav = navigationController else { return }
        
        if let productVC = nav.viewControllers.first(where: { $0 is OrderListViewController }) {
            nav.popToViewController(productVC, animated: true)
        } else {
            nav.popToRootViewController(animated: true)
        }
    }
    
    func juduePageToVc(_ pageUrl: String) {
        if pageUrl.contains(MorningyRouter.shared.scheme_url) {
            if let navigationController = self.navigationController, let url = URL(string: pageUrl) {
                MorningyRouter.shared.handle(url: url, navigationController: navigationController)
            }
        }else {
            let webVc = H5WebViewController()
            webVc.pageUrl = pageUrl
            self.navigationController?.pushViewController(webVc, animated: true)
        }
    }
    
}

extension BaseViewController {
    
    func toNextVC(with cylindModel: cylindModel) {
        let type = cylindModel.priviical?.medi ?? ""
        
        switch type {
        case "dur":
            let faceVc = FaceViewController()
            faceVc.cylindModel = cylindModel
            self.navigationController?.pushViewController(faceVc, animated: true)
            
        case "project":
            let personalVc = PersonalViewController()
            personalVc.cylindModel = cylindModel
            self.navigationController?.pushViewController(personalVc, animated: true)
            
        case "job":
            let hardVc = HardWorkViewController()
            hardVc.cylindModel = cylindModel
            self.navigationController?.pushViewController(hardVc, animated: true)
            
        case "diseasead":
            let findVc = FineMeViewController()
            findVc.cylindModel = cylindModel
            self.navigationController?.pushViewController(findVc, animated: true)
            
        case "dudom":
            let poorVc = PoorViewController()
            poorVc.cylindModel = cylindModel
            self.navigationController?.pushViewController(poorVc, animated: true)
            
        case "":
            locationManager.requestLocation { _ in }
            let orderViewModel = ProductViewModel()
            let orderID = cylindModel.seish?.cultural ?? ""
            let parameters = ["reportard": orderID]
            orderViewModel.orderNumClickInfo(parameters: parameters)
            
            orderViewModel.$orderClickModel
                .receive(on: DispatchQueue.main)
                .sink { [weak self] model in
                    guard let self, let model else { return }
                    let lentfier = model.lentfier ?? ""
                    if lentfier == "0" || lentfier == "00" {
                        let pageUrl = model.cylind?.thero ?? ""
                        self.juduePageToVc(pageUrl)
                        self.dpAppInfo(with: "8",
                                       cylindModel: cylindModel,
                                       viewModel: orderViewModel)
                    }
                }
                .store(in: &cancellables)
            
        default:
            break
        }
        
    }
    
}

extension BaseViewController {
    
    private func dpAppInfo(with scorear: String,
                           cylindModel: cylindModel,
                           viewModel: ProductViewModel) {
        let parameters = ["noweer": cylindModel.seish?.side ?? "",
                          "scorear": scorear,
                          "cultural": cylindModel.seish?.cultural ?? "",
                          "foss": String(Int(Date().timeIntervalSince1970)),
                          "micrial": String(Int(Date().timeIntervalSince1970))]
        viewModel.uploadPointInfo(parameters: parameters)
    }
    
}
