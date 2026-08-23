# Backend Prompt: Booking Add Visit Item Sources

We need backend support for the employee Flutter Booking Details "Add visit item" bottom sheet.

## Goal

The employee should add a new booking item to a specific booking/visit from one of these sources:

- Normal service
- Package / offer purchase
- Existing customer package balance/session
- Subscription

The mobile UI already has tabs for these sources. Normal service currently works through:

```http
GET /api/employee/bookings/{booking_uuid}/available-services?page=1
POST /api/employee/bookings/{booking_uuid}/services
```

Current normal service body:

```json
{
  "service_uuid": "SERVICE_UUID",
  "visit_uuid": "VISIT_UUID"
}
```

## Required API Contract

### 1. List addable booking item sources

```http
GET /api/employee/bookings/{booking_uuid}/available-items?visit_uuid={visit_uuid}&tab=services|packages|customer_packages|subscriptions&page=1&per_page=15
Authorization: Bearer <employee_token>
Accept: application/json
Accept-Language: ar|en
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "source_type": "normal_service",
      "source_uuid": "SERVICE_UUID",
      "title": "تنظيف أسنان",
      "subtitle": "فئة 1",
      "price": "200.00",
      "currency": "EGP",
      "duration_minutes": 30,
      "available_quantity": null,
      "unit_name": null,
      "badge": "خدمة عادية",
      "metadata": {}
    },
    {
      "source_type": "single_visit_package",
      "source_uuid": "PACKAGE_UUID_OR_OFFER_UUID",
      "title": "باقة الأسنان",
      "subtitle": "كشف أسنان + تنظيف أسنان",
      "price": "450.00",
      "currency": "EGP",
      "duration_minutes": 60,
      "available_quantity": null,
      "unit_name": null,
      "badge": "باقة زيارة واحدة",
      "metadata": {
        "package_type": "single_visit",
        "services_count": 2
      }
    },
    {
      "source_type": "multi_session",
      "source_uuid": "CUSTOMER_PACKAGE_PURCHASE_UUID",
      "title": "ليزر وجه 10 جلسات",
      "subtitle": "متبقي 9 جلسات",
      "price": "0.00",
      "currency": "EGP",
      "duration_minutes": 30,
      "available_quantity": 9,
      "unit_name": "جلسة",
      "badge": "خدمة جلسات باقة",
      "metadata": {
        "selected_service_uuid": "SERVICE_UUID"
      }
    },
    {
      "source_type": "usage_based",
      "source_uuid": "CUSTOMER_USAGE_PACKAGE_UUID",
      "title": "1000 نبضة",
      "subtitle": "الرصيد المتاح 700 نبضة",
      "price": "0.00",
      "currency": "EGP",
      "duration_minutes": 40,
      "available_quantity": 700,
      "unit_name": "نبضة",
      "badge": "خدمة رصيد باقة",
      "metadata": {
        "selected_service_uuid": "SERVICE_UUID"
      }
    }
  ],
  "meta": {
    "pagination": {
      "current_page": 1,
      "per_page": 15,
      "total": 1,
      "last_page": 1
    }
  }
}
```

### 2. Add selected source to booking/visit

```http
POST /api/employee/bookings/{booking_uuid}/items
Authorization: Bearer <employee_token>
Accept: application/json
Accept-Language: ar|en
Content-Type: application/json
```

Body:

```json
{
  "visit_uuid": "VISIT_UUID",
  "source_type": "normal_service|single_visit_package|multi_session|usage_based|subscription",
  "source_uuid": "SOURCE_UUID",
  "service_uuid": "SERVICE_UUID_OPTIONAL_FOR_PACKAGE_BALANCE",
  "quantity": 1
}
```

Success response should return the full booking details contract, including:

- `assigned_items[]` with `source_type`
- `visits[].services[]` or `visits[].assigned_items[]` with the same source metadata
- package/session/usage metadata exactly like current `GET /api/employee/bookings/{booking_uuid}`

## Rules

- Do not let Flutter calculate source type.
- Return localized titles/subtitles based on `Accept-Language`.
- Validate employee permissions, branch, customer ownership, visit status, and package balance.
- For usage packages, return whether `usage_recording_required` is true.
- Repeated services from the same package should remain separate booking items.
- On `422`, return localized `message` explaining why the item cannot be added.
