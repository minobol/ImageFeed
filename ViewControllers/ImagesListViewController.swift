import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    // MARK: - Static Properties
    static let shared = ImagesListViewController()
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var photos: [Photo] = []
    private var imagesListViewControllerObserver: NSObjectProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "dd MMMM yyyy"
        date.locale = Locale(identifier: "ru_RU")
        return date
    }()
    
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 300
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListViewControllerObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        
        loadImages()
        UIBlockingProgressHUD.show() // Показать HUD при загрузке изображений
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            guard let fullImageURL = URL(string: photos[indexPath.row].largeImageURL) else {
                return
            }
            viewController.fullImageURL = fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Extensions ImagesListViewController
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (photos.count - 1) {
            loadImages()
        }
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageURL = URL(string: photos[indexPath.row].thumbImageURL)
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        
        cell.imageViewList.kf.setImage(with: imageURL,
                                       placeholder: UIImage(named: "Rectangle 169"),
                                       options: [.processor(processor)])
        
        guard let date = photos[indexPath.row].createdAt else { return }
        
        cell.setIsLiked(like: photos[indexPath.row].isLiked)
        cell.labelList.text = dateFormatter.string(from: date)
        cell.delegate = self
    }
    
    func updateTableViewAnimated() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let oldCount = self.photos.count
            let newCount = self.imagesListService.photos.count
            
            self.photos = self.imagesListService.photos
            
            if oldCount != newCount {
                self.tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in
                    UIBlockingProgressHUD.dismiss() // Скрыть HUD после обновления таблицы
                }
            } else {
                UIBlockingProgressHUD.dismiss() // Скрыть HUD если количество изображений не изменилось
            }
        }
    }
    
    func loadImages() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            switch result {
            case .success:
                self?.updateTableViewAnimated()
            case .failure:
                print("Failed to load images")
                UIBlockingProgressHUD.dismiss() // Скрыть HUD при ошибке загрузки изображений
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageWidth = photos[indexPath.row].size.width
        
        if imageWidth == 0 {
            print("Attention, imageWidth in imageListViewController == 0!")
            return 200 // Возвращаем стандартную высоту если ширина изображения равна нулю.
        }

        let scale = (tableView.bounds.width - imageInsets.left - imageInsets.right) / imageWidth
        
        return (photos[indexPath.row].size.height * scale) + imageInsets.top + imageInsets.bottom
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show() // Показать HUD при изменении лайка
        
        let photoId = photos[indexPath.row].id
        
        imagesListService.changeLike(photoId: photoId, isLike:
            !photos[indexPath.row].isLiked) { [weak self] result in
            
            guard let self = self else { return }

            switch result {
            case .success:
                self.photos[indexPath.row].isLiked.toggle() // Обновление состояния лайка в массиве.
                cell.setIsLiked(like:
                    self.photos[indexPath.row].isLiked)
                print("Change like ok")
                
            case .failure:
                print("No like change")
            }

            UIBlockingProgressHUD.dismiss() // Скрыть HUD после изменения лайка независимо от результата операции.
        }
    }
}
