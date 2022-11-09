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
        sut = nil

        super.tearDown()
    }
}

extension HomeViewModelTests {
    func testInitialOutput() {
        // When
        let output = sut.output

        // Then
        XCTAssertEqual(output.conversionTypeTitle, "Celsius to Fahrenheit")
        XCTAssertEqual(output.convertToTitle, "To (Fahrenheit):")
        XCTAssertEqual(output.convertFromTitle, "From (Celsius):")
        XCTAssertEqual(output.result, "None")
        XCTAssertEqual(output.pickerComponents, 1)
        XCTAssertEqual(output.picerRowsInComponent, 2)
    }

    func testOutputTitlesWhenConversionTypeIsSetToRow0() {
        // Given
        sut.setConversionType(forRow: 0)

        // When
        let output = sut.output

        // Then
        XCTAssertEqual(output.conversionTypeTitle, "Celsius to Fahrenheit")
        XCTAssertEqual(output.convertToTitle, "To (Fahrenheit):")
        XCTAssertEqual(output.convertFromTitle, "From (Celsius):")
    }

    func testOutputTitlesWhenConversionTypeIsSetToRow1() {
        // Given
        sut.setConversionType(forRow: 1)

        // When
        let output = sut.output

        // Then
        XCTAssertEqual(output.conversionTypeTitle, "Fahrenheit to Celsius")
        XCTAssertEqual(output.convertToTitle, "To (Celsius):")
        XCTAssertEqual(output.convertFromTitle, "From (Fahrenheit):")
    }

    func testOutputResultWhenConversionTypeIsSetToRow0WithTemperatureEquals0() {
        // Given
        sut.setConversionType(forRow: 0)
        sut.setTemperature("0")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "32.00")
    }

    func testOutputResultWhenConversionTypeIsSetToRow1WithTemperatureEquals0() {
        // Given
        sut.setConversionType(forRow: 1)
        sut.setTemperature("0")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "-17.78")
    }

    func testOutputResultWhenSwitchingConversionTypeFromRow1To0WithTemperatureEquals0() {
        // Given
        sut.setConversionType(forRow: 1)
        sut.setTemperature("0")
        sut.convert()

        // When
        sut.setConversionType(forRow: 0)

        // Then
        XCTAssertEqual(sut.output.result, "32.00")
    }

    func testOutputResultWhenSwitchingConversionTypeFromRow0To1WithTemperatureEquals0() {
        // Given
        sut.setConversionType(forRow: 0)
        sut.setTemperature("0")
        sut.convert()

        // When
        sut.setConversionType(forRow: 1)

        // Then
        XCTAssertEqual(sut.output.result, "-17.78")
    }

    func testOutputResultWhenConversionTypeIsSetToRow1WithInvalidTemperature() {
        // Given
        sut.setConversionType(forRow: 1)
        sut.setTemperature("abc")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "None")
    }

    func testOutputResultWhenConversionTypeIsSetToRow0WithInvalidTemperature() {
        // Given
        sut.setConversionType(forRow: 0)
        sut.setTemperature("abc")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "None")
    }

    func testOutputResultWhenConversionTypeIsSetToRow1WithEmptyTemperature() {
        // Given
        sut.setConversionType(forRow: 1)
        sut.setTemperature("")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "None")
    }

    func testOutputResultWhenConversionTypeIsSetToRow0WithEmptyTemperature() {
        // Given
        sut.setConversionType(forRow: 0)
        sut.setTemperature("")

        // When
        sut.convert()

        // Then
        XCTAssertEqual(sut.output.result, "None")
    }
}
