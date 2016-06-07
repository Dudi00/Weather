//
//  WeatherViewController.swift
//  Weather
//
//  Created by Błażej Wdowikowski on 05/06/2016.
//  Copyright © 2016 blazej. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UICollectionViewDelegate {

    
    @IBOutlet weak private var headView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    private var dataSource:WeatherCollectionDataSource = WeatherCollectionDataSource()
    private var delegate:WeatherCollectionDelegateFlowLayout = WeatherCollectionDelegateFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        setupHeaderView()
        setupCollectionView()
        setupRefreshControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private methods
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: .ValueChanged)
        refreshControl.backgroundColor =  CommonColors.blue
        refreshControl.tintColor = UIColor.whiteColor()
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.addSubview(refreshControl)
    }
    
    @objc
    private func handleRefresh(sender:AnyObject?) {
        guard let refreshControl = sender else {
            print("how did you get here?! \(sender)")
            return
        }
        
        dataSource.refreshData { (success) in
            defer {
                refreshControl.endRefreshing()
            }
            
            if success {
                self.titleLabel.text = self.dataSource.currentLocationName()
                self.collectionView.reloadData()
            } else {
                self.showMsgWithTitle("OOps", msg: "Wygląda to na problem z API. Masz internet?", buttonTitle: "sprawdzę")
            }
        }
        
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "ForecastViewCell", bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: ForecastViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = dataSource
        self.collectionView.delegate = delegate
        self.collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    private func setupHeaderView() {
        self.headView.backgroundColor = CommonColors.blue
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.text = "Pogoda"
    }
    
    private func showMsgWithTitle(title:String,msg:String,buttonTitle:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .Default, handler: nil))
        self.showViewController(alert, sender: self)
    }
    
    
}
