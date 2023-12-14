//
//  RecentBooksView.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 10.12.23.
//

import Foundation
import UIKit

class RecentBooksView:UICollectionView{
    static let shared = RecentBooksView()
    //MARK: - Lifecycle
    init(){
        let layout = UICollectionViewLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(RecentCell.self, forCellWithReuseIdentifier: RecentCell.identifier)
        self.collectionViewLayout = createCompositionalLayout()
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
            let layouts = UICollectionViewCompositionalLayout.init { sectionIndex, environment in
                self.horizontalSection()
            }
            return layouts
        }

        private func horizontalSection() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1),
                                                   heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
}
extension RecentBooksView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: RecentCell.identifier, for: indexPath) as? RecentCell else {fatalError("Unable to dequeue BookCell in ViewController")}
//        cell.bookImage.image = UIImage(data: viewModel.bookImage ?? Data())
//        cell.categoryLabel.text = viewModel.bookCategory
//        cell.bookNameLabel.text = viewModel.bookTitle
//        cell.authorLabel.text = viewModel.bookAuthor
        return cell
    }
}
