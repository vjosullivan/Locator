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
    let placeManager = PlaceManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        uiPlaces.delegate   = self
        uiPlaces.dataSource = self
        //locations.setEditing(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addLocation() {
        performSegue(withIdentifier: "segueToLocationFinder", sender: nil)
    }

    @IBAction func clearLocations() {
        placeManager.clear()
        uiPlaces.reloadData()
    }

    @IBAction func returnAction() {
        self.performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }

    @IBAction func unwindToLocationListVC(segue: UIStoryboardSegue) {
        // Here you can receive the parameter(s) from secondVC
        if segue.source is LocationFinderViewController {
            placeManager.refresh()
            uiPlaces.reloadData()
        }
    }
}

extension LocationListViewController /*: UITableViewDataSource */ {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 0 else {
            PlaceManager.clearDefaultPlace()
            self.performSegue(withIdentifier: "unwindToMainVC", sender: self)
            return
        }
        placeManager.storeDefaultPlace(indexPath.row - 1)
        self.performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Allow an extra row for the "current location" option.
        return placeManager.placeCount + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Your current location"
            cell.detailTextLabel?.text = ""
        } else {
            cell.textLabel?.text       = placeManager.place(at: indexPath.row - 1).name
            cell.detailTextLabel?.text = placeManager.place(at: indexPath.row - 1).region
        }
        return cell
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            placeManager.removePlace(at: indexPath.row - 1)
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

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return IndexPath.init(row: 1, section: 0)
        }
        return proposedDestinationIndexPath
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard destinationIndexPath.row > 0 else {
            return
        }
        placeManager.movePlace(from: sourceIndexPath.row - 1, to: destinationIndexPath.row - 1)
        uiPlaces.reloadData()
    }
}

extension LocationListViewController: UITableViewDelegate {

}
