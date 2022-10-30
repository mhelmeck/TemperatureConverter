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
    static let labelConfiguration: (UILabel) -> Void = {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    static let boxStackViewConfiguration: (UIStackView) -> Void = {
        $0.axis = .vertical
        $0.spacing = 8.0
    }

    static let underlineViewConfiguration: (UIView) -> Void = {
        $0.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        $0.backgroundColor = .systemGray6
    }

    var viewModel: HomeViewModel!

    // MARK: - UI elements
    let stackView = UIStackView().configure {
        $0.axis = .vertical
        $0.spacing = 32.0
    }

    let stackViewWrapper = UIView().configure {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8.0
    }

    let stackView2 = UIStackView().configure {
        $0.axis = .horizontal
        $0.spacing = 16.0
        $0.distribution = .fillEqually
    }

    let headlineLabel = UILabel().configure {
        $0.text = "Temperature converter"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }

    let degreesBoxStackView = UIStackView().configure(HomeViewController.boxStackViewConfiguration)
    let temperatureTitleLabel = UILabel().configure(HomeViewController.labelConfiguration)
    let degreesTextField = UITextField().configure {
        $0.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .black
        $0.keyboardType = .numbersAndPunctuation
    }

    let typeBoxStackView = UIStackView().configure(HomeViewController.boxStackViewConfiguration)
    let typeTitleLabel = UILabel()
        .configure(HomeViewController.labelConfiguration)
        .configure { $0.text = "Type" }
    let typeButton = UIButton(type: .system).configure {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.contentHorizontalAlignment = .leading
    }

    let resultBoxStackView = UIStackView().configure(HomeViewController.boxStackViewConfiguration)
    let resultTitleLabel = UILabel()
        .configure(HomeViewController.labelConfiguration)
        .configure { $0.text = "Result" }
    let resultLabel = UILabel().configure {
        $0.text = "22.222"
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

        setupView()
        bind()

        degreesTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
        configureWithViewModel(viewModel.getCurrent())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        degreesTextField.becomeFirstResponder()
    }
}

private extension HomeViewController {
    // MARK: - Methods
    func setupView() {
        view.backgroundColor = .systemGray6

        [temperatureTitleLabel, degreesTextField, UIView().configure(HomeViewController.underlineViewConfiguration)]
            .forEach(degreesBoxStackView.addArrangedSubview)
        [typeTitleLabel, typeButton, UIView().configure(HomeViewController.underlineViewConfiguration)]
            .forEach(typeBoxStackView.addArrangedSubview)
        [resultTitleLabel, resultLabel, UIView().configure(HomeViewController.underlineViewConfiguration)]
            .forEach(resultBoxStackView.addArrangedSubview)

        [degreesBoxStackView, typeBoxStackView].forEach(stackView2.addArrangedSubview)

        view.addSubview(stackViewWrapper)
        stackViewWrapper.addSubview(stackView)

        [
            headlineLabel,
            stackView2,
            resultBoxStackView,
            convertButton
        ].forEach(stackView.addArrangedSubview)

        stackViewWrapper.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }

        stackView.snp.makeConstraints {
            $0.top.leading.equalTo(stackViewWrapper).offset(24)
            $0.trailing.bottom.equalTo(stackViewWrapper).offset(-24)
        }
    }

    @objc func convert() {
        viewModel.input.convert(degreesTextField.text)
    }

    func bind() {
        convertButton.addTarget(self, action: #selector(convert), for: .touchUpInside)

        viewModel.updateOutput = { [weak self] output in
            self?.configureWithViewModel(output)
        }
    }

    private func configureWithViewModel(_ output: HomeViewModel.HomeViewModelOutput) {
        temperatureTitleLabel.text = output.temperatureTitleLabel
        resultLabel.text = output.resultValue

        typeButton.setTitle(output.typeValueLabel, for: .normal)
    }
}

extension HomeViewController: UITextFieldDelegate {}
