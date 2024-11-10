import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var imageViewList: UIImageView!
    @IBOutlet var likeButtonList: UIButton!
    @IBOutlet var labelList: UILabel!
    static let reuseIdentifier = "ImagesListCell"
}
