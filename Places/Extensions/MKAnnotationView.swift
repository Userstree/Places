//
// Created by Dossymkhan Zhulamanov on 30.06.2022.
//

import MapKit

extension MKAnnotationView {

    func loadCustomLines(customLines: [String]) {
        let stackView = stackView()
        for line in customLines {
            let label = UILabel()
            label.text = line
            stackView.addArrangedSubview(label)
        }
        detailCalloutAccessoryView = stackView
    }

    private func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }
}