//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by MacBook on 22.01.2025.
//

@testable import Image_Feed
import XCTest

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol?
    var cellDataLoaderCalled: Bool = false
    var loadImagesCalled: Bool = false
    var updateTableViewAnimatedCalled: Bool = false
    var photos: [Image_Feed.Photo] = []
    
    func cellDataLoader(cell: Image_Feed.ImagesListCell, indexPath: IndexPath) {
        cellDataLoaderCalled = true
    }
    
    func updateTableViewAnimated(for tableView: UITableView) {
        updateTableViewAnimatedCalled = true
    }
    
    func loadImages(for tableView: UITableView) {
        loadImagesCalled = true
    }
    
    func likeChanger(indexPath: IndexPath, cell: Image_Feed.ImagesListCell) {}
}

final class ImageListTests: XCTestCase {
    
    func testViewControllerCallsLoadImages() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImageListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.loadImagesCalled) //behaviour verification
    }
}
