---

# Overview

- Take Home challenge in which the develoepr was asked to expose three endpoints of a sample tea subscription service
- Explores a many to many relationship, where Customers have many Teas through Subscriptions, and vice versa

---

# Learning Goals

- Sad path testing and functionality
- Expose an API for CRUD functionality

---

# Schema - 

![Screen Shot 2022-09-22 at 4 17 10 PM](https://user-images.githubusercontent.com/99755958/191854081-8dfd79c1-cb68-4985-a161-bc34cd2a516c.png)

---

# API Usage

- Available Endpoints:
  - [Creating Subscription](#CREATE)
  - [Cancelling Subscription](#CANCEL)
  - [Viewing all subscriptions](#VIEW)

---

# CREATE


**Create Subscription**

- This endpoint creates a subscription 
	

``` ruby
[GET] /api/v1/customers/1/subscriptions

```

 Example:

``` ruby 
[POST] /api/v1/customers/#{customer.id}/subscriptions?tea_id=2&title=first_subscription&price=50 dollars&frequency=monthly


```

RESPONSE:

```json
{
	"data": {
		"id": "2",
		"type": "subscription",
		"attributes": {
			"title": "first_subscription",
			"price": "50 dollars",
			"status": "active",
			"frequency": "monthly"
		}
	}
}
```
---

# CANCEL


**Cancel Subscription**

- This endpoint cancels a subscription
	

``` ruby
[PATCH] /api/v1/customers/#{customer.id}/subscriptions/#{subscription.id}

```

 Example:

``` ruby 
[PATCH] /api/v1/customers/1/subscriptions/1?status=cancelled

```

RESPONSE:

```json
{
	"data": {
		"id": "1",
		"type": "subscription",
		"attributes": {
			"title": "first_subscription",
			"price": "40 dollars",
			"status": "cancelled",
			"frequency": "weekly"
		}
	}
}
```


# VIEW


**Subscription Index**

- This endpoint shows all subscription of a given user
	

``` ruby
[GET]  /api/v1/customers/#{customer.id}/subscriptions


Required BODY: 
 - origin
 - destination
 - api_key
```

 Example:

``` ruby 
[GET]  /api/v1/customers/1/subscriptions

```

RESPONSE:

```json
{
	"data": [
		{
			"id": "1",
			"type": "subscription",
			"attributes": {
				"title": "first_subscription",
				"price": "40 dollars",
				"status": "cancelled",
				"frequency": "weekly"
			}
		},
		{
			"id": "2",
			"type": "subscription",
			"attributes": {
				"title": "first_subscription",
				"price": "50 dollars",
				"status": "active",
				"frequency": "monthly"
			}
		}
	]
}
```
---


# Feel like messing around?


## Installation

1. Clone this directory to your local repository using the SSH key:

```

$ git clone git@github.com:jimriddle1/tea_subscription.git

```

  

2. Install gems for development using [Bundler](https://bundler.io/guides/using_bundler_in_applications.html#getting-started---installing-bundler-and-bundle-init):

```

$ bundle install

```

  

3. Set up your database with:

```

$ rails db:{drop,create,migrate}

```

  

4. Run the test suite with:

```

$ bundle exec rspec

```

  

5. Run your development server with:

```

$ rails s

```
