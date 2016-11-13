//
//  LocationListViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 12/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var uiPlaces: UITableView!
    var places = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()

        uiPlaces.delegate   = self
        uiPlaces.dataSource = self
        //locations.setEditing(true, animated: true)

        places = Place.retrieveAllPlaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addLocation() {
        performSegue(withIdentifier: "segueToLocationFinder", sender: nil)
    }

    @IBAction func clearLocations() {
        Place.clearAllPlaces()
        places = [Place]()
        uiPlaces.reloadData()
    }

    @IBAction func unwindToLocationListVC(segue: UIStoryboardSegue) {
        // Here you can receive the parameter(s) from secondVC
        if segue.source is LocationFinderViewController {
            places = Place.retrieveAllPlaces()
            uiPlaces.reloadData()
        }
    }
}

extension LocationListViewController /*: UITableViewDataSource */ {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 0 else {
            Place.clearDefaultPlace()
            self.performSegue(withIdentifier: "unwindToMainVC", sender: self)
            return
        }
        let place = places[indexPath.row - 1]
        print(place.name)
        Place.storeDefaultPlace(place)
        self.performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Your current location"
            cell.detailTextLabel?.text = ""
        } else {
            cell.textLabel?.text = places[indexPath.row - 1].name
            cell.detailTextLabel?.text = places[indexPath.row - 1].region
        }
        return cell
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            places.remove(at: indexPath.row - 1)
            Place.storeAllPlaces(places)
            uiPlaces.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Don't move the first row.
        guard indexPath.row > 0 else {
            return false
        }
        return true
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return IndexPath.init(row: 1, section: 0)
        }
        return proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard destinationIndexPath.row > 0 else {
            return
        }
        let place = places[sourceIndexPath.row - 1]
        places.remove(at: sourceIndexPath.row - 1)
        places.insert(place, at: destinationIndexPath.row - 1)
        Place.storeAllPlaces(places)
        uiPlaces.reloadData()
    }
}

extension LocationListViewController: UITableViewDelegate {

}
