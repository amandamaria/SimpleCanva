internal import UIKit

final class PexelsViewController: UIViewController{
    private let tableView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 16)
        let itemWidth = 80
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // Itens quadrados

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let interactor: PexelsInteracting
    private var photos: [PexelsPhoto.PexelsPhotoData] = []
    weak var delegate: ImagePickerDelegate?
    
    init(interactor: PexelsInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        interactor.loadData()
        setupTableView()
    }
    
    func showData(_ photos: [PexelsPhoto.PexelsPhotoData]) {
        self.photos = photos
        tableView.reloadData()
    }
}

extension PexelsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
                    return UICollectionViewCell()
                }
        cell.delegate = delegate
        cell.configure(with: photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImg = photos[indexPath.row]
        delegate?.didSelect(item: selectedImg)
        dismiss(animated: true)
    }
}

private extension PexelsViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }
}
