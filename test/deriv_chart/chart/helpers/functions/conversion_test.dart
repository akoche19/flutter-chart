import 'package:deriv_chart/src/deriv_chart/chart/helpers/functions/conversion.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deriv_chart/src/models/time_range.dart';

void main() {
  group('shiftEpochByPx should', () {
    test('return the same epoch when px shift is 0', () {
      expect(
        shiftEpochByPx(
          epoch: 123456,
          pxShift: 0,
          msPerPx: 1,
          gaps: [],
        ),
        equals(123456),
      );
      expect(
        shiftEpochByPx(
          epoch: 1601140057031,
          pxShift: 0,
          msPerPx: 161472.32783279638,
          gaps: [TimeRange(1601067600000, 1601251200000)],
        ),
        equals(1601140057031),
      );
    });

    // Symbol explanation:
    // | is initial position
    // x is expected result
    // -- is time
    // __ is time gap
    test('handle --|--x', () {
      expect(
          shiftEpochByPx(
            epoch: 123456,
            pxShift: 100,
            msPerPx: 1,
            gaps: [],
          ),
          equals(123556));
    });
    test('handle x--|--', () {
      expect(
          shiftEpochByPx(
            epoch: 123456,
            pxShift: -106,
            msPerPx: 1,
            gaps: [],
          ),
          equals(123350));
    });
    test('handle --|__x', () {
      expect(
          shiftEpochByPx(
            epoch: 999,
            pxShift: 1,
            msPerPx: 1,
            gaps: [TimeRange(999, 1200)],
          ),
          equals(1201));
    });
    test('handle __|__x', () {
      expect(
          shiftEpochByPx(
            epoch: 999,
            pxShift: 1,
            msPerPx: 1,
            gaps: [TimeRange(900, 1200)],
          ),
          equals(1201));
    });
    test('handle --|--__--x', () {
      expect(
          shiftEpochByPx(
            epoch: 200,
            pxShift: 100,
            msPerPx: 1,
            gaps: [TimeRange(210, 220)],
          ),
          equals(310));
    });
    test('handle --|--x--__', () {
      expect(
          shiftEpochByPx(
            epoch: 200,
            pxShift: 100,
            msPerPx: 1,
            gaps: [TimeRange(400, 500)],
          ),
          equals(300));
    });
    test('handle --|--__--__--x', () {
      expect(
          shiftEpochByPx(
            epoch: 200,
            pxShift: 100,
            msPerPx: 1,
            gaps: [TimeRange(220, 240), TimeRange(260, 300)],
          ),
          equals(360));
    });
    test('handle --|--__--__--__x', () {
      expect(
          shiftEpochByPx(
            epoch: 200,
            pxShift: 100,
            msPerPx: 1,
            gaps: [
              TimeRange(220, 240),
              TimeRange(260, 300),
              TimeRange(360, 400),
            ],
          ),
          equals(400));
    });
    test('handle --|--__--__--x__', () {
      expect(
          shiftEpochByPx(
            epoch: 200,
            pxShift: 100,
            msPerPx: 1,
            gaps: [
              TimeRange(220, 240),
              TimeRange(260, 300),
              TimeRange(361, 400),
            ],
          ),
          equals(360));
    });
    test('handle x--__--|--', () {
      expect(
        shiftEpochByPx(
          epoch: 200,
          pxShift: -50,
          msPerPx: 1,
          gaps: [TimeRange(190, 195)],
        ),
        equals(145),
      );
    });
    test('handle x--__--__--|--', () {
      expect(
        shiftEpochByPx(
          epoch: 200,
          pxShift: -50,
          msPerPx: 1,
          gaps: [TimeRange(140, 150), TimeRange(190, 195)],
        ),
        equals(135),
      );
    });
    test('handle __--__|__--x', () {
      expect(
        shiftEpochByPx(
          epoch: 1601248601086,
          pxShift: 2.181818181818187,
          msPerPx: 900000,
          gaps: [
            TimeRange(1600462800000, 1600646400000),
            TimeRange(1601067600000, 1601251200000),
          ],
        ),
        equals(1601253163636),
      );
    });
  });

  group('quoteToCanvasY should return', () {
    test('[topPadding] when [quote == topBoundQuote]', () {
      expect(
        quoteToCanvasY(
          quote: 1234.2345,
          topBoundQuote: 1234.2345,
          bottomBoundQuote: 123.439,
          canvasHeight: 10033,
          topPadding: 0,
          bottomPadding: 133,
        ),
        equals(0),
      );
      expect(
        quoteToCanvasY(
          quote: 1234.2345,
          topBoundQuote: 1234.2345,
          bottomBoundQuote: 123.439,
          canvasHeight: 10033,
          topPadding: 1234.34,
          bottomPadding: 133,
        ),
        equals(1234.34),
      );
    });
    test('[canvasHeight - bottomPadding] when [quote == bottomBoundQuote]', () {
      expect(
        quoteToCanvasY(
          quote: 89.2345,
          topBoundQuote: 102.2385,
          bottomBoundQuote: 89.2345,
          canvasHeight: 1024,
          topPadding: 123,
          bottomPadding: 0,
        ),
        equals(1024),
      );
      expect(
        quoteToCanvasY(
          quote: 89.2345,
          topBoundQuote: 102.2385,
          bottomBoundQuote: 89.2345,
          canvasHeight: 1024,
          topPadding: 123,
          bottomPadding: 24,
        ),
        equals(1000),
      );
    });
    test('middle of drawing range when [topBoundQuote == bottomBoundQuote]',
        () {
      expect(
        quoteToCanvasY(
          quote: 89.2345,
          topBoundQuote: 102.2385,
          bottomBoundQuote: 102.2385,
          canvasHeight: 1024,
          topPadding: 12,
          bottomPadding: 12,
        ),
        equals(512),
      );
    });
  });

  group('quoteFromCanvasY should return', () {
    test('[topBoundQuote] when [y == topPadding]', () {
      expect(
        quoteFromCanvasY(
          y: 0,
          topBoundQuote: 1234.2345,
          bottomBoundQuote: 123.439,
          canvasHeight: 10033,
          topPadding: 0,
          bottomPadding: 133,
        ),
        equals(1234.2345),
      );
      expect(
        quoteFromCanvasY(
          y: 1234.34,
          topBoundQuote: 1234.2345,
          bottomBoundQuote: 123.439,
          canvasHeight: 10033,
          topPadding: 1234.34,
          bottomPadding: 133,
        ),
        equals(1234.2345),
      );
    });
    test('[bottomBoundQuote] when [y == canvasHeight]', () {
      expect(
        quoteFromCanvasY(
          y: 1024,
          topBoundQuote: 102.2385,
          bottomBoundQuote: 89.2345,
          canvasHeight: 1024,
          topPadding: 123,
          bottomPadding: 0,
        ),
        equals(89.2345),
      );
      expect(
        quoteFromCanvasY(
          y: 1024,
          topBoundQuote: 102.2385,
          bottomBoundQuote: 89.2345,
          canvasHeight: 1024,
          topPadding: 123,
          bottomPadding: 0,
        ),
        equals(89.2345),
      );
    });
    test('middle of drawing range', () {
      expect(
        quoteFromCanvasY(
          y: 512,
          topBoundQuote: 100,
          bottomBoundQuote: 200,
          canvasHeight: 1024,
          topPadding: 12,
          bottomPadding: 12,
        ),
        equals(150),
      );
    });
  });
}
