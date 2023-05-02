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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gpxData = gpxDataArray[indexPath.row]
        
        let detailsViewController = LocationDetailViewController()
        detailsViewController.gpxData = gpxData
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
