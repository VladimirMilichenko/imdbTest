//
//  TestIMDBTests.swift
//  TestIMDBTests
//
//  Created by Vladimir Milichenko on 11/20/22.
//

import XCTest

final class MoviesViewModelTest: XCTestCase {
    class MockMoviesService: MoviesService {
        func getMovies(completion: @escaping (Result<[Movie], Error>) -> ()) {
            var movies = [Movie]()
            
            for i in 1...10 {
                let movie = Movie(id: "\(i)",
                                  title: "\(i)",
                                  rank: "\(i)",
                                  imageUrl: URL(string: "http://\(i).png")!)
                
                movies.append(movie)
            }
            
            movies.insert(Movie(id: "22",
                                title: "22",
                                rank: "22",
                                imageUrl: URL(string: "http://22.png")!),
                          at: 1)
            
            completion(.success(movies))
        }
    }
    
    private var moviesViewModel: MoviesViewModel!
    
    override func setUpWithError() throws {
        moviesViewModel = MoviesViewModel(moviesService: MockMoviesService(), maxCount: 4)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        moviesViewModel.delegate = self
        moviesViewModel.getMovies(forceUpdate: true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension MoviesViewModelTest: MoviesViewModelDelegate {
    func viewModelMoviesDidUpdated(_ sender: MoviesViewModel, error: Error?) {
        XCTAssert(error == nil)
        
        let movieCellViewModels = self.moviesViewModel.movieCellViewModels
        
        XCTAssertFalse(movieCellViewModels.count > self.moviesViewModel.maxCount)
        
        let fourth = moviesViewModel.getMovieCellViewModel(at: IndexPath(row: 3, section: 0))
        XCTAssertTrue(fourth.id == "22")
        XCTAssertTrue(fourth.title == "22")
        XCTAssertTrue(fourth.rank == "22")
        XCTAssertTrue(fourth.imageUrl == URL(string: "http://22.png")!)
        
        let filtered = self.moviesViewModel.getFilteredMovieCellViewModels(by: "2")
        XCTAssertTrue(filtered.count == 2)
        
        let indexPath = IndexPath(row: 1, section: 0)
        let filteredAt = self.moviesViewModel.getFilteredMovieCellViewModel(by: "2", indexPath: indexPath)
        
        XCTAssertTrue(filteredAt.id == "22")
        XCTAssertTrue(filteredAt.title == "22")
        XCTAssertTrue(filteredAt.rank == "22")
        XCTAssertTrue(filteredAt.imageUrl == URL(string: "http://22.png")!)
    }
}
