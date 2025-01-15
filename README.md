# Project Overview

This project was developed as a response to [the evaluation task from Goji Labs](ASSIGNMENT.md).

**Note:**
- Section API and Enrollments API are ready for use. At present, all other entities (Teachers, Classrooms, Subjects, Students) must be manually added to the database.
- PDF export functionality has not yet been implemented.
- Additionally, there are plans to enhance the API responses, making them more informative.

# Deployment

### Prerequisites

- Ruby 3.3.5
- Bundler 2.5.23
- Docker

### 1. Install gems

```bash
sudo apt install libpq-dev

bundle install
```

### 2. Environment variables

Set them in the `.env` file (a [template](.env.template) is provided) or in the environment itself:

### 3. Database setup

```bash
docker compose up
```

Create databases for both the development and test environments:

```bash
rails db:setup
```

Now you should be all set to run the application using `rails s` or use RSpec.


# cURL Samples

### Sections API

- **Create a section**

```bash
curl --location 'localhost:3000/sections' \
--header 'Content-Type: application/json' \
--data '{
    "section": {
      "teacher_id": "1",
      "subject_id": "8",
      "classroom_id": "1",
      "section_schedules_attributes": [
        {
          "day_of_week": "1",
          "start_time": "10:00am",
          "end_time": "10:50am"
        },
        {
          "day_of_week": "1",
          "start_time": "10:50am",
          "end_time": "11:40am"
        }
      ]
    }
  }'
```

Response:

```json
{
    "id": 4,
    "teacher_id": 1,
    "subject_id": 8,
    "classroom_id": 1,
    "created_at": "2025-01-15T21:18:42.835Z",
    "updated_at": "2025-01-15T21:18:42.835Z"
}
```


- **Show a section**

```bash
curl --location 'localhost:3000/sections/4'
```

Response:

```json
{
    "id": 4,
    "teacher_id": 1,
    "subject_id": 8,
    "classroom_id": 1,
    "created_at": "2025-01-15T21:18:42.835Z",
    "updated_at": "2025-01-15T21:18:42.835Z"
}
```

### Enrollments API

- **Enroll for a section**

```bash
curl --location --request POST 'localhost:3000/enrollments' \
  -H 'Content-Type: application/json' \
  -d '{
    "enrollment": {
      "student_id": "1",
      "section_id": "4"
    }
  }'
```

Response:

```json
{
    "id": 20,
    "student_id": 1,
    "section_id": 4,
    "created_at": "2025-01-15T22:12:07.989Z",
    "updated_at": "2025-01-15T22:12:07.989Z"
}
```

- **Show an enrollment**

```bash
curl --location 'localhost:3000/enrollments/20'
```

Response:

```json
{
    "id": 20,
    "student_id": 1,
    "section_id": 4,
    "created_at": "2025-01-15T22:12:07.989Z",
    "updated_at": "2025-01-15T22:12:07.989Z"
}
```

- **Cancel enrollment**

```bash
curl --location --request DELETE 'localhost:3000/enrollments/20'
```

Response: 204
