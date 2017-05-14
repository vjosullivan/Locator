//
//  ViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 08/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationFinderViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var placeTable: UITableView!

    var fetcher: GMSAutocompleteFetcher?
    var places = [Place]()

    let regularFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    let boldFont    = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)

    override func viewDidLoad() {
        super.viewDidLoad()

        placeTable.delegate = self
        placeTable.dataSource = self

        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = []

        // Create the fetcher.
        fetcher = configureFetcher()

        textField.becomeFirstResponder()
        textField?.addTarget(self, action: #selector(LocationFinderViewController.textFieldDidChange(textField:)),
                             for: .editingChanged)
    }

    func configureFetcher() -> GMSAutocompleteFetcher {
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.region

        let neBoundsCorner = CLLocationCoordinate2D(latitude: 51.4, longitude: -1.1)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: 51.2, longitude: -0.9)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner, coordinate: swBoundsCorner)

        let fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher.delegate = self
        return fetcher
    }

    func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func found(_ place: GMSPlace) {
        PlaceManager().add(Place(
            name: place.name,
            region: place.formattedAddress ?? "",
            placeID: place.placeID,
            latitude: place.coordinate.latitude,
            longitude: place.coordinate.longitude))

        performSegue(withIdentifier: "unwindToLocationListVC", sender: nil)
    }
}

extension LocationFinderViewController: GMSAutocompleteFetcherDelegate, UITableViewDataSource {

    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        var results = ""
        places.removeAll()
        for prediction in predictions {
            results += "\(prediction.attributedPrimaryText.string)  " +
                "\(prediction.attributedSecondaryText!.string)  \(prediction.placeID ?? "")\n"
            places.append(Place(
                name: prediction.attributedPrimaryText.string,
                region: prediction.attributedSecondaryText!.string,
                placeID: prediction.placeID!,
                latitude: 0.0,
                longitude: 0.0))
        }
        DispatchQueue.main.async {
            self.placeTable.reloadData()
        }
    }

    func didFailAutocompleteWithError(_ error: Error) {
        // Ignore this error and let the user continue.
    }
}

extension LocationFinderViewController /* UITableViewDataSource extension */ {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        cell.detailTextLabel?.text = places[indexPath.row].region
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placesClient = GMSPlacesClient()
        let placeID = places[indexPath.row].placeID
        placesClient.lookUpPlaceID(placeID) { (place: GMSPlace?, error: Error?) -> Void in
            if let error = error {
                self.displayAlert(title: "Place Name Lookup",
                                  text: "Something wierd happened (see below) when looking up this place.  Try again.",
                                  error: error)
                return
            }
            if let place = place {
                self.found(place)
            } else {
                self.displayAlert(title: "It's Out There Somewhere",
                                  text: "Where ever it was, it's gone.  Has it moved?  It may be worth trying again.",
                                  error: nil)
                return
            }
        }
    }

    private func displayAlert(title: String, text: String, error: Error?) {
        let message = error == nil ? text : text + "\n\n\(error!)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LocationFinderViewController: UITableViewDelegate {

}
