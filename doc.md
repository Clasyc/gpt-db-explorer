# Database Schema Documentation (Dell Store 2)

This documentation provides detailed descriptions of the tables and their respective fields in the database. It is structured to offer insights into the design and intended use of each table and column. The database is structured around an e-commerce platform, focusing on customer details, product inventory, orders, and related entities.

## Tables and Descriptions

### `categories`

- **Description**: Holds information about product categories.
- **Columns**:
    - `category` (serial, NOT NULL): Unique identifier for the category. It is an auto-incrementing integer.
    - `categoryname` (character varying(50), NOT NULL): Name of the category.

### `cust_hist`

- **Description**: Tracks the order history of customers.
- **Columns**:
    - `customerid` (integer, NOT NULL): Identifier for the customer. Links to `customers.customerid`.
    - `orderid` (integer, NOT NULL): Identifier for the order. Links to `orders.orderid`.
    - `prod_id` (integer, NOT NULL): Product identifier. Links to `products.prod_id`.

### `customers`

- **Description**: Contains customer information.
- **Columns**:
    - `customerid` (serial, NOT NULL): Unique identifier for the customer. Auto-incrementing integer.
    - `firstname` (character varying(50), NOT NULL): Customer's first name.
    - `lastname` (character varying(50), NOT NULL): Customer's last name.
    - `address1` (character varying(50), NOT NULL): Primary address.
    - `address2` (character varying(50)): Secondary address (optional).
    - `city` (character varying(50), NOT NULL): City of residence.
    - `state` (character varying(50)): State of residence (optional).
    - `zip` (integer): Postal code.
    - `country` (character varying(50), NOT NULL): Country of residence.
    - `region` (smallint, NOT NULL): Numerical code representing the geographic region.
    - `email` (character varying(50)): Email address (optional).
    - `phone` (character varying(50)): Phone number (optional).
    - `creditcardtype` (integer, NOT NULL): Numeric code representing the type of credit card.
    - `creditcard` (character varying(50), NOT NULL): Credit card number.
    - `creditcardexpiration` (character varying(50), NOT NULL): Credit card expiration date.
    - `username` (character varying(50), NOT NULL): Username for customer account.
    - `password` (character varying(50), NOT NULL): Password for customer account.
    - `age` (smallint): Age of the customer (optional).
    - `income` (integer): Annual income (optional).
    - `gender` (character varying(1)): Gender of the customer (optional).

### `inventory`

- **Description**: Manages stock levels for products.
- **Columns**:
    - `prod_id` (integer, NOT NULL): Product identifier. Links to `products.prod_id`.
    - `quan_in_stock` (integer, NOT NULL): Quantity of the product currently in stock.
    - `sales` (integer, NOT NULL): Total sales of the product.

### `orderlines`

- **Description**: Details of individual items within an order.
- **Columns**:
    - `orderlineid` (integer, NOT NULL): Unique identifier for the order line.
    - `orderid` (integer, NOT NULL): Identifier of the order. Links to `orders.orderid`.
    - `prod_id` (integer, NOT NULL): Product identifier. Links to `products.prod_id`.
    - `quantity` (smallint, NOT NULL): Number of units of the product ordered.
    - `orderdate` (date, NOT NULL): Date the order was placed.

### `orders`

- **Description**: Records of customer orders.
- **Columns**:
    - `orderid` (serial, NOT NULL): Unique identifier for the order. Auto-incrementing integer.
    - `orderdate` (date, NOT NULL): Date the order was placed.
    - `customerid` (integer): Identifier of the customer who placed the order. Links to `customers.customerid`.
    - `netamount` (numeric(12,2), NOT NULL): Net amount of the order.
    - `tax` (numeric(12,2), NOT NULL): Tax amount for the order.
    - `totalamount` (numeric(12,2), NOT NULL): Total amount of the order (including tax).

### `products`

- **Description**: Information about the products.
- **Columns**:
    - `prod_id` (serial, NOT NULL): Unique identifier for the product. Auto-incrementing integer.
    - `category` (integer, NOT NULL): Category identifier. Links to `categories.category`.
    - `title` (character varying(50), NOT NULL): Name or title of the product.
    - `actor` (character varying(50), NOT NULL): The actor or artist involved in the product, applicable for movies, music, etc.
    - `price` (numeric(12,2), NOT NULL): Selling price of the product.
    - `special` (smallint): Flag indicating if the product is on special offer.
    - `common_prod_id` (integer, NOT NULL): Common product identifier used for grouping similar products.

### `reorder`

- **Description**: Information on product reorder levels and activities.
- **Columns**:
    - `prod_id` (integer, NOT NULL): Product identifier. Links to `products.prod_id`.
    - `date_low` (date, NOT NULL): Date when the product quantity was noted as low.
    - `quan_low` (integer, NOT NULL): Quantity of the product when noted as low.
    - `date_reordered` (date): Date when the product was reordered.
    - `quan_reordered` (integer): Quantity of the product reordered.
    - `date_expected` (date): Expected date for the reordered product to arrive.

## Sequences

Sequences are used to generate unique identifiers for various tables (`categories`, `customers`, `orders`, `products`) automatically. These sequences ensure that each entry in their respective tables has a unique, auto-incrementing ID.

- `categories_category_seq`
- `customers_customerid_seq`
- `orders_orderid_seq`
- `products_prod_id_seq`

Each sequence is associated with its respective table and column, such as `category` for `categories`, `customerid` for `customers`, etc., and is set to a specific starting value to maintain uniqueness and integrity within the database.

## Categories

The `categories` table includes the following categories:

1. Action
2. Animation
3. Children
4. Classics
5. Comedy
6. Documentary
7. Drama
8. Family
9. Foreign
10. Games
11. Horror
12. Music
13. New
14. Sci-Fi
15. Sports
16. Travel

## Schema

```
--
-- Name: categories; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE categories (
    category serial NOT NULL,
    categoryname character varying(50) NOT NULL
);


--
-- Name: categories_category_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('categories', 'category'), 16, true);


--
-- Name: cust_hist; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE cust_hist (
    customerid integer NOT NULL,
    orderid integer NOT NULL,
    prod_id integer NOT NULL
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE customers (
    customerid serial NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    address1 character varying(50) NOT NULL,
    address2 character varying(50),
    city character varying(50) NOT NULL,
    state character varying(50),
    zip integer,
    country character varying(50) NOT NULL,
    region smallint NOT NULL,
    email character varying(50),
    phone character varying(50),
    creditcardtype integer NOT NULL,
    creditcard character varying(50) NOT NULL,
    creditcardexpiration character varying(50) NOT NULL,
    username character varying(50) NOT NULL,
    "password" character varying(50) NOT NULL,
    age smallint,
    income integer,
    gender character varying(1)
);


--
-- Name: customers_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('customers', 'customerid'), 20000, true);


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE inventory (
    prod_id integer NOT NULL,
    quan_in_stock integer NOT NULL,
    sales integer NOT NULL
);


--
-- Name: orderlines; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE orderlines (
    orderlineid integer NOT NULL,
    orderid integer NOT NULL,
    prod_id integer NOT NULL,
    quantity smallint NOT NULL,
    orderdate date NOT NULL
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE orders (
    orderid serial NOT NULL,
    orderdate date NOT NULL,
    customerid integer,
    netamount numeric(12,2) NOT NULL,
    tax numeric(12,2) NOT NULL,
    totalamount numeric(12,2) NOT NULL
);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('orders', 'orderid'), 12000, true);


--
-- Name: products; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE products (
    prod_id serial NOT NULL,
    category integer NOT NULL,
    title character varying(50) NOT NULL,
    actor character varying(50) NOT NULL,
    price numeric(12,2) NOT NULL,
    special smallint,
    common_prod_id integer NOT NULL
);


--
-- Name: products_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chriskl
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('products', 'prod_id'), 10000, true);


--
-- Name: reorder; Type: TABLE; Schema: public; Owner: chriskl; Tablespace: 
--

CREATE TABLE reorder (
    prod_id integer NOT NULL,
    date_low date NOT NULL,
    quan_low integer NOT NULL,
    date_reordered date,
    quan_reordered integer,
    date_expected date
);

```