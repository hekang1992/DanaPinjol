//
//  DatePickerView.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/19.
//

import UIKit
import SnapKit

class DatePickerView: UIView {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private var selectedDate: Date
    
    private let days = Array(1...31).map { String(format: "%02d", $0) }
    private let months = Array(1...12).map { String(format: "%02d", $0) }
    private let years = Array(1980...2024).map { String($0) }
    
    private var selectedDay = "01"
    private var selectedMonth = "10"
    private var selectedYear = "1992"
    
    var onDateSelected: ((String) -> Void)?
    var onDismiss: (() -> Void)?
    
    // MARK: - UI Components
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Date Selection".localized
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private let dayPickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let monthPickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let yearPickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    lazy var confirmButton: UIButton = {
        let confirmButton = UIButton(type: .custom)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.adjustsImageWhenHighlighted = false
        confirmButton.setTitle("Confirm".localized, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        confirmButton.setBackgroundImage(UIImage(named: "con_a_i_image"), for: .normal)
        confirmButton.adjustsImageWhenHighlighted = false
        return confirmButton
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "time_alert_c_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    // MARK: - Initialization
    init(dateString: String? = nil, frame: CGRect = .zero) {
        let defaultDateString = "01/10/1992"
        let dateToUse = dateString ?? defaultDateString
        
        if let date = dateFormatter.date(from: dateToUse) {
            self.selectedDate = date
        } else {
            self.selectedDate = dateFormatter.date(from: defaultDateString) ?? Date()
        }
        
        super.init(frame: frame)
        
        setInitialDate()
        
        setupUI()
        setupPickers()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(overlayView)
        addSubview(bgImageView)
        
        bgImageView.addSubview(titleLabel)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(confirmButton)
        bgImageView.addSubview(stackView)
        
        let dayContainer = createPickerContainer(with: dayPickerView)
        let monthContainer = createPickerContainer(with: monthPickerView)
        let yearContainer = createPickerContainer(with: yearPickerView)
        
        stackView.addArrangedSubview(dayContainer)
        stackView.addArrangedSubview(monthContainer)
        stackView.addArrangedSubview(yearContainer)
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 324.pix(), height: 420.pix()))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(37.pix())
            make.left.equalToSuperview().offset(16.pix())
            make.height.equalTo(20.pix())
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.width.height.equalTo(18.pix())
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(cancelBtn.snp.top).offset(-41.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 274.pix(), height: 48.pix()))
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20.pix())
            make.right.equalToSuperview().offset(-20.pix())
            make.bottom.equalTo(confirmButton.snp.top).offset(-10.pix())
        }
    }
    
    private func createPickerContainer(with pickerView: UIPickerView) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return container
    }
    
    private func setupPickers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let dayIndex = self.days.firstIndex(of: self.selectedDay) {
                self.dayPickerView.selectRow(dayIndex, inComponent: 0, animated: false)
            }
            
            if let monthIndex = self.months.firstIndex(of: self.selectedMonth) {
                self.monthPickerView.selectRow(monthIndex, inComponent: 0, animated: false)
            }
            
            if let yearIndex = self.years.firstIndex(of: self.selectedYear) {
                self.yearPickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            }
        }
    }
    
    private func setInitialDate() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: selectedDate)
        
        if let day = components.day {
            selectedDay = String(format: "%02d", day)
        }
        if let month = components.month {
            selectedMonth = String(format: "%02d", month)
        }
        if let year = components.year {
            selectedYear = String(year)
        }
        
    }
    
    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func confirmButtonTapped() {
        let dateString = "\(selectedDay)/\(selectedMonth)/\(selectedYear)"
        onDateSelected?(dateString)
        dismiss()
    }
    
    @objc private func overlayTapped() {
        dismiss()
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.onDismiss?()
        }
    }
    
    // MARK: - Public Methods
    func show() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        window.addSubview(self)
        
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension DatePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case dayPickerView:
            return days.count
            
        case monthPickerView:
            return months.count
            
        case yearPickerView:
            return years.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case dayPickerView:
            return days[row]
            
        case monthPickerView:
            return months[row]
            
        case yearPickerView:
            return years[row]
            
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case dayPickerView:
            selectedDay = days[row]
            
        case monthPickerView:
            selectedMonth = months[row]
            
        case yearPickerView:
            selectedYear = years[row]
            
        default:
            break
        }
        
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        var text = ""
        switch pickerView {
            
        case dayPickerView:
            text = days[row]
            
        case monthPickerView:
            text = months[row]
            
        case yearPickerView:
            text = years[row]
            
        default:
            break
        }
        label.text = text
        
        let selectedRow = pickerView.selectedRow(inComponent: component)
        if row == selectedRow {
            label.textColor = UIColor.init(hexString: "#3D955E")
        } else {
            label.textColor = UIColor.init(hexString: "#6F7A75")
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
