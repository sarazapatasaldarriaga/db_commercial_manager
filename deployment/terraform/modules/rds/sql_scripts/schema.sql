USE commercial_manager;

CREATE TABLE supplier (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(15) NOT NULL,
  address VARCHAR(255) NOT NULL,
  date DATE
);

CREATE TABLE product (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DOUBLE NOT NULL,
  stock INT NOT NULL,
  supplier_id BIGINT,
  CONSTRAINT fk_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

CREATE TABLE client (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(15) NOT NULL
);

CREATE TABLE sale (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  date TIMESTAMP,
  client_id BIGINT,
  CONSTRAINT fk_sale_client FOREIGN KEY (client_id) REFERENCES client(id)
);

CREATE TABLE sale_item (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  sale_id BIGINT,
  product_id BIGINT,
  quantity INT NOT NULL,
  price DOUBLE NOT NULL,
  CONSTRAINT fk_sale FOREIGN KEY (sale_id) REFERENCES sale(id),
  CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product(id)
);

