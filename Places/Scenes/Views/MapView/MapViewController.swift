import UIKit
import MapKit

protocol MapViewControllerDelegate: AnyObject {
    func locationIndexDidChange(_ index: Int)
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate, AddLocationActivityProtocol, MapViewBottomItemsDelegate {

    private let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext

    private let persistentContainer = AppDelegate.sharedAppDelegate.coreDataStack

    weak var delegate: MapViewControllerDelegate?

    var locationIndex = 0 {
        didSet {
            guard let count = viewModel.pointsOnMap?.count else {
                return
            }
            if locationIndex > count - 1 {
                locationIndex = 0
            }
            if locationIndex < 0 {
                locationIndex = count - 1
            }
            if let location = viewModel.pointsOnMap?[locationIndex].location2D {
                render(location)
                delegate?.locationIndexDidChange(locationIndex)
            }
        }
    }

    private var viewModel: LocationsViewModel

    init(viewModel: LocationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) hasn't been implemented")
    }

    private lazy var mapViewBottomItems: MapControlItemsView = {
        let view = MapControlItemsView(viewModel: viewModel)
        view.delegate = self
        return view
    }()

    private let manager = CLLocationManager()

    private lazy var mainMapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.delegate = self
        if let locations = viewModel.pointsOnMap?.map({ $0.location }) {
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
        mainMapView.addGestureRecognizer(longPressGestureRec)
    }

    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            let point = gesture.location(in: mainMapView)
            let coordinate = mainMapView.convert(point, toCoordinateFrom: mainMapView)

            presentAddPlaceActivity { [unowned self] titleString, detailsString in
                let annotation = Location(
                        title: titleString,
                        details: detailsString,
                        coordinate: coordinate
                )
                let location = PointOnMap(context: managedContext)
                location.title = titleString
                location.details = detailsString
                location.latitude = coordinate.latitude
                location.longitude = coordinate.longitude
                viewModel.appendPoint(point: location)
                mainMapView.addAnnotation(annotation)
                persistentContainer.saveContext()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let point = viewModel.pointsOnMap?.first {
            manager.stopUpdatingLocation()
            let location = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            render(location)
        }
    }

    private func render(_ location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mainMapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = location
        mainMapView.addAnnotation(pin)
    }

    func forwardButtonTapped(locationIndex: Int) {
        self.locationIndex += locationIndex
    }

    func backButtonTapped(locationIndex: Int) {
        self.locationIndex += locationIndex
    }

    func mapModeSegmentedControlTapped(selectedSegmentIndex: Int) {
        if selectedSegmentIndex == 0 {
            mainMapView.mapType = .standard
        } else if selectedSegmentIndex == 1 {
            mainMapView.mapType = .satellite
        } else {
            mainMapView.mapType = .hybrid
        }
    }

    private func configureViews() {
        add(mapViewBottomItems, frame: view.frame)
        [mainMapView, mapViewBottomItems.view].forEach(view.addSubview)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainMapView.topAnchor.constraint(equalTo: view.topAnchor),
            mainMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            mapViewBottomItems.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MapViewController: EditLocationViewControllerDelegate{
    func deletePin(_ pointOnMap: PointOnMap) {
        mainMapView.removeAnnotation(pointOnMap.location)
        viewModel.pointsOnMap?.remove(at: locationIndex)
        managedContext.delete(pointOnMap)
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
            annotationView?.loadCustomLines(customLines: [viewModel.pointsOnMap?[locationIndex].details ?? ""])
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    public func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let pointsOnMap = viewModel.pointsOnMap, let annotationTitle = view.annotation?.title  else { return }
        let titles = pointsOnMap.map { $0.title }
        guard let index = titles.firstIndex(of: annotationTitle!) else {
            fatalError("guard failure handling has not been implemented")
        }
        locationIndex = index
    }

    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let editVC = EditLocationViewController(pointOnMapIndex: locationIndex, viewModel: viewModel)
        editVC.delegate = self
        let navigationController = UINavigationController(rootViewController: editVC)
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(navigationController, animated: true)
    }
}
