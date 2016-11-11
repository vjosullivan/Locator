//
//  ViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 08/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultText: UITextView!
    
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
        
        // Set bounds to inner-west Sydney Australia.
        let neBoundsCorner = CLLocationCoordinate2D(latitude: 51.4, longitude: -1.1)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: 51.2, longitude: -0.9)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner, coordinate: swBoundsCorner)
        
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.region
        
        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        
        textField?.addTarget(self, action: #selector(ViewController.textFieldDidChange(textField:)), for: .editingChanged)
        
        resultText?.text = "No Results"
        resultText?.isEditable = false
    }

    func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//let placesClient = GMSPlacesClient()
//placesClient.lookUpPlaceID(<#T##placeID: String##String#>, callback: <#T##GMSPlaceResultCallback##GMSPlaceResultCallback##(GMSPlace?, Error?) -> Void#>)

extension ViewController: GMSAutocompleteFetcherDelegate, UITableViewDataSource {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        var results = ""
        places.removeAll()
        print("Matches: \(predictions.count)")
        for prediction in predictions {
            //dump(prediction)
            results += "\(prediction.attributedPrimaryText.string)  \(prediction.attributedSecondaryText!.string)  \(prediction.placeID)\n"
            places.append(Place(
                name: prediction.attributedPrimaryText.string,
                region: prediction.attributedSecondaryText!.string,
                placeID: prediction.placeID))
        }
        resultText?.text = results
        DispatchQueue.main.async{
            self.placeTable.reloadData()
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("F")
        resultText?.text = error.localizedDescription
    }
}

extension ViewController /* UITableViewDataSource extension */ {
    
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
        placesClient.lookUpPlaceID(places[indexPath.row].placeID!) { (place: GMSPlace?, error: Error?) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            let message: String
            if let place = place {
                message = "\(place.formattedAddress ?? self.places[indexPath.row].region)\n(\((10 * place.coordinate.latitude).rounded() / 10.0)°N, \((10 * place.coordinate.longitude).rounded() / 10.0)°E)"
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place placeID \(place.placeID)")
                print("Place attributions \(place.attributions)")
                print("Coordinates: \(place.coordinate)")
            } else {
                message = "\(self.places[indexPath.row].region)\nNo place details found."
            }
            let alert = UIAlertController(title: self.places[indexPath.row].name, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: UITableViewDelegate {

}

struct Place {
    let name: String
    let region: String
    let placeID: String?
}
