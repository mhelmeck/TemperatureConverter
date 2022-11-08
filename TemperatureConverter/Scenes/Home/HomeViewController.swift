//
//  HomeViewController.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 18/10/2022.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    var viewModel: HomeViewModelInputOutput!
    var pickerDelegateDataSource: PickerDelegateDataSource!

    static var underlineView: UIView {
        UIView().configure {
            $0.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            $0.backgroundColor = .systemFill
        }
    }

    static let titleLabelConfiguration: (UILabel) -> Void = {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }

    static let stackViewConfiguration: (UIStackView) -> Void = {
        $0.axis = .vertical
        $0.spacing = 8.0
    }

    // MARK: - UI elements
    let mainStackViewWrapper = UIView().configure {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8.0
    }

    let mainStackView = UIStackView().configure {
        $0.axis = .vertical
        $0.spacing = 32.0
    }

    let headlineLabel = UILabel().configure {
        $0.text = "Temperature converter"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }

    let convertFromRowStackView = UIStackView().configure {
        $0.axis = .horizontal
        $0.spacing = 16.0
        $0.distribution = .fillEqually
    }

    let convertFromStackView = UIStackView().configure(HomeViewController.stackViewConfiguration)
    let convertFromTitleLabel = UILabel().configure(HomeViewController.titleLabelConfiguration)
    let convertFromInputTextField = UITextField().configure {
        $0.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .black
        $0.keyboardType = .numbersAndPunctuation
    }

    let convertionTypeStackView = UIStackView().configure(HomeViewController.stackViewConfiguration)
    let convertionTypeTitleLabel = UILabel()
        .configure(HomeViewController.titleLabelConfiguration)
        .configure { $0.text = "Convertion type" }
    let convertionTypeInputButton = UIButton(type: .system).configure {
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.contentHorizontalAlignment = .leading
    }
    let convertionTypePicerView = UIPickerView().configure {
        $00.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 8.0
        $0.isHidden = true
    }

    let resultStackView = UIStackView().configure(HomeViewController.stackViewConfiguration)
    let resultTitleLabel = UILabel()
        .configure(HomeViewController.titleLabelConfiguration)
    let resultOutputLabel = UILabel().configure {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    }

    let convertButton = UIButton(type: .system).configure {
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        let image = UIImage(systemName: "arrow.down.circle.fill", withConfiguration: config)

        $0.setImage(image, for: .normal)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegatesAndTargets()
        setupView()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)

        configureWithViewModel(viewModel.output)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        convertFromInputTextField.becomeFirstResponder()
    }
}

extension HomeViewController: PresentableHomeViewController {
    static func create(
        with viewModel: HomeViewModelInputOutput,
        pickerDelegateDataSource: PickerDelegateDataSource
    ) -> HomeViewController {
        let controller = HomeViewController()
        controller.viewModel = viewModel
        controller.pickerDelegateDataSource = pickerDelegateDataSource

        return controller
    }
}

// MARK: - Helpers
private extension HomeViewController {
    func setDelegatesAndTargets() {
        convertFromInputTextField.delegate = self
        convertionTypePicerView.delegate = pickerDelegateDataSource
        convertionTypePicerView.dataSource = pickerDelegateDataSource

        convertButton.addTarget(self, action: #selector(convertButtonDidSelect), for: .touchUpInside)
        convertionTypeInputButton.addTarget(self, action: #selector(typeInputButtonDidSelect), for: .touchUpInside)
        convertFromInputTextField.addTarget(
            self,
            action: #selector(convertFromInputTextFieldValueDidChange),
            for: .editingChanged
        )
    }

    func setupView() {
        view.backgroundColor = .systemGray6

        [
            convertFromTitleLabel,
            convertFromInputTextField,
            HomeViewController.underlineView
        ].forEach(convertFromStackView.addArrangedSubview)

        [convertFromStackView, convertButton].forEach(convertFromRowStackView.addArrangedSubview)

        [
            resultTitleLabel,
            resultOutputLabel
        ].forEach(resultStackView.addArrangedSubview)

        [
            convertionTypeTitleLabel,
            convertionTypeInputButton
        ].forEach(convertionTypeStackView.addArrangedSubview)

        [
            headlineLabel,
            convertFromRowStackView,
            resultStackView,
            convertionTypeStackView
        ].forEach(mainStackView.addArrangedSubview)

        mainStackViewWrapper.addSubview(mainStackView)
        mainStackViewWrapper.addSubview(convertionTypePicerView)
        view.addSubview(mainStackViewWrapper)

        installConstraints()
    }

    func installConstraints() {
        mainStackViewWrapper.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }

        mainStackView.snp.makeConstraints {
            $0.top.leading.equalTo(mainStackViewWrapper).offset(24)
            $0.trailing.equalTo(mainStackViewWrapper).offset(-24)
        }

        convertionTypePicerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(mainStackViewWrapper)
        }
    }

    func bind() {
        viewModel.emit = { [weak self] output in
            self?.configureWithViewModel(output)
        }

        pickerDelegateDataSource.didSelectRow = { [weak self] row in
            self?.viewModel.setConversionType(forRow: row)
        }
    }

    func configureWithViewModel(_ output: HomeViewModel.Output) {
        convertFromTitleLabel.text = output.convertFromTitle
        resultTitleLabel.text = output.convertToTitle
        resultOutputLabel.text = output.result

        convertionTypeInputButton.setTitle(output.conversionTypeTitle, for: .normal)
    }

    func hideTypePicerView() {
        convertionTypePicerView.isHidden = true
        convertFromInputTextField.becomeFirstResponder()
    }

    func showTypePicerView() {
        convertFromInputTextField.resignFirstResponder()
        convertionTypePicerView.isHidden = false
    }

    @objc func convertFromInputTextFieldValueDidChange() {
        viewModel.setTemperature(convertFromInputTextField.text)
    }

    @objc func typeInputButtonDidSelect() {
        showTypePicerView()
    }

    @objc func convertButtonDidSelect() {
        viewModel.convert()
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideTypePicerView()
    }
}
