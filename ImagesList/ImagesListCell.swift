import UIKit

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    @IBOutlet var imageViewList: UIImageView!
    @IBOutlet var likeButtonList: UIButton!
    @IBOutlet var labelList: UILabel!
    static let reuseIdentifier = "ImagesListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewList.kf.cancelDownloadTask()
    }
    
    // MARK: - IB Action
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(like: Bool) {
        let likeImage = like ? UIImage(named: "Like Active") : UIImage(named: "Like No Active")
        print("Like is \(String(describing: likeImage))")
        likeButtonList.setImage(likeImage, for: .normal)
    }
}
