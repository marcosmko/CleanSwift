//
//  TableViewDataSource.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public class TableViewDataSource: GenericCollectionDataSource<UITableView> {
    
    public func bind<TCell: GenericTableViewCell<TViewModel>, TViewModel: ViewModel>(cell: TCell.Type, to viewModel: TViewModel.Type) {
        self.collection?.register(UINib(nibName: "\(cell)", bundle: nil), forCellReuseIdentifier: "\(cell)")
        self.identifiers["\(viewModel)"] = "\(cell)"
    }
    
    public func bind<TCell: GenericViewHeaderFooterView<TViewModel>, TViewModel: ViewModel>(cell: TCell.Type, to viewModel: TViewModel.Type, forSupplementaryViewOfKind kind: String) {
        self.collection?.register(UINib(nibName: "\(cell)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(cell)")
        self.identifiers["\(viewModel)"] = "\(cell)"
    }
    
    public override func insert(sections: [Section], scrollToLast: Bool = false) {
        super.insert(sections: sections, scrollToLast: scrollToLast)
        
        if scrollToLast, let collection = self.collection {
            let section = self.numberOfSections(in: collection) - 1
            let row = self.tableView(collection, numberOfRowsInSection: section) - 1
            self.collection?.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: true)
        }
    }
    
}

extension TableViewDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.sections[safe: indexPath.section]?.items[safe: indexPath.row],
            let identifier = self.identifiers[String(describing: type(of: item))] else {
                return UITableViewCell(frame: .zero)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? GenericCellProtocol)?.prepare(viewModel: item)
        (cell as? GenericCellDelegateProtocol)?.prepare(indexPath: indexPath, delegate: self.delegate)
        return cell
    }
    
}

extension TableViewDataSource: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // check if we need to prefetch new items
        guard let indexPath = indexPaths.last,
            indexPath.row > self.sections[indexPath.section].items.count - self.pageSize else {
                return
        }
        self.dataSourcePrefetching?.prefetch()
    }
    
}
