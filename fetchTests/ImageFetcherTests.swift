//
//  ImageFetcherTests.swift
//  fetchTests
//
//  Created by Travis Kessinger on 2/1/25.
//

import XCTest
@testable import fetch

final class ImageFetcherTests: XCTestCase {

    func testImageFetcher() async throws {
        let imageFetcher = ImageFetcher(service: MockImageRetrievingSuccess())
        let url = "testURL"
        let uuid = UUID().uuidString
        let image = await imageFetcher.fetchImage(for: url, with: uuid)
        
        XCTAssertNotNil(image)
        
        let cachedImage = await imageFetcher.retrieveCachedImage(for: uuid)
        
        XCTAssertEqual(image?.pngData()?.count, cachedImage?.pngData()?.count)
        
        let fetchedAgainImage =  await imageFetcher.fetchImage(for: url, with: uuid)
        
        XCTAssertEqual(fetchedAgainImage?.pngData(), cachedImage?.pngData())
    }
}

class MockImageRetrievingSuccess: ImageRetrieving {
    func fetchImage(for stringURL: String) async throws -> UIImage? {
        let imageURL = Bundle(for: Self.self).url(forResource: "large", withExtension: "jpg")
        let data = try? Data(contentsOf: imageURL!)
        return UIImage(data: data!)
    }
}
