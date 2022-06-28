//
// Created by Dossymkhan Zhulamanov on 19.06.2022.
//

import UIKit
import MapKit

protocol PointsViewModel {
    var pointsModel: [Point] { get }
    func appendPoint(point: Point)
    func removePoint(point: Point)
    var updateLocation: PointsCallback? { get set }
    init(model: [Point])
}

typealias PointsCallback = () -> ()

final class DefaultPointsViewModel: PointsViewModel {

    var updateLocation: PointsCallback?

    var pointsModel = [Point]() {
        didSet {
            updateLocation?()
        }
    }

    required init(model: [Point]) {
        pointsModel = model
    }

    func appendPoint(point: Point) {
        pointsModel.append(point)
        updateLocation?()
    }

    func removePoint(point: Point) {
        pointsModel = pointsModel.filter { $0 !== point }
        updateLocation?()
    }
}