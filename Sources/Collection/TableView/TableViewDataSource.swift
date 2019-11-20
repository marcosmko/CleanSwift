//
//  TableViewDataSource.swift
//  CleanSwift
//
//  Created by Marcos Kobuchi on 12/11/19.
//  Copyright © 2019 Undercaffeine. All rights reserved.
//

import Foundation

public class TableViewDataSource: NSObject {
    
    private weak var tableView: UITableView?
    private weak var delegate: NSObject?
    
    private var sections: [Section] = []
    private var identifiers: [String: String] = [:]
    
    public init(tableView: UITableView, delegate: NSObject? = nil) {
        self.tableView = tableView
        self.delegate = delegate
    }
    
    public func append(sections: [Section]) {
        self.sections = sections
        self.tableView?.reloadData()
    }
    
    public func bind<TCell: GenericTableViewCell<TViewModel>, TViewModel: ViewModel>(cell: TCell.Type, to viewModel: TViewModel.Type) {
        self.tableView?.register(UINib(nibName: "\(cell)", bundle: nil), forCellReuseIdentifier: "\(cell)")
        self.identifiers["\(viewModel)"] = "\(cell)"
    }
    
    public func bind<TCell: GenericTableViewCell<TViewModel>, TViewModel: ViewModel>(cell: TCell.Type, to viewModel: TViewModel.Type, forSupplementaryViewOfKind kind: String) {
        self.tableView?.register(UINib(nibName: "\(cell)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(cell)")
        self.identifiers["\(viewModel)"] = "\(cell)"
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
