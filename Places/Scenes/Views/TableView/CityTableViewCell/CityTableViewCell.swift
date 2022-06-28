//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit


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
        stack.backgroundColor = .clear
        stack.alignment = .fill
        return stack
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureViews()
    }

    func configure(with model: PointsTableViewCellDataSource) {
        cityNameLabel.text = model.title
        let latitude = String(format: "Lat: %.2f", model.coordinate.latitude)
        let longitude = String(format: "Lon: %.2f", model.coordinate.longitude)
        cityLocationLabel.text = "\(latitude)\t&\t\(longitude) "
    }

    private func configureViews() {
        contentView.addSubview(mainVStack)
        contentView.backgroundColor = .clear
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
