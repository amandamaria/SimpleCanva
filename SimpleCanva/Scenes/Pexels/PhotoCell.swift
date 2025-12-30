internal import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didSelect(item: PexelsPhoto.PexelsPhotoData)
}

final class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    private var downloadTask: URLSessionDataTask?
    weak var delegate: ImagePickerDelegate?

    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        contentView.addSubview(photoImageView)

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 80),
            photoImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    func configure(with photo: PexelsPhoto.PexelsPhotoData) {
        photoImageView.image = nil
        downloadTask?.cancel()

        guard let url = URL(string: photo.src.url) else { return }

        downloadTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.photoImageView.image = image
                }
            }
        }
        downloadTask?.resume()
    }
}
