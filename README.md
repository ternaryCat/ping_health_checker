# HEALTH CHECKER
Pings ips in background

## Usage
App has some api methods

### Creates ip for observing
`POST /api/v1/ip?address=:ip_v4`

#### Example
```
POST /api/v1/ip?address=8.8.8.8

{
  message: "ip is added"
}
````

### Deletes ip (stop observing)
`DELETE /api/v1/:ip_v4`

#### Example
```
DELETE /api/v1/8.8.8.8

{
  message: "ip is deleted"
}
```

### Calculates analytics
`GET /api/v1/:ip_v4/analytics`

#### Example

```
GET /api/v1/8.8.8.8/analytics

{
  analytics: {
    min_duration: 0.088685301,
    max_duration: 2.792826435,
    average_duration: 0.11331520559554974,
    median_duration: 0.090020252,
    standard_deviation_duration: 0.1642437964996478,
    packages_loss_percent: 0.5208333333333286
  }
}
```

### Background
For managering background workers, you can use page `/sidekiq`


## Setup
For local developing setuped docker-compose. You can just execute `docker-compose up`.

## Start tests
For tests need to create and migrate database `rake db:create RACK_ENV=test` & `rake db migrate RACK_ENV=test`.

Start test `rspec /spec`.
