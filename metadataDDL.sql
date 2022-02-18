drop table if exists fkAttributes;
drop table if exists foreignKeys;
drop table if exists ckAttributes;
drop table if exists primaryKeys;
drop table if exists uniques;
drop table if exists attributes;
drop table if exists types;
drop table if exists relationSchemes;
drop table if exists models;

create table models(
    modelName varchar(20) not null,
    constraint primary key schema_pk(modelName)
);

create table relationSchemes(
    classID int not null AUTO_INCREMENT,
    schemaName varchar(20) not null,
    relationName varchar(20) not null,
    constraint primary key relationSchemes_pk(classID),
    constraint unique relationSchemes_uk01(schemaName,relationName),
    constraint foreign key Schema_fk01(schemaName) references models(modelName)
);

create table types(
    typeName varchar(10) not null,
    hasLength bool not null,
    constraint primary key types_pk(typeName)
);

create table attributes(
    attID int not null auto_increment,
    classID int not null,
    attName varchar(30) not null,
    attType varchar(10) not null,
    attLength int,
    constraint primary key attributes_pk(attID),
    constraint unique attributes_uk01(classID,attName),
    constraint foreign key relation_fk01(classID) references relationSchemes(classID),
    constraint foreign key types_fk02(attType) references types(typeName)
);

create table uniques(
    keyID int not null auto_increment,
    keyName varchar(20) not null,
    classID int not null,
    constraint primary key uniques_pk(keyID),
    constraint unique uniques_ck01(keyName,classID),
    constraint foreign key relationSchemes_fk01(classID) references relationSchemes(classID)
);

create table primaryKeys(
    keyID int not null,
    constraint primary key primaryKeys_pk(keyID),
    constraint foreign key uniques_fk01(keyID) references uniques(keyID)
);

create table ckAttributes(
    keyID int not null,
    attID int not null,
    constraint primary key ckAttributes_pk(keyID,attID),
    constraint foreign key uniques_fk01(keyID) references uniques(keyID),
    constraint foreign key attributes_fk01(attID) references attributes(attID)
);

create table foreignKeys(
    keyId int not null auto_increment,
    keyName varchar(20) not null,
    classId int not null,
    referenceID int not null,
    crdnlty int,
    parentcrdnlty int,
    constraint primary key foreignKeys_pk(keyId),
    constraint unique foreignKeys_ck01(keyName,classId),
    constraint foreign key relationSchemes_fk01(classID) references relationSchemes(classID),
    constraint foreign key relationSchemes_fk02(referenceID) references relationSchemes(classID)
);

create table fkAttributes(
    keyID int not null,
    attID int not null,
    refID int not null,
    constraint primary key fkAttribute_pk(keyID,attId),
    constraint foreign key foreignKeys_fk01(keyID) references foreignKeys(keyID),
    constraint foreign key attributes_fk02(attID) references attributes(attID),
    constraint foreign key attributes_fk03(refID) references attributes(attID)
);