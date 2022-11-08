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
        XCTAssertEqual(output.convertToTitle, "Celsius")
        XCTAssertEqual(output.convertFromTitle, "Fahrenheit")
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

    func testConversionToCelsiusForTemperature0() {
        // Given
        sut.setTemperatureResultType(forRow: 0)
        sut.setTemperature("0")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "-17.78")
    }

    func testConversionToFahrenheitForTemperature0() {
        // Given
        sut.setTemperatureResultType(forRow: 1)
        sut.setTemperature("0")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "32.00")
    }

    func testAutoConversionWhenSwichRowTo0() {
        // Given
        sut.setTemperatureResultType(forRow: 1)
        sut.setTemperature("0")
        sut.convert()

        // When
        sut.setTemperatureResultType(forRow: 0)

        // Then
        XCTAssertEqual(sut.output.result, "-17.78")
    }

    func testAutoConversionWhenSwichRowTo1() {
        // Given
        sut.setTemperatureResultType(forRow: 0)
        sut.setTemperature("0")
        sut.convert()

        // When
        sut.setTemperatureResultType(forRow: 1)

        // Then
        XCTAssertEqual(sut.output.result, "32.00")
    }

    func testConversionToFahrenheitForInvalidTemperature() {
        // Given
        sut.setTemperatureResultType(forRow: 1)
        sut.setTemperature("abc")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "None")
    }

    func testConversionToCelsiusForInvalidTemperature() {
        // Given
        sut.setTemperatureResultType(forRow: 0)
        sut.setTemperature("abc")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "None")
    }

    func testConversionToFahrenheitForEmptyTemperature() {
        // Given
        sut.setTemperatureResultType(forRow: 1)
        sut.setTemperature("")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "None")
    }

    func testConversionToCelsiusForEmptyTemperature() {
        // Given
        sut.setTemperatureResultType(forRow: 0)
        sut.setTemperature("")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "None")
    }
}
