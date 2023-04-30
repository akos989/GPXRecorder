//
//  LocationTableViewController.swift
//  GPXRecorder
//
//  Created by Morvai Ákos on 2023. 04. 30..
//

import RxCocoa
import RxSwift
import UIKit

class LocationTableViewController: UITableViewController {
    let disposeBag = DisposeBag()
    var gpxDataArray = [GpxData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Routes"
        gpxDataArray = RecorderService.shared.gpxDataArray
        setupBindings()
    }
    
    func setupBindings() {
        RecorderService.shared.gpxDataArrayChangedSubject
            .subscribe(onNext: { [weak self] gpxData in
                self?.gpxDataArray = gpxData
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gpxDataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)

        let gpxData = gpxDataArray[indexPath.row]
        
        cell.textLabel?.text = "\(gpxData.wpt[0].time)"
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
