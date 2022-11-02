//
//  HomeViewModelTests.swift
//  TemperatureConverterTests
//
//  Created by maciej.helmecki on 18/10/2022.
//

import XCTest
@testable import TemperatureConverter

final class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModel!

    override func setUp() {
        super.setUp()

        sut = HomeViewModel()
    }

    override func tearDown() {
        super.tearDown()
    }
}

extension HomeViewModelTests {
    func testInitialOutput() {
        // When
        let output = sut.output

        // Then
        XCTAssertEqual(output.convertToTitle, "Fahrenheit")
        XCTAssertEqual(output.convertFromTitle, "Celsius")
        XCTAssertEqual(output.result, "None")
        XCTAssertEqual(output.pickerComponents, 1)
        XCTAssertEqual(output.picerRowsInComponent, 2)
    }

    func testOutputTitlesWhenTypeIsSetForRow0() {
        // Given
        sut.setTemperatureResultType(forRow: 0)

        // When
        let output = sut.output

        // Then
        XCTAssertEqual(output.convertToTitle, "Celsius")
        XCTAssertEqual(output.convertFromTitle, "Fahrenheit")
    }

    func testOutputTitlesWhenTypeIsSetForRow1() {
        // Given
        sut.setTemperatureResultType(forRow: 1)

        // When
        let output = sut.output

        // Then
        XCTAssertEqual(output.convertToTitle, "Fahrenheit")
        XCTAssertEqual(output.convertFromTitle, "Celsius")
    }

    func testConversionToCelsiusForTemperature100() {
        // Given
        sut.setTemperatureResultType(forRow: 0)
        sut.setTemperature("100")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "37.77778")
    }

    func testConversionToFahrenheitForTemperature100() {
        // Given
        sut.setTemperatureResultType(forRow: 1)
        sut.setTemperature("100")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "212.0")
    }
}
