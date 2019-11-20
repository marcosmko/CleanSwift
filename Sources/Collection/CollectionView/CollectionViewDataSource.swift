//
//  CollectionViewDataSource.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public class CollectionViewDataSource: NSObject {
    
    private weak var collectionView: UICollectionView?
    private weak var delegate: NSObject?
    
    private var sections: [Section] = []
    private var identifiers: [String: String] = [:]
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    public func bind<TCell: GenericCollectionViewCell<TViewModel>, TViewModel: ViewModel>(cell: TCell.Type, to viewModel: TViewModel.Type) {
        self.collectionView?.register(UINib(nibName: "\(cell)", bundle: nil), forCellWithReuseIdentifier: "\(cell)")
        self.identifiers["\(viewModel)"] = "\(cell)"
    }
    
    public func bind<TCell: GenericCollectionViewCell<TViewModel>, TViewModel: ViewModel>(cell: TCell.Type, to viewModel: TViewModel.Type, forSupplementaryViewOfKind kind: String) {
        self.collectionView?.register(UINib(nibName: "\(cell)", bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: "\(cell)")
        self.identifiers["\(viewModel)"] = "\(cell)"
    }
    
    public func insert(sections: [Section]) {
        self.sections = sections
        self.collectionView?.refreshControl?.endRefreshing()
        self.collectionView?.reloadData()
    }
    
}

extension CollectionViewDataSource: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = self.sections[safe: indexPath.section]?.items[safe: indexPath.row],
            let identifier = self.identifiers[String(describing: type(of: item))] else {
                return UICollectionViewCell(frame: .zero)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        (cell as? GenericCellProtocol)?.prepare(viewModel: item)
        (cell as? GenericCellDelegateProtocol)?.prepare(indexPath: indexPath, delegate: self.delegate)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let item = self.sections[safe: indexPath.section]?.viewModel,
            let identifier = self.identifiers[String(describing: type(of: item))] else {
                return UICollectionViewCell(frame: .zero)
        }
        let reusableSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
        (reusableSupplementaryView as? GenericCellProtocol)?.prepare(viewModel: item)
        return reusableSupplementaryView
    }
    
}
