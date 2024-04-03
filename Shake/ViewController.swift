//
//  ViewController.swift
//  takehome
//
//  Created by Adrien Carvalot on 03/11/2020.
//  Copyright © 2020 Takeoff Labs, Inc. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, User>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User>
    
    @Published var users: [User] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var storiesCollectionView = createStoriesCollectionView()
    private lazy var dataSource: DataSource = createDataSource(with: storiesCollectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUsers()
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        view.addSubview(storiesCollectionView)
        
        storiesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storiesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0),
            storiesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storiesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storiesCollectionView.heightAnchor.constraint(equalToConstant: 112.0)
        ])
    }
    
    private func setupBindings() {
        $users
            .sink { [dataSource] stories in
                var snapshot = Snapshot()
                snapshot.appendSections([0])
                snapshot.appendItems(stories)
                dataSource.apply(snapshot)
            }
            .store(in: &cancellables)
    }
    
    func createStoriesCollectionView() -> UICollectionView {
        let spacing = 12.0
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(72.0),
            heightDimension: .estimated(88.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0.0,
            leading: 8.0,
            bottom: 0.0,
            trailing: 8.0
        )

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(UserCell.self,
                                forCellWithReuseIdentifier: UserCell.description())
        return collectionView
    }

    private func createDataSource(with collectionView: UICollectionView) -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView) { collectionView, indexPath, user -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UserCell.description(),
                    for: indexPath) as? UserCell
                else {
                    return nil
                }
                cell.configure(user: user)
                return cell
            }
        return dataSource
    }

    private func loadUsers() {
        UserService.getUsers { (result: Result<Users, APIServiceError>) in
            switch result {
            case .success(let users):
                self.users = users.users.filter({ !$0.stories.filter({ $0.imageURL != nil }).isEmpty })
                
                break
            case .failure(let error):
                // TODO: Handle Error
                print("Error: \(error)")
                break
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = InstaViewController()
        viewController.viewModel = InstaViewModel(users: users)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
