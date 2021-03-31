//
//  testProjectAlturosTests.swift
//  testProjectAlturosTests
//
//  Created by Ramona Cvelf on 30.03.21.
//

import XCTest
@testable import testProjectAlturos

func readLocalFile(with bundle: Bundle, forName name: String) -> Data? {
    do {
        
        if let bundlePath = bundle.path(forResource: name, ofType: "json"),
           let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}


class testProjectAlturosTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Testing Breeds-API Call
    func testBreedsDecode() throws {
        let bundle = Bundle(for: type(of: self))
        let apiCall = readLocalFile(with: bundle, forName: "dogBreedsApiCall")
        
        guard let dogBreeds = ApiDecoder.decodeDogBreeds(from: apiCall) else {
            XCTFail("Failed decoding API Call")
            return
        }
        
        XCTAssert(dogBreeds.count == 95)
        
        guard let deerhound = dogBreeds.first(where: { $0.name == "deerhound"}) else {
            XCTFail("Failed to find deerhound")
            return
        }
        
        XCTAssert(deerhound.subBreeds[0].name == "scottish")
    }
    
    // Testing decoding a single random image
    func testRandomSingleImageDecode() throws {
        let bundle = Bundle(for: type(of: self))
        let apiCall = readLocalFile(with: bundle, forName: "dogBreedRandomImage")
        
        guard let image = ApiDecoder.decodeRandomImages(from: apiCall) else {
            XCTFail("Failed decoding a single random image")
            return
        }
        
        XCTAssert(image.count == 1)
    }
    
    // Testing decoding multiple random images
    func testRandomImagesDecode() throws {
        let bundle = Bundle(for: type(of: self))
        let apiCall = readLocalFile(with: bundle, forName: "dogBreedRandomImages")
        
        guard let image = ApiDecoder.decodeRandomImages(from: apiCall) else {
            XCTFail("Failed decoding multiple random images")
            return
        }
        
        XCTAssert(image.count == 3)
    }
    
    // Testing Actual API-Service
    func testApiServiceGetAllBreeds() throws {
        let service = ApiService()
        var dogBreeds: [Breed] = []
        let expectationBreeds = self.expectation(description: "get all breeds from API-Call")
        service.getAllBreeds(completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("API-Call to get all breeds failed with: \(error)")
            case .success(let breeds):
                dogBreeds = breeds
                expectationBreeds.fulfill()
            }
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertGreaterThan(dogBreeds.count, 0)
        
        let expectationImages = self.expectation(description: "get images for australian")
        guard let idx = dogBreeds.firstIndex(where: { $0.name == "australian"}) else {
            XCTFail("Failed to find australian")
            return
        }
        
        service.getImagesForBreed(dogBreeds[idx], count: 3, completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("API-Call to get images for australian failed with: \(error)")
                
            case .success(let result):
                dogBreeds[idx] = result
                expectationImages.fulfill()
            }
        })

        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(dogBreeds[idx].images?.count, 3)
        XCTAssertEqual(dogBreeds[idx].subBreeds[0].images?.count, 3)
    }
}
