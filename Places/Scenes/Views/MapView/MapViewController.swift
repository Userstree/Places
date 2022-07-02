import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate: AnyObject {
    func locationIndexDidChange(_ index: Int)
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate, AddLocationActivityProtocol {

    weak var delegate: MapViewControllerDelegate?

    var locationIndex = 0 {
        didSet {
            guard let count = pointsOnMap?.count else {
                return
            }
            if locationIndex > count - 1 {
                locationIndex = 0
            }
            if locationIndex < 0 {
                locationIndex = count - 1
            }
            if let location = pointsOnMap?[locationIndex].location2D {
                render(location)
                delegate?.locationIndexDidChange(locationIndex)
            }
        }
    }

    private(set) var pointsOnMap: [PointOnMap]?

    private let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    private let persistentContainer = AppDelegate.sharedAppDelegate.coreDataStack

    init(pointsOnMap: [PointOnMap]?) {
        self.pointsOnMap = pointsOnMap
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var backwardButton: UIButton = {
        let button = ChangeLocationButton(image: UIImage(systemName: "arrow.backward")!)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = ChangeLocationButton(image: UIImage(systemName: "arrow.forward")!)
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var mapModeSegmentedControl: UISegmentedControl = {
        let modes: [String] = ["Standard", "Satellite", "Hybrid"]
        let segmentedControl = UISegmentedControl(items: modes)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapModeSegmentedControlChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()

    private let manager = CLLocationManager()

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        if let locations = pointsOnMap?.map { $0.location } {
            map.addAnnotations(locations)
        }
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        configureViews()
        longPressGesture()
    }

    private func longPressGesture() {
        let longPressGestureRec = UILongPressGestureRecognizer(target: self,
                action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGestureRec.minimumPressDuration = 0.7
        longPressGestureRec.delaysTouchesBegan = true
        longPressGestureRec.delegate = self
        mapView.addGestureRecognizer(longPressGestureRec)
    }

    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

            presentAddPlaceActivity { [unowned self] titleString, detailsString in
                let annotation = Location(
                        title: titleString,
                        details: detailsString,
                        coordinate: coordinate
                )
                let location = PointOnMap(context: self.managedContext)
                location.title = titleString
                location.details = detailsString
                location.latitude = coordinate.latitude
                location.longitude = coordinate.longitude
                self.mapView.addAnnotation(annotation)
                persistentContainer.saveContext()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let point = pointsOnMap?.first {
            manager.stopUpdatingLocation()
            let location = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            render(location)
        }
    }

    private func render(_ location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = location
        mapView.addAnnotation(pin)
    }

    @objc private func backButtonTapped() {
        locationIndex -= 1
    }

    @objc private func forwardButtonTapped() {
        locationIndex += 1
    }

    @objc private func mapModeSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = .standard
            mapModeSegmentedControl.backgroundColor = .clear
        } else if sender.selectedSegmentIndex == 1 {
            mapView.mapType = .satellite
            mapModeSegmentedControl.backgroundColor = .white
        } else {
            mapView.mapType = .hybrid
            mapModeSegmentedControl.backgroundColor = .white
        }
    }

    private func configureViews() {
        [mapView, mapModeSegmentedControl, backwardButton, forwardButton].forEach(view.addSubview)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            mapModeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapModeSegmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            backwardButton.heightAnchor.constraint(equalToConstant: 45),
            backwardButton.widthAnchor.constraint(equalToConstant: 45),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backwardButton.bottomAnchor.constraint(equalTo: mapModeSegmentedControl.topAnchor, constant: -12),

            forwardButton.heightAnchor.constraint(equalToConstant: 45),
            forwardButton.widthAnchor.constraint(equalToConstant: 45),
            forwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            forwardButton.bottomAnchor.constraint(equalTo: mapModeSegmentedControl.topAnchor, constant: -12),
        ])
    }
}

extension MapViewController: EditLocationViewControllerDelegate{
    func deletePin(_ pointOnMap: PointOnMap) {
        mapView.removeAnnotation(pointOnMap.location)
        print("dasdf")
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Location.identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Location.identifier)
            annotationView?.canShowCallout = true
            annotationView?.loadCustomLines(customLines: [pointsOnMap?[locationIndex].details ?? ""])
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let pointOnMap = pointsOnMap?[locationIndex] else { return }
        let editVC = EditLocationViewController(pointOnMap: pointOnMap)
        editVC.delegate = self
        let navigationController = UINavigationController(rootViewController: editVC)
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(navigationController, animated: true)
    }
}
