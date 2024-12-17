
# Instructions for Running the URL Shortener API

## Prerequisites

Ensure that you have the following installed on your local machine:

- **Ruby 3.x** (Recommended: version 3.1.5 or later)
- **Rails 7.x**
- **PostgreSQL** (Make sure PostgreSQL is running on your machine)

## Setup Instructions

1. **Clone the repository**:
   Clone this repository to your local machine using the following command:

   ```bash
   git clone https://github.com/your-username/url_shortener_api.git
   cd url_shortener_api
   ```

2. **Install Ruby dependencies**:
   Make sure you have [Bundler](https://bundler.io/) installed to manage your Ruby dependencies.

   Install the required gems by running:

   ```bash
   bundle install
   ```

3. **Setup PostgreSQL**:
   Ensure that PostgreSQL is running locally. Create a new PostgreSQL database for this application using the following commands:

   ```bash
   # Login to PostgreSQL
   psql -U postgres

   # Create a new database
   CREATE DATABASE url_shortener_api_development;
   CREATE DATABASE url_shortener_api_test;
   ```

   You can also configure PostgreSQL to use your username and password if needed. Check `config/database.yml` for configuration options.

4. **Configure the database**:
   Open `config/database.yml` and ensure the following section is correctly configured for your local environment. The credentials should match your PostgreSQL setup.

   ```yaml
   development:
     adapter: postgresql
     database: url_shortener_api_development
     username: <%= ENV['DB_USERNAME'] %>
     password: <%= ENV['DB_PASSWORD'] %>
     host: <%= ENV['DB_HOST'] || 'localhost' %>

   test:
     adapter: postgresql
     database: url_shortener_api_test
     username: <%= ENV['DB_USERNAME'] %>
     password: <%= ENV['DB_PASSWORD'] %>
     host: <%= ENV['DB_HOST'] || 'localhost' %>

   production:
     adapter: postgresql
     database: url_shortener_api_production
     username: <%= ENV['DB_USERNAME'] %>
     password: <%= ENV['DB_PASSWORD'] %>
     host: <%= ENV['DB_HOST'] || 'localhost' %>
   ```

   Ensure that you have set the environment variables `DB_USERNAME`, `DB_PASSWORD`, and `DB_HOST` if necessary.

5. **Create and migrate the database**:
   After configuring PostgreSQL, run the following commands to create and migrate the database:

   ```bash
   rails db:create
   rails db:migrate
   ```

6. **Run the server**:
   You can start the Rails server with the following command:

   ```bash
   rails s
   ```

   The application should now be running on `http://localhost:3000`.

## API Endpoints

### 1. **Create a Shortened URL**

**POST** `/encode`

- **Request**:
  - `original_url`: The long URL you want to shorten (e.g., "https://example.com/long-url").

- **Response**:
  - `short_url`: The shortened URL (e.g., `http://localhost:3000/abc123`).

Example Request:

```bash
curl -X POST -d "original_url=https://example.com/long-url" http://localhost:3000/encode
```

Example Response:

```json
{
  "short_url": "http://localhost:3000/abc123"
}
```

### 2. **Get the Original URL from Short URL**

**POST** `/decode`

- **Request**:
  - `short_url`: The shortened URL's code (e.g., "http://localhost:3000/abc123").

- **Response**:
  - `original_url`: The long URL (e.g., "https://example.com/long-url").

Example Request:

```bash
curl -X POST -d "short_url=http://localhost:3000/abc123" http://localhost:3000/decode
```

Example Response:

```json
{
  "original_url": "https://example.com/long-url"
}
```

## Testing

### Running Tests

To run the tests for this application, use the following command:

```bash
bundle exec rspec
```

This will run all the unit tests.

## Potential Security Issues

- **CSRF Protection**: Although the API does not directly interact with the frontend, you should be aware of CSRF protection issues in Rails. If you're using this API with a frontend, consider managing CSRF tokens accordingly.

## Scalability Considerations

- **Caching**: Consider implementing caching mechanisms for frequently accessed URLs to reduce database load.
- **Rate Limiting**: To prevent abuse, implement rate limiting on the `encode` endpoint, limiting how many URLs can be generated per user or per IP address in a given time frame.

## Conclusion

By following the steps in this guide, you will have a fully functional URL shortener API running locally with PostgreSQL. Ensure that your environment variables are properly set and that your PostgreSQL instance is running to avoid connection issues.
