//
//  HomeViewController.swift
//  TemperatureConverter
//
//  Created by maciej.helmecki on 18/10/2022.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private enum Constants {
        static let marginOffset: CGFloat = 24.0
        static let stackViewSpacing: CGFloat = 32.0
        static let boxViewSpacing: CGFloat = 8.0
    }

    // MARK: - Properties
    static let labelConfiguration: (UILabel) -> Void = {
        $0.textColor = .lightGray
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }

    static let boxStackViewConfiguration: (UIStackView) -> Void = {
        $0.axis = .vertical
        $0.spacing = Constants.boxViewSpacing
    }

    static let underlineViewConfiguration: (UIView) -> Void = {
        $0.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        $0.backgroundColor = .systemGray6
    }

    var viewModel: HomeViewModel!
    private var test: String = "0.0"

    // MARK: - UI elements
    let stackView = UIStackView().configure {
        $0.axis = .vertical
        $0.spacing = Constants.stackViewSpacing
    }

    let stackView2 = UIStackView().configure {
        $0.axis = .horizontal
        $0.spacing = 16.0
        $0.distribution = .fillEqually
    }

    let headlineLabel = UILabel().configure {
        $0.text = "Temperature converter"
        $0.textColor = .black
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.textAlignment = .center
    }

    let degreesBoxStackView = UIStackView().configure(HomeViewController.boxStackViewConfiguration)
    let temperatureTitleLabel = UILabel().configure(HomeViewController.labelConfiguration)
    let degreesTextView = UITextView().configure {
        $0.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textColor = .darkGray
    }

    let typeBoxStackView = UIStackView().configure(HomeViewController.boxStackViewConfiguration)
    let typeTitleLabel = UILabel()
        .configure(HomeViewController.labelConfiguration)
        .configure { $0.text = "Type" }
    let typeButton = UIButton(type: .system).configure {
        $0.setTitle("Fahrenheit", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        $0.contentHorizontalAlignment = .leading
    }

    let resultBoxStackView = UIStackView().configure(HomeViewController.boxStackViewConfiguration)
    let resultTitleLabel = UILabel()
        .configure(HomeViewController.labelConfiguration)
        .configure { $0.text = "Result" }
    let resultLabel = UILabel().configure {
        $0.text = "22.222"
        $0.textColor = .darkGray
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }

    let convertButton = UIButton(type: .system).configure {
        $0.setTitle("Convert", for: .normal)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

private extension HomeViewController {
    // MARK: - Methods
    func setupView() {
        view.backgroundColor = .white

        [temperatureTitleLabel, degreesTextView, UIView().configure(HomeViewController.underlineViewConfiguration)]
            .forEach(degreesBoxStackView.addArrangedSubview)
        [typeTitleLabel, typeButton, UIView().configure(HomeViewController.underlineViewConfiguration)]
            .forEach(typeBoxStackView.addArrangedSubview)
        [resultTitleLabel, resultLabel, UIView().configure(HomeViewController.underlineViewConfiguration)]
            .forEach(resultBoxStackView.addArrangedSubview)

        [degreesBoxStackView, typeBoxStackView].forEach(stackView2.addArrangedSubview)
        view.addSubview(stackView)
        [
            headlineLabel,
            stackView2,
            resultBoxStackView,
            convertButton
        ].forEach(stackView.addArrangedSubview)

        stackView.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.marginOffset)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-Constants.marginOffset)
        }
//        installConstraints()
    }

//    func installConstraints() {
//        headlineLabel.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.marginOffset)
//            $0.centerX.equalToSuperview()
//        }
//
//        convertButton.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.marginOffset)
//        }
//    }

    @objc func convert() {
        viewModel.input.convert(Float(test)!)
    }

    func bind() {
        convertButton.addTarget(self, action: #selector(convert), for: .touchUpInside)

        viewModel.updateOutput = { [weak self] output in
            self?.temperatureTitleLabel.text = output.temperatureTitleLabel
            self?.resultLabel.text = output.resultValue.description

            self?.typeButton.setTitle(output.typeValueLabel, for: .normal)
        }
    }
}
