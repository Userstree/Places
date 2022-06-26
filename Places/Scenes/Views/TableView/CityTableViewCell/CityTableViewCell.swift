//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    static let identifier = "CityTableViewCell"

    private var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private var cityLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()

    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView(viewElements: [cityNameLabel, cityLocationLabel])
        stack.alignment = .fill
        return stack
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureViews()
    }

    func configure(with model: CityItem) {
        cityNameLabel.text = model.cityName
    }

    private func configureViews() {
        contentView.addSubview(mainVStack)

        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
