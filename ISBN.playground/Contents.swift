import Foundation

/**
 There are two ISBN standards: ISBN-10 and ISBN-13.
 */

struct ISBN {

    enum Format {
        case isbn10
        case isbn13
    }

    private let code: String
    var format: Format

    init?(_ rawCode: String) {

        var filterString = rawCode.replacingOccurrences(of: "-", with: "")
        filterString = filterString.replacingOccurrences(of: " ", with: "")

        // assign code
        code = filterString

        if let isbn13Result = ISBN.isbn13Result(code: code) {
            format = isbn13Result
        } else if let isbn10Result = ISBN.isbn10Result(code: code) {
            format = isbn10Result
        } else {
            return nil
        }
    }

    private static func isbn13Result(code: String) -> Format? {

        if code.count != 13 {
            return nil
        }

        let firstMultiplier = 1
        let secondMultiplier = 3

        var index = 1
        var sum = 0
        var checkDigit = 0

        for character in code {
            if let number = Int(String(character)) {
                if index != code.count {
                    if index % 2 == 0 {
                        print(number)
                        sum += number * secondMultiplier
                    } else {
                        sum += number * firstMultiplier
                    }
                } else {
                    // for last digit
                    checkDigit = number
                }
            }

            index += 1
        }

        let result = checkDigit - ((10 - (sum % 10)) % 10)

        if result == 0 {
            return .isbn13
        } else {
            return nil
        }
    }

    private static func isbn10Result(code: String) -> Format? {

        if code.count != 10 {
            return nil
        }

        // numbers is array of Int : ease for calculations and sum
        var numbers = [Int]()

        if code.last == "X" {
            for code in code.dropLast() {
                if let number = Int(String(code)) {
                    numbers.append(number)
                }
            }
            numbers.append(10)
        } else {
            for eachCode in code {
                if let number = Int(String(eachCode)) {
                    numbers.append(number)
                }
            }
        }

        var index = 0
        var sum = 0

        for number in numbers {
            sum += number * (10 - index)
            index += 1
        }

        let result = sum % 11
        if result == 0 {
            return .isbn10
        } else {
            return nil
        }
    }
}



/**
 Task 1: Implement ISBN-13 validation

 ISBN-13 is made up of 12 digits plus a check digit.
 Spaces and hyphens may be included in a code, but are not significant.
 This means that 9780471486480 is equivalent to 978-0-471-48648-0 and 978 0 471 48648 0.

 The check digit for ISBN-13 is calculated by multiplying each digit alternately by 1 or 3 (i.e., 1 x 1st digit, 3 x 2nd digit, 1 x 3rd digit, 3 x 4th digit, etc.), summing these products together, taking modulo 10 of the result and then subtracting this value from 10.

 Once done, all of the following should be true:
 */

_ = ISBN(    "9780141983769")?.format == .isbn13
_ = ISBN(    "9780470059029")?.format == .isbn13
_ = ISBN(    "9680470059029")?.format == nil
_ = ISBN("978 0 471 48648 0")?.format == .isbn13
_ = ISBN("978 0 481 48648 0")?.format == nil
_ = ISBN(   "978-0596809485")?.format == .isbn13
_ = ISBN(   "978-1596809485")?.format == nil
_ = ISBN("978-0-13-149505-0")?.format == .isbn13
_ = ISBN("978-1-13-149505-0")?.format == nil
_ = ISBN("978-0-262-13472-9")?.format == .isbn13
_ = ISBN("978-0-262-13472-8")?.format == nil

/**
 Task 2: Implement ISBN-10 validation

 ISBN-10 is made up of 9 digits plus a check digit (which may be 'X').

 The check digit for ISBN-10 is calculated by multiplying each digit by its position (i.e., 1 x 1st digit, 2 x 2nd digit, etc.), summing these products together and taking modulo 11 of the result (with 'X' being used if the s is 10).

 Once done, all of the following should be true:
 */
_ = ISBN(   "0471958697")?.format == .isbn10
_ = ISBN(   "1471958697")?.format == nil
_ = ISBN("0 471 60695 2")?.format == .isbn10
_ = ISBN("0 491 60695 2")?.format == nil
_ = ISBN("0-470-84525-2")?.format == .isbn10
_ = ISBN("0-470-84535-2")?.format == nil
_ = ISBN("0-321-14653-0")?.format == .isbn10
_ = ISBN("0-321-14653-9")?.format == nil
_ = ISBN(   "123456789X")?.format == .isbn10
_ = ISBN(   "153456789X")?.format == nil
