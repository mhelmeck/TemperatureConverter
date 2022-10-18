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
    }

    // MARK: - Properties
    let headlineLabel = UILabel().configure {
        $0.text = "Temperature converter"
        $0.textColor = .black
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
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
        view.backgroundColor = .systemGray6

        view.addSubview(headlineLabel)
        headlineLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.marginOffset)
            $0.centerX.equalToSuperview()
        }
    }

    func bind() {}
}
