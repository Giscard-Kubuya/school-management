# API Specification

## 📡 API Overview

### Base URL
```
https://api.schoolmanagement.com/v1
```

### Authentication
- **Type**: Bearer Token (JWT)
- **Header**: `Authorization: Bearer {token}`
- **Token Expiration**: 24 hours
- **Refresh Token**: Provided on login, valid for 7 days

### Response Format
```json
{
  "success": true,
  "message": "Operation successful",
  "data": {},
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "per_page": 20,
    "total_count": 100
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "validation_error",
    "message": "Validation failed",
    "details": {
      "email": ["The email field is required."],
      "password": ["The password must be at least 8 characters."]
    }
  }
}
```

## 🔐 Authentication

### 1. Login
- **Endpoint**: `POST /auth/login`
- **Description**: Authenticate user and get access token
- **Request**:
  ```json
  {
    "email": "user@university.edu",
    "password": "securepassword123",
    "device_id": "device-12345",
    "device_name": "iPhone 13"
  }
  ```
- **Response**:
  ```json
  {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "def50200e3bdf42c8f...",
    "token_type": "bearer",
    "expires_in": 86400,
    "user": {
      "id": "user-123",
      "name": "John Doe",
      "email": "user@university.edu",
      "role": "student",
      "university_id": "uni-123"
    }
  }
  ```

### 2. Refresh Token
- **Endpoint**: `POST /auth/refresh`
- **Description**: Get new access token using refresh token
- **Headers**:
  - `Authorization: Bearer {refresh_token}`
- **Response**:
  ```json
  {
    "access_token": "new.access.token.here",
    "token_type": "bearer",
    "expires_in": 86400
  }
  ```

## 👥 User Management

### 1. Get Current User
- **Endpoint**: `GET /users/me`
- **Response**:
  ```json
  {
    "id": "user-123",
    "name": "John Doe",
    "email": "user@university.edu",
    "role": "student",
    "university_id": "uni-123",
    "profile_image": "https://...",
    "created_at": "2023-01-01T00:00:00Z"
  }
  ```

### 2. Update Profile
- **Endpoint**: `PUT /users/me`
- **Request**:
  ```json
  {
    "name": "John Updated",
    "phone": "+1234567890",
    "profile_image": "base64_encoded_image"
  }
  ```

## 🏫 University Management

### 1. List Universities
- **Endpoint**: `GET /universities`
- **Query Params**:
  - `search`: Search by name or domain
  - `country`: Filter by country
  - `page`: Page number
  - `per_page`: Items per page (default: 20)
- **Response**:
  ```json
  {
    "data": [
      {
        "id": "uni-123",
        "name": "Tech University",
        "domain": "tech.edu",
        "country": "United States",
        "logo_url": "https://..."
      }
    ],
    "meta": {
      "current_page": 1,
      "total_pages": 5,
      "per_page": 20,
      "total_count": 100
    }
  }
  ```

## 📚 Course Management

### 1. List Courses
- **Endpoint**: `GET /courses`
- **Query Params**:
  - `semester_id`: Filter by semester
  - `teacher_id`: Filter by teacher
  - `status`: Filter by status (active, upcoming, completed)
- **Response**:
  ```json
  {
    "data": [
      {
        "id": "course-123",
        "code": "CS101",
        "name": "Introduction to Computer Science",
        "description": "...",
        "credits": 3,
        "teacher": {
          "id": "teacher-123",
          "name": "Dr. Smith"
        },
        "schedule": [
          {
            "day": "monday",
            "start_time": "09:00",
            "end_time": "10:30",
            "room": "A101"
          }
        ]
      }
    ]
  }
  ```

### 2. Get Course Details
- **Endpoint**: `GET /courses/{id}`
- **Response**:
  ```json
  {
    "id": "course-123",
    "code": "CS101",
    "name": "Introduction to Computer Science",
    "description": "...",
    "syllabus": "...",
    "materials": [
      {
        "id": "mat-123",
        "title": "Syllabus",
        "type": "document",
        "url": "https://...",
        "uploaded_at": "2023-01-15T10:00:00Z"
      }
    ],
    "assignments": [
      {
        "id": "assign-123",
        "title": "Midterm Exam",
        "due_date": "2023-03-15T23:59:59Z",
        "status": "pending",
        "submission": {
          "id": "sub-123",
          "submitted_at": null,
          "grade": null
        }
      }
    ]
  }
  ```

## 💰 Finance Module

### 1. Get Account Balance
- **Endpoint**: `GET /finance/accounts`
- **Response**:
  ```json
  {
    "balance": 1500.00,
    "currency": "USD",
    "account_number": "ACC12345678",
    "transactions": [
      {
        "id": "txn-123",
        "amount": -100.00,
        "description": "Tuition Fee Payment",
        "date": "2023-01-10T14:30:00Z",
        "status": "completed"
      }
    ]
  }
  ```

### 2. Make Payment
- **Endpoint**: `POST /finance/payments`
- **Request**:
  ```json
  {
    "amount": 100.00,
    "description": "Tuition Fee Payment",
    "payment_method_id": "pm_123",
    "invoice_id": "inv_123"
  }
  ```
- **Response**:
  ```json
  {
    "id": "txn-124",
    "amount": 100.00,
    "status": "processing",
    "receipt_url": "https://..."
  }
  ```

## 📱 Push Notifications

### 1. Register Device for Push
- **Endpoint**: `POST /notifications/devices`
- **Request**:
  ```json
  {
    "token": "device_push_token",
    "platform": "ios",
    "device_id": "device-123"
  }
  ```

## 🔄 Synchronization

### 1. Get Updates
- **Endpoint**: `GET /sync`
- **Query Params**:
  - `last_sync`: ISO 8601 timestamp of last sync
  - `tables`: Comma-separated list of tables to sync
- **Response**:
  ```json
  {
    "last_updated": "2023-01-20T15:30:00Z",
    "updates": {
      "courses": [
        {
          "id": "course-123",
          "action": "update",
          "data": {
            "name": "Updated Course Name"
          },
          "updated_at": "2023-01-20T10:00:00Z"
        }
      ],
      "deletions": [
        {
          "table": "assignments",
          "id": "assign-456"
        }
      ]
    }
  }
  ```

## 📊 Rate Limiting

- **Rate Limit**: 1000 requests per hour per IP
- **Headers**:
  - `X-RateLimit-Limit`: Total requests allowed
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: UTC timestamp when limit resets

## 🔐 Error Codes

| Code | Description |
|------|-------------|
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 422 | Validation Error |
| 429 | Too Many Requests |
| 500 | Internal Server Error |

## 📝 Changelog

### v1.0.0 (2023-10-01)
- Initial API release
- User authentication
- Course management
- Assignment submission
- Grade tracking

### v1.1.0 (2023-11-15)
- Added finance module
- Enhanced file uploads
- Improved error handling
- Performance optimizations

## 📞 Support

For API support, please contact:
- Email: api-support@schoolmanagement.com
- Documentation: https://docs.schoolmanagement.com/api
- Status Page: https://status.schoolmanagement.com
