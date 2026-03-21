//
//  FaceViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/16.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import TYAlertController
import MJRefresh

enum UploadClickType {
    case cardorface
    case next
}

class FaceViewController: BaseViewController {
    
    var cylindModel: cylindModel? {
        didSet {
            guard let cylindModel = cylindModel else { return }
            headView.confilgTitle(cylindModel.priviical?.hetercarryar ?? "")
        }
    }
    
    private let viewModel = FaceViewModel()
    
    private let productViewModel = ProductViewModel()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var oneListView: FaceListView = {
        let oneListView = FaceListView(frame: .zero)
        oneListView.bgImageView.image = UIImage(named: "pan_card_image".localized)
        return oneListView
    }()
    
    lazy var twoListView: FaceListView = {
        let twoListView = FaceListView(frame: .zero)
        twoListView.bgImageView.image = UIImage(named: "pan_face_image".localized)
        return twoListView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        nextBtn.setTitle("Next".localized, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextBtn.setBackgroundImage(UIImage(named: "login_btn_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "sct_head_image".localized)
        return headImageView
    }()
    
    private var uploadType: String = "card"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupHeadUI()
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
            make.size.equalTo(CGSize(width: 315.pix(), height: 48.pix()))
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headImageView)
        contentView.addSubview(oneListView)
        contentView.addSubview(twoListView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        headImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 335.pix(), height: 64.pix()))
        }
        
        oneListView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(272.pix())
        }
        
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(272.pix())
            make.bottom.equalToSuperview().offset(-20)
        }
        
        nextBtn
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.chooseView(type: .next)
            }
            .store(in: &cancellables)
        
        bindClickTap()
        
        findFaceinfo()
        
        bindViewModel()
        
        self.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            findFaceinfo()
        })
    }
    
}

extension FaceViewController {
    
    private func setupHeadUI() {
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.onBackButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.toProductStepPage()
        }
    }
    
    private func bindClickTap() {
        
        oneListView.tapBlock = { [weak self] in
            guard let self = self else { return }
            self.chooseView(type: .cardorface)
        }
        
        twoListView.tapBlock = { [weak self] in
            guard let self = self else { return }
            self.chooseView(type: .cardorface)
        }
        
    }
}

extension FaceViewController {
    
    private func chooseView(type: UploadClickType) {
        
        let oneStr = viewModel.model?.cylind?.terraetic?.thero ?? ""
        
        let twoStr = viewModel.model?.cylind?.rockeur?.thero ?? ""
        
        if oneStr.isEmpty {
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                self.alertPopCardView()
            }else {
                self.clickCamera(type: "11")
            }
            return
        }
        
        if twoStr.isEmpty {
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                self.alertPopFaceView()
            }else {
                self.clickCamera(type: "10")
            }
            return
        }
        
        if type == .next {
            self.productDetailInfo()
        }
        
    }
    
    private func alertPopCardView() {
        let popView = PopAlertCardView(frame: self.view.bounds)
        popView.bgImageView.image = UIImage(named: "pop_ceard_image")
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        popView.sureBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.clickCamera(type: "11")
            }
        }
    }
    
    private func alertPopFaceView() {
        let popView = PopAlertCardView(frame: self.view.bounds)
        popView.bgImageView.image = UIImage(named: "pop_cfd_image")
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        popView.sureBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.clickCamera(type: "10")
            }
        }
    }
    
    private func clickCamera(type: String) {
        if type == "10" {
            self.uploadType = "face"
            CameraManager.shared.toggleCamera()
        }else {
            self.uploadType = "card"
        }
        CameraManager.shared.showCamera(from: self) { [weak self] imageData in
            guard let self = self else { return }
            if let imageData = imageData {
                let parameters = ["pathyish": type,
                                  "meteractuallyable": "2",
                                  "agriature": "",
                                  "hom": "1"]
                viewModel.uploadFaceInfo(parameters: parameters, imageData: imageData)
            }
        }
    }
    
}

extension FaceViewController {
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    let oneStr = model.cylind?.terraetic?.thero ?? ""
                    let twoStr = model.cylind?.rockeur?.thero ?? ""
                    
                    if !oneStr.isEmpty {
                        self.oneListView.logoImageView.image = UIImage(named: "scq_icon_image")
                    }
                    
                    if !twoStr.isEmpty {
                        self.twoListView.logoImageView.image = UIImage(named: "scq_icon_image")
                    }
                    
                }
                self.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        
        viewModel.$uploadmodel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    if self.uploadType == "face" {
                        self.productDetailInfo()
                    }else {
                        let fodment = model.cylind?.fodment ?? 1
                        if fodment == 0 {
                            self.findFaceinfo()
                        }else {
                            if let cylindModel = model.cylind {
                                self.alertPopSureView(with: cylindModel)
                            }
                        }
                    }
                }else {
                    ToastWindowManager.showMessage(model.plurimon ?? "")
                }
            }
            .store(in: &cancellables)
        
        viewModel.$savemodel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    self.dismiss(animated: true)
                    self.findFaceinfo()
                }else {
                    ToastWindowManager.showMessage(model.plurimon ?? "")
                }
            }
            .store(in: &cancellables)
        
        productViewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }
                let lentfier = model.lentfier ?? ""
                if lentfier == "0" || lentfier == "00" {
                    if let cylindModel = model.cylind {
                        self.toNextVC(with: cylindModel)
                    }
                }
                
            }
            .store(in: &cancellables)
        
        
    }
    
    private func findFaceinfo() {
        let parameters = ["allate": cylindModel?.seish?.side ?? ""]
        viewModel.faceInfo(parameters: parameters)
    }
    
}

extension FaceViewController {
    
    private func productDetailInfo() {
        let parameters = ["allate": cylindModel?.seish?.side ?? "", "fell": "1"]
        productViewModel.detailInfo(parameters: parameters)
    }
    
    private func saveInfo(name: String, number: String, time: String) {
        let reportard = cylindModel?.seish?.cultural ?? ""
        let allate = cylindModel?.seish?.side ?? ""
        var parameters = ["tele": time,
                          "hab": number,
                          "trueacle": name,
                          "misoile": LoginManager.shared.getPhone() ?? "",
                          "reportard": reportard,
                          "allate": allate]
        if LanguageManager.shared.getCurrentLanguage() == .english {
            parameters["pathyish"] = "11"
        }
        viewModel.saveInfo(parameters: parameters)
    }
    
}

extension FaceViewController {
    
    private func alertPopSureView(with model: cylindModel) {
        let popView = PopSureCardMessageView(frame: self.view.bounds)
        
        popView.model = model
        
        let alertVc = TYAlertController(alert: popView, preferredStyle: .actionSheet)
        
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.sureBlock = { [weak self] in
            guard let self = self else { return }
            let name = popView.oneView.phoneTextFiled.text ?? ""
            let number = popView.twoView.phoneTextFiled.text ?? ""
            let time = popView.threeView.phoneTextFiled.text ?? ""
            self.saveInfo(name: name, number: number, time: time)
        }
        
        popView.tapTimeBlock = { [weak self] time, timeTx in
            guard let self = self else { return }
            self.popTimeView(with: time, timeTx: timeTx)
        }
        
    }
    
    private func popTimeView(with time: String, timeTx: UITextField) {
        let datePicker = DatePickerView(dateString: time)
        datePicker.onDateSelected = { dateString in
            timeTx.text = dateString
        }
        datePicker.onDismiss = {}
        datePicker.show()
    }
    
}

extension FaceViewController {
    
    private func dpAppInfo() {
        let parameters = ["noweer": "",
                          "scorear": "1",
                          "cultural": "",
                          "foss": stime,
                          "micrial": String(Int(Date().timeIntervalSince1970))]
        viewModel.uploadPointInfo(parameters: parameters)
    }
    
}
