//
//  UEQMasterViewModel.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import Foundation

protocol UEQMasterVMDelegate: class {
    func didFetchComplete(with newIndexPathsToReload: [IndexPath]?)
    func didFetchFail(with reason: String)
}

class UEQMasterViewModel {
    
    private weak var delegate: UEQMasterVMDelegate?
    
    private let commandQueue: UEQCommandQueue = UEQCommandQueue.init()
    private var featureList: [UEQFeatureModel] = []
    private var currentDate: Date = Date.init()
    private var endDate: Date {
        get {
            let dayComp = DateComponents(day: -1)
            let date = Calendar.current.date(byAdding: dayComp, to: currentDate)
            return date!
        }
    }
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    private lazy var commandCompletion: UEQCommandCompletion<UEQFeatureCollection> = { result in
        self.isFetchInProgress = false
        switch result {
        case .success(let featureCollection):
            self.featureList.append(contentsOf: featureCollection.features)
            self.currentPage += 1
            self.currentDate = self.endDate
            self.total = featureCollection.features.count
            
            if self.currentPage > 2 {
                let indexPathsToReload = self.calculateIndexPathsToReload(from: featureCollection)
                self.delegate?.didFetchComplete(with: indexPathsToReload)
            } else {
                self.delegate?.didFetchComplete(with: .none)
            }
            
        case .failure(let error):
            self.delegate?.didFetchFail(with: error.reason)
        }
    }
    private var command: UEQMasterFetchCommand!
    
    init(delegate: UEQMasterVMDelegate) {
        self.delegate = delegate
    }
    
    var totalFeatures: Int {
        return featureList.count
    }
    
    var totalCount: Int {
      return total
    }
    
    var currentCount: Int {
        return self.featureList.count
    }
    
    func feature(at index: Int) -> UEQFeatureModel {
        return featureList[index]
    }
    
    func fetchFeatures() {
        guard !isFetchInProgress else { return }        
        isFetchInProgress = true
        self.command = UEQMasterFetchCommand.init(with: endDate, enddate: currentDate, completion: commandCompletion)
        self.commandQueue.run(command: self.command)
    }
    
    private func calculateIndexPathsToReload(from newFeature: UEQFeatureCollection) -> [IndexPath] {
        let currentCount = self.featureList.count
        let newCount = newFeature.features.count
        
        let startIndex = currentCount - newCount
        let endIndex = startIndex + newCount
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

typealias UEQCommandCompletion<T> = (Result<T, DataResponseError>) -> ()
class UEQMasterFetchCommand: UEQCommand {
    
    let startdate: Date
    let enddate: Date
    let networkClient: UEQNetwork = UEQNetwork.init()
    let completion: UEQCommandCompletion<UEQFeatureCollection>
    
    init(with startdate: Date, enddate: Date, completion: @escaping UEQCommandCompletion<UEQFeatureCollection>) {
        self.startdate = startdate
        self.enddate = enddate
        self.completion = completion
    }
    
    func execute() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startdateString = dateFormatter.string(from: self.startdate)
        let enddateString = dateFormatter.string(from: self.enddate)
        guard let requestURL = UEQRequestAPI.query.buildURL(startTime: startdateString, and: enddateString) else { throw UEQCommandException.Invalid }
        self.networkClient.fetchData(with: requestURL) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                guard let decodedResponse = try? JSONDecoder().decode(UEQFeatureCollection.self, from: data) else {
                    strongSelf.completion(Result.failure(DataResponseError.decoding))
                    return
                }
                strongSelf.completion(Result.success(decodedResponse as UEQFeatureCollection))
            case .failure(let error):
                strongSelf.completion(Result.failure(error))
            }
        }
    }
}
