
USE Manufacturer

CREATE SCHEMA Manufac;

CREATE TABLE Manufac.Product(
	prod_id int PRIMARY KEY NOT NULL,
	prod_name VARCHAR(50) NOT NULL,
	quantity int NOT NULL
);

CREATE TABLE Manufac.Prod_Comp(
	prod_id int NOT NULL,
	comp_id int NOT NULL,
	quantity_comp int NOT NULL,
	PRIMARY KEY(prod_id, comp_id)
);

CREATE TABLE Manufac.Component(
	comp_id int PRIMARY KEY NOT NULL,
	comp_name VARCHAR(50) NOT NULL,
	description VARCHAR(50) NOT NULL,
	quantity_comp int NOT NULL
)

CREATE TABLE Manufac.Supplier(
	supp_id int PRIMARY KEY NOT NULL,
	supp_name VARCHAR(50) NOT NULL,
	supp_location VARCHAR(50) NOT NULL,
	supp_country VARCHAR(50) NOT NULL,
	is_active bit NOT NULL
)

CREATE TABLE Manufac.Comp_Supp(
	supp_id int NOT NULL,
	comp_id int NOT NULL,
	order_date DATE NOT NULL,
	quantity int NOT NULL
	PRIMARY KEY(supp_id, comp_id)
)

ALTER TABLE Manufac.Prod_Comp
ADD CONSTRAINT FK_prod
FOREIGN KEY (prod_id)
REFERENCES Manufac.Product (prod_id);

ALTER TABLE Manufac.Prod_Comp
ADD CONSTRAINT FK_comp1
FOREIGN KEY (comp_id)
REFERENCES Manufac.Component (comp_id);

ALTER TABLE Manufac.Comp_Supp
ADD CONSTRAINT FK_comp2
FOREIGN KEY (comp_id)
REFERENCES Manufac.Component (comp_id);

ALTER TABLE Manufac.Comp_Supp
ADD CONSTRAINT FK_supp
FOREIGN KEY (supp_id)
REFERENCES Manufac.Supplier (supp_id);


