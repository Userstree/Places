//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    static let identifier = "CityTableViewCell"

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView(viewElements: [titleLabel, detailsLabel])
        stack.backgroundColor = .clear
        stack.alignment = .fill
        return stack
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureViews()
    }

    func configure(with model: PointsTableViewCellDataSource) {
        titleLabel.text = model.title
        detailsLabel.text = "\(model.details)"
    }

    private func configureViews() {
        contentView.addSubview(mainVStack)
        contentView.backgroundColor = .clear
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
