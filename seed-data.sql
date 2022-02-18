--removed `
--changed int(xx) to int
--Primary key needs to change to constraint cname Key
--Key needs to change to constraint cname Index
--remove Engine,etc.
--reorder code so FKs can be created up front
--all inserts after tables are created
--changed comment style
--changed mediumtext to varchar(4000)
--changed text to varchar(400)
--changed image to varchar(100) to hold a file name instead
--changed format of unique constraint
--changed escape character for single quote from \' to ''
--commented out unique indexes in tables. They should not be unique. need to research this
--broke insert statements for orderlines into several inserts to avoid stack overflow

--CREATE DATABASE --/*!32312 IF NOT EXISTS*/classicmodels --/*!40100 DEFAULT CHARACTER SET latin1 */;

--USE classicmodels;

set schema "APP";

--/*Table structure for table offices */

insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(103,'Schmitt','Carine ','40.32.2555','54, rue Royale','44000')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(112,'King','Jean','7025551838','8489 Strong St.','83030')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(114,'Ferguson','Peter','03 9520 4555','636 St Kilda Road','3004')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(119,'Labrune','Janine ','40.67.8555','67, rue des Cinquante Otages','44000')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(121,'Bergulfsen','Jonas ','07-98 9555','Erling Skakkes gate 78','4110')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(124,'Nelson','Susan','4155551450','5677 Strong St.','97562')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(125,'Piestrzeniewicz','Zbyszek ','(26) 642-7555','ul. Filtrowa 68','01-012')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(128,'Keitel','Roland','+49 69 66 90 2555','Lyonerstr. 34','60528')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(129,'Murphy','Julie','6505555787','5557 North Pendale Street','94217')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(131,'Lee','Kwai','2125557818','897 Long Airport Avenue','10022')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(141,'Freyre','Diego ','(91) 555 94 44','C/ Moralzarzal, 86','28034')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(144,'Berglund','Christina ','0921-12 3555','BerguvsvÃƒÂ¤gen  8','S-958 22')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(145,'Petersen','Jytte ','31 12 3555','VinbÃƒÂ¦ltet 34','1734')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(146,'Saveley','Mary ','78.32.5555','2, rue du Commerce','69004')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(148,'Natividad','Eric','+65 221 7555','Bronz Sok.','079903')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(151,'Young','Jeff','2125557413','4092 Furth Circle','10022')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(157,'Leong','Kelvin','2155551555','7586 Pompton St.','70267')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(161,'Hashimoto','Juri','6505556809','9408 Furth Circle','94217')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(166,'Wendy','Wendy','+65 224 1555','106 Linden Road Sandown','069045')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(167,'Oeztan','Veysel','+47 2267 3215','Brehmen St. 121','N 5804')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(168,'Franco','Keith','2035557845','149 Spinnaker Dr.','97823')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(169,'de Castro','Isabel ','(1) 356-5555','Estrada da saÃƒÂºde n. 58','1756')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(171,'RancÃƒÂ©','Martine ','20.16.1555','184, chaussÃƒÂ©e de Tournai','59000')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(172,'Bertrand','Marie','(1) 42.34.2555','265, boulevard Charonne','75012')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(173,'Tseng','Jerry','6175555555','4658 Baden Av.','51247')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(175,'King','Julie','2035552570','25593 South Bay Ln.','97562')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(177,'Kentary','Mory','+81 06 6342 5555','1-6-20 Dojima',' 530-0003')
insert  into customers(customer_id,last_name,first_name,phone,street,zip) values(181,'Frick','Michael','2125551500','2678 Kingston Rd.','10022')
--/*Data for the table products */



insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S10_1678','1969 Harley Davidson Ultimate Chopper','Motorcycles','Min Lin Diecast',7933,95.70)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S10_1949','1952 Alpine Renault 1300','Classic Cars','Classic Metal Creations',7305,214.30)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S10_2016','1996 Moto Guzzi 1100i','Motorcycles','Highway 66 Mini Classics',6625,118.94)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S10_4698','2003 Harley-Davidson Eagle Drag Bike','Motorcycles','Red Start Diecast',5582,193.66)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S10_4757','1972 Alfa Romeo GTA','Classic Cars','Motor City Art Classics',                 3252,36.00)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S10_4962','1962 LanciaA Delta 16V','Classic Cars','Second Gear Diecast',                  6791,147.74)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_1099','1968 Ford Mustang','Classic Cars','Autoart Studio Design',                     68,194.57)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_1108','2001 Ferrari Enzo','Classic Cars','Second Gear Diecast',                       3619,207.80)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_1666','1958 Setra Bus','Trucks and Buses','Welly Diecast Productions',                1579,136.67)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_2823','2002 Suzuki XREO','Motorcycles','Unimax Art Galleries',                        9997,150.62)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_3148','1969 Corvair Monza','Classic Cars','Welly Diecast Productions',                6906,151.08)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_3380','1968 Dodge Charger','Classic Cars','Welly Diecast Productions',                9123,117.44)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_3891','1969 Ford Falcon','Classic Cars','Second Gear Diecast',                        1049,173.02)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_3990','1970 Plymouth Hemi Cuda','Classic Cars','Studio M Art Models',                 5663,79.80)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_4473','1957 Chevy Pickup','Trucks and Buses','Exoto Designs',                         6125,118.50)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S12_4675','1969 Dodge Charger','Classic Cars','Welly Diecast Productions',                7323,115.16)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S18_1097','1940 Ford Pickup Truck','Trucks and Buses','Studio M Art Models',              2613,116.67)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S18_1129','1993 Mazda RX-7','Classic Cars','Highway 66 Mini Classics',                    3975,141.54)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S18_1342','1937 Lincoln Berline','Vintage Cars','Motor City Art Classics',                8693,102.74)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S18_1367','1936 Mercedes-Benz 500K Special Roadster','Vintage Cars','Studio M Art Models',8635,53.91)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S18_1589','1965 Aston Martin DB5','Classic Cars','Classic Metal Creations',               9042,124.44)
insert  into products(UPC,prod_name,model,mfgr,units_in_stock,unit_list_price) values('S18_1662','1980s Black Hawk Helicopter','Planes','Red Start Diecast',                     5330,157.69)


--/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
--/*!40014 SET FOREIGN_UNIQUE_CHECKS=@OLD_FOREIGN_UNIQUE_CHECKS */;
--/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
--/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
