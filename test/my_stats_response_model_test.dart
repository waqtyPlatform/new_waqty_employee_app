import 'package:flutter_test/flutter_test.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_reviews_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/services/my_stats_api_end_points.dart';

void main() {
  test('parses employee performance response contract', () {
    final response = MyStatsResponseModel.fromJson({
      'success': true,
      'data': {
        'period': {
          'type': 'week',
          'start_at': '2026-08-24T00:00:00+03:00',
          'end_at': '2026-08-31T00:00:00+03:00',
          'timezone': 'Asia/Riyadh',
        },
        'kpis': {
          'appointments': {
            'current': 5,
            'previous': 3,
            'percentage_change': 66.67,
            'best': {'value': 7},
          },
          'revenue': {
            'mixed_currency': false,
            'currencies': [
              {
                'currency': 'EGP',
                'current': 1200,
                'previous': 900,
                'percentage_change': 33.33,
                'best': {'value': 1400},
              },
            ],
          },
          'rating': {
            'current_average': 4.8,
            'current_count': 9,
            'previous_average': 4.4,
            'best': {'value': 5},
          },
          'utilization': {
            'percentage': 70,
            'occupied_minutes': 1872,
            'available_minutes': 2400,
          },
        },
        'appointments_series': [
          {'date': '2026-08-24', 'label': 'Mon', 'appointments_count': 3},
        ],
        'revenue_series': [
          {
            'date': '2026-08-24',
            'label': 'Mon',
            'value': '500.00',
            'currency': 'EGP',
          },
        ],
        'services': [
          {
            'service_name': 'Cleaning',
            'completed_items_count': 2,
            'attributed_service_value': '300.00',
            'currency': 'EGP',
            'share_percentage': 40,
          },
        ],
        'reviews_summary': {
          'average': 4.7,
          'total': 63,
          'distribution': {'5': 50},
        },
        'comparison': {},
        'data_quality': {'has_estimated_utilization': true},
      },
    });

    final data = response.data;
    expect(data.period.value, 'week');
    expect(data.kpis.appointments.current, 5);
    expect(data.kpis.appointments.percentageChange, 66.67);
    expect(data.kpis.revenue.displayValue, 'EGP 1,200');
    expect(data.kpis.rating.displayAverage, '4.8');
    expect(data.kpis.utilization.percentage, 70);
    expect(data.appointmentsSeries.single.appointmentsCount, 3);
    expect(data.revenueSeries.single.numericValue, 500);
    expect(data.services.single.sharePercentage, 40);
    expect(data.reviewsSummary.total, 63);
    expect(data.period.startDate, '2026-08-24T00:00:00+03:00');
    expect(data.comparison.appointments.last, '3');
    expect(data.comparison.appointments.best, '7');
    expect(data.comparison.revenues.single.currency, 'EGP');
    expect(data.comparison.revenues.single.current, '1200');
    expect(data.comparison.revenues.single.last, '900');
    expect(data.comparison.revenues.single.best, '1400');
    expect(data.comparison.rating.current, '4.8');
    expect(data.dataQuality.hasEstimatedUtilization, isTrue);
  });

  test('parses employee reviews and nullable comments', () {
    final response = MyReviewsResponseModel.fromJson({
      'success': true,
      'data': [
        {
          'uuid': 'rating-1',
          'rating': 5,
          'comment': null,
          'created_at': '2026-08-24T12:00:00+03:00',
          'customer': {'uuid': 'customer-1', 'name': 'Ahmed'},
          'service': {'uuid': 'service-1', 'name': 'Cleaning'},
          'booking': {'uuid': 'booking-1', 'reference': '#ABC'},
        },
      ],
      'summary': {
        'average': 5,
        'total': 1,
        'distribution': {'5': 1},
      },
      'meta': {
        'pagination': {
          'current_page': 1,
          'per_page': 15,
          'total': 1,
          'last_page': 1,
        },
      },
    });

    expect(response.reviews.single.comment, '');
    expect(response.reviews.single.customer.name, 'Ahmed');
    expect(response.summary.average, 5);
    expect(response.pagination.hasMore, isFalse);
  });

  test('builds performance periods and reviews filters query params', () {
    expect(
      MyStatsApiEndPoints.performance(period: 'today'),
      '/api/employee/performance?period=today',
    );
    expect(
      MyStatsApiEndPoints.performance(period: 'week'),
      '/api/employee/performance?period=week',
    );
    expect(
      MyStatsApiEndPoints.performance(period: 'month'),
      '/api/employee/performance?period=month',
    );

    final ratingsUrl = MyStatsApiEndPoints.ratings(
      rating: 5,
      page: 2,
      perPage: 15,
    );
    expect(ratingsUrl, contains('/api/employee/ratings?'));
    expect(ratingsUrl, contains('rating=5'));
    expect(ratingsUrl, contains('page=2'));
    expect(ratingsUrl, contains('per_page=15'));
  });
}
