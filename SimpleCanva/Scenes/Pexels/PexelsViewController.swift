internal import UIKit

final class PexelsViewController: UIViewController{
    private let tableView = UITableView()
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

extension PexelsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
                    return UITableViewCell()
                }
        cell.delegate = delegate
        cell.configure(with: photos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        tableView.rowHeight = 80
    }
}
