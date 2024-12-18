# API Documentation

This document provides details about the API endpoints implemented for the `Lakumane` inventory management system.

---

## **Base URL**
`http://localhost:3000`

---

## **Endpoints**

### **Items API**

#### 1. GET `/items`
- **Description:** Retrieve a list of all items.
- **Response:**
  - **Status Code:** `200 OK`
  - **Body:**
    ```json
    [
      {
        "id": 1,
        "name": "Ballpen",
        "description": "A black ink ballpen",
        "category": { "name": "Stationery" },
        "shelf_number": "A-001",
        "current_quantity": 100,
        "optimal_quantity": 200,
        "reorder_threshold": 50,
        "unit": "pcs",
        "manufacturer": "Manufacturer A",
        "supplier_info": "Supplier A",
        "price": 12.5
      }
    ]
    ```

---

#### 2. GET `/items/:id`
- **Description:** Retrieve details of a specific item.
- **Parameters:**
  - `id` (integer) - The ID of the item.
- **Response:**
  - **Status Code:** `200 OK`
  - **Body:**
    ```json
    {
      "id": 1,
      "name": "Ballpen",
      "description": "A black ink ballpen",
      "category": "Stationery",
      "shelf_number": "A-001",
      "current_quantity": 100,
      "optimal_quantity": 200,
      "reorder_threshold": 50,
      "unit": "pcs",
      "manufacturer": "Manufacturer A",
      "supplier_info": "Supplier A",
      "price": 12.5
    }
    ```
  - **Error Response:**
    - **Status Code:** `404 Not Found`
    - **Body:**
      ```json
      { "error": "Item not found" }
      ```

---

#### 3. POST `/items`
- **Description:** Create a new item.
- **Request Body:**
  ```json
  {
    "item": {
      "name": "Ballpen",
      "description": "A black ink ballpen",
      "category_id": 1,
      "shelf_number": "A-001",
      "current_quantity": 100,
      "optimal_quantity": 200,
      "reorder_threshold": 50,
      "unit": "pcs",
      "manufacturer": "Manufacturer A",
      "supplier_info": "Supplier A",
      "price": 12.5
    }
  }
  ```
- **Response:**
  - **Status Code:** `201 Created`
  - **Body:**
    ```json
    {
      "id": 1,
      "name": "Ballpen",
      "description": "A black ink ballpen",
      "category_id": 1,
      "shelf_number": "A-001",
      "current_quantity": 100,
      "optimal_quantity": 200,
      "reorder_threshold": 50,
      "unit": "pcs",
      "manufacturer": "Manufacturer A",
      "supplier_info": "Supplier A",
      "price": 12.5
    }
    ```
  - **Error Response:**
    - **Status Code:** `422 Unprocessable Entity`
    - **Body:**
      ```json
      { "errors": ["Name can't be blank"] }
      ```

---

#### 4. PATCH `/items/:id`
- **Description:** Update an existing item.
- **Parameters:**
  - `id` (integer) - The ID of the item.
- **Request Body:**
  ```json
  {
    "item": {
      "name": "Updated Ballpen"
    }
  }
  ```
- **Response:**
  - **Status Code:** `200 OK`
  - **Body:**
    ```json
    {
      "id": 1,
      "name": "Updated Ballpen",
      "description": "A black ink ballpen",
      "category_id": 1,
      "shelf_number": "A-001",
      "current_quantity": 100,
      "optimal_quantity": 200,
      "reorder_threshold": 50,
      "unit": "pcs",
      "manufacturer": "Manufacturer A",
      "supplier_info": "Supplier A",
      "price": 12.5
    }
    ```
  - **Error Response:**
    - **Status Code:** `404 Not Found`
    - **Body:**
      ```json
      { "error": "Item not found" }
      ```

---

#### 5. DELETE `/items/:id`
- **Description:** Delete an item.
- **Parameters:**
  - `id` (integer) - The ID of the item.
- **Response:**
  - **Status Code:** `204 No Content`
  - **Error Response:**
    - **Status Code:** `404 Not Found`
    - **Body:**
      ```json
      { "error": "Item not found" }
      ```

---

### **Orders API**

#### 1. GET `/orders`
- **Description:** Retrieve a list of all orders.
- **Response:**
  - **Status Code:** `200 OK`
  - **Body:**
    ```json
    [
      {
        "id": 1,
        "item_id": 1,
        "quantity": 50,
        "status": "Pending",
        "created_at": "2024-12-15T00:00:00Z"
      }
    ]
    ```

---

#### 2. POST `/orders`
- **Description:** Create a new order.
- **Request Body:**
  ```json
  {
    "order": {
      "item_id": 1,
      "quantity": 50,
      "status": "Pending"
    }
  }
  ```
- **Response:**
  - **Status Code:** `201 Created`
  - **Body:**
    ```json
    {
      "id": 1,
      "item_id": 1,
      "quantity": 50,
      "status": "Pending",
      "created_at": "2024-12-15T00:00:00Z"
    }
    ```
  - **Error Response:**
    - **Status Code:** `422 Unprocessable Entity`
    - **Body:**
      ```json
      { "errors": ["Quantity must be greater than 0"] }
      ```

---

### **Authentication API**

#### 1. POST `/auth`
- **Description:** Register a new user.
- **Request Body:**
  ```json
  {
    "status": "success",
    "data": {
     "id": 1,
     "email": "user@example.com",
     "created_at": "2024-12-15T00:00:00Z"
   }
  }
  ```
- **Response:**
  - **Status Code:** `200 OK`
  - **Body:**
    ```json
    [
      {
        "id": 1,
        "item_id": 1,
        "quantity": 50,
        "status": "Pending",
        "created_at": "2024-12-15T00:00:00Z"
      }
    ]
    ```

---

#### 2. POST `/auth/sign_in`
- **Description:** Log in an existing user.
- **Request Body:**
  ```json
  {
    "email": "user@example.com",
   "password": "password123"
  }
  ```
- **Response:**
  - **Status Code:** `200 OK`
  - **Headers:**
    ```json
  {
    "access-token": "your-token",
   "token-type": "Bearer",
   "client": "your-client-id",
    "expiry": "timestamp",
   "uid": "user@example.com"
  }
  ```
- **Body:**
    ```json
  {
    "data": {
      "id": 1,
      "email": "user@example.com"
   }
  }
  ```

---

#### 3. Delete `/auth/sign_out`
- **Description:** Log out a user.
- **Headers:**
  ```json
  {
    "access-token": "your-token",
    "client": "your-client-id",
    "uid": "user@example.com"
  }
  ```
- **Response:**
  - **Status Code:** `200 OK`
  - **Body:**
    ```json
  { "success": true }
  ```

---

This document will continue to expand as new features are added to the system. For now, ensure this serves as a reliable guide for the current API functionalities.

