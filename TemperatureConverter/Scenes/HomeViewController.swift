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
        .configure { $0.text = "Type" }
    let typeInputButton = UIButton(type: .system).configure {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.contentHorizontalAlignment = .leading
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

        configureWithViewModel(viewModel.getCurrent())
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

        convertButton.addTarget(self, action: #selector(convert), for: .touchUpInside)
    }

    func setupView() {
        view.backgroundColor = .systemGray6

        view.addSubview(mainStackViewWrapper)
        mainStackViewWrapper.addSubview(mainStackView)

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
    }

    func bind() {
        viewModel.emit = { [weak self] output in
            self?.configureWithViewModel(output)
        }
    }

    func configureWithViewModel(_ output: HomeViewModel.Output) {
        temperatureTitleLabel.text = output.temperatureTitle
        resultOutputLabel.text = output.result

        typeInputButton.setTitle(output.typeTitle, for: .normal)
    }

    @objc func convert() {
        viewModel.input.convert(temperatureInputTextField.text)
    }
}

extension HomeViewController: UITextFieldDelegate {}
