drop table if exists key_attributes;
drop table if exists foreign_keys;
drop table if exists primary_keys;
drop table if exists candidate_keys;
drop table if exists constraints;
drop table if exists key_types;
drop table if exists attributes;
drop table if exists datatypes;
drop table if exists relation_schemes;
drop table if exists models;

create table models (
    model_name varchar(50) not null,
    constraint primary key models_pk(model_name)
);
create table relation_schemes (
    model_name varchar(50) not null,
    scheme_name varchar(50) not null,
    constraint primary key relation_schemes_pk(model_name,scheme_name),
    constraint foreign key relation_schemes_models_fk01(model_name) references models(model_name)
);
create table datatypes (
    type_name varchar(20) not null,
    has_length bool not null,
    constraint primary key datatypes_pk(type_name)
);
create table attributes (
    att_size int,
    model_name varchar(50) not null,
    scheme_name varchar(50) not null,
    att_name varchar(50) not null,
    att_type varchar(20) not null,
    att_index int not null,
    constraint primary key attributes_pk(model_name,scheme_name,att_name),
    constraint unique attributes_ck01(model_name,scheme_name,att_index),
    constraint foreign key attributes_relation_schemes_fk01(model_name,scheme_name) references relation_schemes(model_name, scheme_name),
    constraint foreign key attributes_datatypes_fk02(att_type) references datatypes(type_name)
);
create table constraints(
    key_name varchar(50) not null,
    model_name varchar(50) not null,
    scheme_name varchar(50) not null,
    constraint primary key constraints_pk(key_name, model_name),
    constraint foreign key constraints_models_fk01(model_name) references models(model_name),
    constraint foreign key constraints_relation_schemes_fk02(model_name,scheme_name) references relation_schemes(model_name, scheme_name)#,
);
create table candidate_keys(
    key_name varchar(50) not null,
    model_name varchar(50) not null,
    constraint primary key candidate_keys_pk(key_name,model_name),
    constraint foreign key candidate_keys_constraints_fk01(key_name,model_name) references constraints(key_name, model_name)
);
create table primary_keys(
    key_name varchar(50) not null,
    model_name varchar(50) not null,
    constraint primary key primary_keys_pk(key_name,model_name),
    constraint foreign key primary_keys_candidate_keys_fk01(key_name,model_name) references candidate_keys(key_name,model_name)
);
create table foreign_keys(
    key_name varchar(50) not null,
    model_name varchar(50) not null,
    parent_scheme varchar(50) not null,
    child_cardinality varchar(10) not null,
    parent_cardinality varchar(10) not null,
    constraint primary key foreign_keys_pk(key_name,model_name),
    constraint foreign key foreign_keys_constraints_fk01(key_name,model_name) references constraints(key_name, model_name),
    constraint foreign key foreign_keys_relation_schemes_fk02(model_name,parent_scheme) references relation_schemes(model_name, scheme_name)
);
create table key_attributes(
    att_index int not null,
    key_name varchar(50) not null,
    model_name varchar(50) not null,
    scheme_name varchar(50) not null,
    att_name varchar(50) not null,
    ref_scheme_name varchar(50),
    ref_att_name varchar(50),
    constraint primary key key_attributes_pk(key_name,model_name,scheme_name,att_name),
    constraint unique key_attribute_ck01(key_name,model_name,att_index),
    constraint unique key_attribute_ck02(key_name,model_name,ref_scheme_name,ref_att_name),
    constraint foreign key key_attributes_constraints_fk01(key_name, model_name) references constraints(key_name, model_name),
    constraint foreign key key_attributes_attributes_fk02(model_name,scheme_name,att_name) references attributes(model_name,scheme_name,att_name),
    constraint foreign key key_attributes_attributes_fk03(model_name,ref_scheme_name,ref_att_name) references attributes(model_name,scheme_name,att_name)
);
