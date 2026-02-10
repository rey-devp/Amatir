# Data Requirements for Backend

## 1. Login
*   **Input Data**:
    *   `email` (string, required)
    *   `password` (string, required)
*   **Process**: Authenticate user with Firebase Auth.
*   **Output**: User session/token and User Profile (including `role`).

## 2. Admin Dashboard
*   **Stats API**:
    *   **Total Users**: Count of all documents in `users` collection.
    *   **Total Transactions**: Count of all documents in `orders` collection.
    *   **Total Revenue**: Sum of `price` field in `orders` collection (potentially filtered by status 'completed').
    *   **Growth/Trends**: Percentage change compared to previous period (optional advanced feature).
*   **Recent Alerts**:
    *   **Low Stock**: Query `products` collection where `stock` < threshold (e.g., 10).
*   **Profile**:
    *   **Admin Name**: From `users` collection based on current `uid`.

## 3. Manage Users
*   **List Users API**:
    *   **Input**: 
        *   `role` (string, optional): Filter by 'admin', 'courier', 'warehouse', 'customer'.
        *   `search` (string, optional): Search by `name` or `email`.
    *   **Output**: List of Users. each containing:
        *   `uid`
        *   `name`
        *   `email`
        *   `role`
        *   `image_url` (optional, for avatar)
        *   `is_online` (boolean, optional status)

## 4. Customer Home (Product Catalog)
*   **Profile**:
    *   **User Name**: From `users` collection (`name`).
    *   **Cart Count**: Number of items in user's cart (could be a sub-collection or field).
*   **Product List API**:
    *   **Input**:
        *   `search` (string, optional): Filter by product `name`.
    *   **Output**: List of Products, each containing:
        *   `id`
        *   `name`
        *   `price` (number)
        *   `image_url`

## 5. Order Tracking Detail
*   **Order Details API**:
    *   **Input**: `order_id` or `tracking_id`.
    *   **Output**:
        *   `tracking_id`
        *   `status` (pending, at_warehouse, on_delivery, delivered, completed)
        *   `est_arrival` (datetime)
        *   `tracking_history` (Array of objects):
            *   `status` (title)
            *   `description` (location or detail)
            *   `timestamp`
            *   `courier_info` (optional, only if status is 'on_delivery'):
                *   `name`
                *   `photo_url`
        *   `proof_of_delivery` (optional, null if not delivered):
            *   `status`
            *   `photo_url`

## 6. Warehouse Dashboard
*   **Stats API**:
    *   **Incoming Count**: Number of packages headed to this warehouse.
    *   **Outgoing Count**: Number of packages dispatched from this warehouse today.
*   **Package List API**:
    *   **Input**: `filter` (incoming, outgoing, history).
    *   **Output**: List of Packages/Orders.
        *   `tracking_id`
        *   `origin` (city/location)
        *   `status` (Pending, Arriving, Processed)
        *   `details` (e.g., quantity/type like "12 Boxes")
        *   `eta` (Estimated Arrival Time) or `timestamp`
*   **Profile**:
    *   **Warehouse Name**: From `users` name.

## 7. Update Package Location (Warehouse)
*   **Get Package Info API**:
    *   **Input**: `tracking_id` (scanned or typed).
    *   **Output**: Order Details (Current Location, Status, Product Info).
*   **Update Status API**:
    *   **Input**:
        *   `tracking_id`
        *   `new_location` (string)
        *   `new_status` (enum: inbound, sorting, outbound, issue)
        *   `updated_by` (warehouse user id)
    *   **Process**: Add new entry to `tracking_history` array and update parent `current_status`.

## 8. Courier Dashboard
*   **Profile**:
    *   **Courier Name**: From `users` name.
    *   **Photo URL**: From `users` profile.
    *   **Online Status**: Read/Write real-time status (optional).
*   **Stats API**:
    *   **Total Tasks Today**: Count of orders assigned to courier for today.
    *   **Completed Tasks**: Count of delivered orders today.
*   **Assigned Tasks API**:
    *   **Input**: `courier_id` (current user).
    *   **Output**: List of Orders.
        *   `order_id`
        *   `customer_name` or `location_name`
        *   `status` (In Transit, Pending)
        *   `is_priority` (boolean)
        *   `distance` (km)
        *   `address` (destination)
        *   `time_constraint` (optional)
        *   `payment_status` (e.g., Pre-paid)

## 9. Delivery Execution (Courier)
*   **Confirm Delivery API**:
    *   **Input**:
        *   `order_id`
        *   `proof_image` (file/blob)
        *   `gps_location` (lat, long string)
        *   `notes` (string, optional)
    *   **Process**:
        1.  Upload `proof_image` to Firebase Storage.
        2.  Get `image_url`.
        3.  Update `orders` document:
            *   Set `status` to 'delivered'.
            *   Add to `tracking_history`: `{ status: 'Delivered', description: notes, location: gps_location, proof_url: image_url, timestamp: now, updated_by: courier_id }`.
