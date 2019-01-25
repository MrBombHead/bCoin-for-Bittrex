//
//  MenuBar.swift
//  CodedViews
//
//  Created by Craig Cornwell on 3/10/18.
//  Copyright © 2018 Craig Cornwell. All rights reserved.
//

import UIKit

protocol MenuBarDelegate {
    func scrollToPage(page: Int)
}

class MenuBar: GenericView {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var horizontalBar: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    var delegate: MenuBarDelegate?
    
    let cellId = "cellId"
    var sections = ["Loading"] {
        didSet {
            DispatchQueue.main.async {
                self.horizontalBarWidthConstraint?.constant = self.frame.width / CGFloat(self.sections.count)
                self.collectionView.reloadData()

                let indexPath = IndexPath(item: 0, section: 0)
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            }
        }
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var horizontalBarWidthConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        addSubview(horizontalBar)
        
        horizontalBarLeftAnchorConstraint = horizontalBar.leadingAnchor.constraint(equalTo: leadingAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarWidthConstraint = horizontalBar.widthAnchor.constraint(equalToConstant: 1)
        horizontalBarWidthConstraint?.isActive = true

        horizontalBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func updateHorizontalBar(withNewLocation location: CGFloat) {
        horizontalBarLeftAnchorConstraint?.constant = location / CGFloat(sections.count)
    }
    
    func selectItem(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }

    
    override func setUpView() {        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        collectionView.pin(to: self)
        setupHorizontalBar()
    }

}

extension MenuBar: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.scrollToPage(page: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.textLabel.text = sections[indexPath.item]
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(sections.count), height: frame.height)
    }
    
}
