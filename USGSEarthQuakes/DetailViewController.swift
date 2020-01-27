//
//  DetailViewController.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate, UISplitViewControllerDelegate {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    func configureView() {
        // Update the user interface for the detail item.
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
        if let detail = detailItem, let _ = wkWebView {
            wkWebView.load(URLRequest.init(url: detail))
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool
    {
        guard let navigationController = primaryViewController as? UINavigationController,
            let controller = navigationController.topViewController as? MasterViewController
        else {
            return false
        }

        return controller.collapseDetailViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wkWebView.navigationDelegate = self
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    var detailItem: URL? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func setDefault(url: URL?) {
        self.detailItem = url
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }


}

