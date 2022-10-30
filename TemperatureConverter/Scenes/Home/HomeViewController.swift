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
    var viewModel: HomeViewModel!
    var pickerDelegateDataSource: PickerDelegateDataSource!

    static var underlineView: UIView {
        UIView().configure {
            $0.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            $0.backgroundColor = .systemFill
        }
    }

    static let titleLabelConfiguration: (UILabel) -> Void = {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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

    let inputsStackView = UIStackView().configure {
        $0.axis = .horizontal
        $0.spacing = 16.0
        $0.distribution = .fillEqually
    }

    let temperatureStackView = UIStackView().configure(HomeViewController.stackViewConfiguration)
    let temperatureTitleLabel = UILabel().configure(HomeViewController.titleLabelConfiguration)
    let temperatureInputTextField = UITextField().configure {
        $0.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .black
        $0.keyboardType = .numbersAndPunctuation
    }

    let typeStackView = UIStackView().configure(HomeViewController.stackViewConfiguration)
    let typeTitleLabel = UILabel()
        .configure(HomeViewController.titleLabelConfiguration)
        .configure { $0.text = "Result type" }
    let typeInputButton = UIButton(type: .system).configure {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.contentHorizontalAlignment = .leading
    }
    let typePicerView = UIPickerView().configure {
        $00.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 8.0
        $0.isHidden = true
    }

    let resultStackView = UIStackView().configure(HomeViewController.stackViewConfiguration)
    let resultTitleLabel = UILabel()
        .configure(HomeViewController.titleLabelConfiguration)
        .configure { $0.text = "Result" }
    let resultOutputLabel = UILabel().configure {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    }

    let convertButton = UIButton(type: .system).configure {
        $0.setTitle("Convert", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        $0.layer.cornerRadius = 8.0
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

        temperatureInputTextField.becomeFirstResponder()
    }
}

// MARK: - Helpers
private extension HomeViewController {
    func setDelegatesAndTargets() {
        temperatureInputTextField.delegate = self
        typePicerView.delegate = pickerDelegateDataSource
        typePicerView.dataSource = pickerDelegateDataSource

        convertButton.addTarget(self, action: #selector(convertButtonDidSelect), for: .touchUpInside)
        typeInputButton.addTarget(self, action: #selector(typeInputButtonDidSelect), for: .touchUpInside)
        temperatureInputTextField.addTarget(
            self,
            action: #selector(temperatureInputTextFieldValueDidChange),
            for: .editingChanged
        )
    }

    func setupView() {
        view.backgroundColor = .systemGray6

        [
            temperatureTitleLabel,
            temperatureInputTextField,
            HomeViewController.underlineView
        ].forEach(temperatureStackView.addArrangedSubview)
        [
            typeTitleLabel,
            typeInputButton,
            HomeViewController.underlineView
        ].forEach(typeStackView.addArrangedSubview)
        [temperatureStackView, typeStackView].forEach(inputsStackView.addArrangedSubview)

        [
            resultTitleLabel,
            resultOutputLabel,
            HomeViewController.underlineView
        ].forEach(resultStackView.addArrangedSubview)

        [
            headlineLabel,
            inputsStackView,
            resultStackView,
            convertButton
        ].forEach(mainStackView.addArrangedSubview)

        mainStackViewWrapper.addSubview(mainStackView)
        mainStackViewWrapper.addSubview(typePicerView)
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

        typePicerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(mainStackViewWrapper)
        }
    }

    func bind() {
        viewModel.emit = { [weak self] output in
            self?.configureWithViewModel(output)
        }

        pickerDelegateDataSource.didSelectRow = { [weak self] row in
            self?.viewModel.setType(forRow: row)
        }
    }

    func configureWithViewModel(_ output: HomeViewModel.Output) {
        temperatureTitleLabel.text = output.temperatureTitle
        resultOutputLabel.text = output.result

        typeInputButton.setTitle(output.typeTitle, for: .normal)
    }

    func hideTypePicerView() {
        typePicerView.isHidden = true
        temperatureInputTextField.becomeFirstResponder()
    }

    func showTypePicerView() {
        temperatureInputTextField.resignFirstResponder()
        typePicerView.isHidden = false
    }
}

extension HomeViewController {
    @objc func temperatureInputTextFieldValueDidChange() {
        viewModel.setTemperature(temperatureInputTextField.text)
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
