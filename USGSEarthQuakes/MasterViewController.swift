//
//  MasterViewController.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISplitViewControllerDelegate {

    var detailViewController: DetailViewController? = nil
    
    private var viewModel: UEQMasterViewModel!
    var collapseDetailViewController = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = UEQMasterViewModel.init(delegate: self)
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        if let split = splitViewController {
            split.delegate = self
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        viewModel.fetchFeatures()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                let urlString = viewModel.feature(at: indexPath.row).properties.url
                let url = URL.init(string: urlString)
                controller.detailItem = url
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalFeatures
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if isLoadingCell(for: indexPath) {
            cell.textLabel!.text = "none"
        } else {
            let object = viewModel.feature(at: indexPath.row)
            cell.textLabel!.text = object.properties.place
            cell.detailTextLabel!.text = object.properties.title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collapseDetailViewController = false
    }


}

extension MasterViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      viewModel.fetchFeatures()
    }
  }
}


extension MasterViewController: UEQMasterVMDelegate {
    func didFetchComplete(with newIndexPathsToReload: [IndexPath]?) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else { return }
                            
            strongSelf.tableView.reloadData()
            strongSelf.detailViewController?.setDefault(url: URL.init(string: strongSelf.viewModel.feature(at: 0).properties.url))
        }
    }
    
    func didFetchFail(with reason: String) {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else { return }
            let title = "Warning".localizedString
            let action = UIAlertAction(title: "OK".localizedString, style: .default)
            strongSelf.displayAlert(with: title , message: reason, actions: [action])
        }
    }
}

private extension MasterViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row + 30 >= viewModel.currentCount
    }
    
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
      guard presentedViewController == nil else {
        return
      }
      
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      actions?.forEach { action in
        alertController.addAction(action)
      }
      present(alertController, animated: true)
    }
}

