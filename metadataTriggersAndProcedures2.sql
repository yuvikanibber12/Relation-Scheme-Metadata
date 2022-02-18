delimiter //
set @block_change = true;
set @help =
'
new_candidate()    : create new candidate/primary key
new_foreign()      : create new foreign key
add_key_att()      : add attributes to candidate/primary key
migrate_att()      : migrate attribute from parent to child via foreign key
get_ddl()          : convert a given scheme to ddl
clear_key_atts()   : remove all key attributes from a specified key
delete_key()       : remove key
add_scheme_att()   : add a new attribute to a scheme
clear_scheme_atts(): remove all attributes from a specified scheme';
drop trigger if exists pre_insert_constraints;
create trigger pre_insert_constraints before insert on constraints
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change constraints table';
        end if;
    end;
drop trigger if exists pre_update_constraints;
create trigger pre_update_constraints before update on constraints
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change constraints table';
        end if;
    end;
drop trigger if exists pre_delete_constraints;
create trigger pre_delete_constraints before delete on constraints
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change constraints table';
        end if;
    end;
drop trigger if exists pre_insert_candidate_keys;
create trigger pre_insert_candidate_keys before insert on candidate_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change candidate_keys table';
        end if;
    end;
drop trigger if exists pre_update_candidate_keys;
create trigger pre_update_candidate_keys before update on candidate_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change candidate_keys table';
        end if;
    end;
drop trigger if exists pre_delete_candidate_keys;
create trigger pre_delete_candidate_keys before delete on candidate_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change candidate_keys table';
        end if;
    end;
drop trigger if exists pre_insert_primary_keys;
create trigger pre_insert_primary_keys before insert on primary_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change primary_keys table';
        end if;
    end;
drop trigger if exists pre_update_primary_keys;
create trigger pre_update_primary_keys before update on primary_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change primary_keys table';
        end if;
    end;
drop trigger if exists pre_delete_primary_keys;
create trigger pre_delete_primary_keys before delete on primary_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change primary_keys table';
        end if;
    end;
drop trigger if exists pre_insert_foreign_keys;
create trigger pre_insert_foreign_keys before insert on foreign_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change foreign_keys table';
        end if;
    end;
drop trigger if exists pre_update_foreign_keys;
create trigger pre_update_foreign_keys before update on foreign_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change foreign_keys table';
        end if;
    end;
drop trigger if exists pre_delete_foreign_keys;
create trigger pre_delete_foreign_keys before delete on foreign_keys
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change foreign_keys table';
        end if;
    end;
drop trigger if exists pre_insert_key_attributes;
create trigger pre_insert_key_attributes before insert on key_attributes
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change key_attributes table';
        end if;
    end;
drop trigger if exists pre_update_key_attributes;
create trigger pre_update_key_attributes before update on key_attributes
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change key_attributes table';
        end if;
    end;
drop trigger if exists pre_delete_key_attributes;
create trigger pre_delete_key_attributes before delete on key_attributes
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change key_attributes table';
        end if;
    end;
drop trigger if exists pre_insert_attributes;
create trigger pre_insert_attributes before insert on attributes
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change attributes table';
        end if;
    end;
drop trigger if exists pre_update_attributes;
create trigger pre_update_attributes before update on attributes
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change attributes table';
        end if;
    end;
drop trigger if exists pre_delete_attributes;
create trigger pre_delete_attributes before delete on attributes
    for each row
    begin
        if @block_change
            then
            signal sqlstate '45000'
                set message_text = 'do not manually change attributes table';
        end if;
    end;

drop procedure if exists new_candidate;
create procedure new_candidate(
    IN in_model_name varchar(50),
    IN in_scheme_name varchar(50),
    IN in_key_name varchar(50),
    IN is_primary bool
)
begin
    set @block_change = false;
    #check that model_name/scheme name exists
    if (select count(*) from relation_schemes where (model_name,scheme_name) = (in_model_name,in_scheme_name)) = 0
    then
        signal sqlstate '45000'
            set message_text = 'model-scheme does not exist';
    end if;

    #check that key_name is available
    if (select count(*) from constraints where (key_name) = (in_key_name)) > 0
    then
        signal sqlstate '45000'
            set message_text = 'constraint name already used';
    end if;

    insert into constraints(model_name,scheme_name,key_name)
        values (in_model_name,in_scheme_name,in_key_name);
    insert into candidate_keys(model_name,key_name)
        values (in_model_name,in_key_name);

    if not is_primary
    then
        #check if any primaries exist for scheme/model. if not, change to primary
        if (
            select count(*)
            from constraints
                inner join primary_keys using(key_name, model_name)
            where (model_name,scheme_name) = (in_model_name,in_scheme_name)
            ) = 0
        then
            set is_primary = true;
        end if;
    end if;



    if is_primary
    then
        delete from primary_keys where key_name in (
            select key_name
            from constraints
            where (model_name, scheme_name) = (in_model_name,in_scheme_name)
            );
        insert into primary_keys(model_name,key_name)
        values (in_model_name,in_key_name);
    end if;
    set @block_change = true;
end;

drop procedure if exists new_foreign;
create procedure new_foreign(
    IN in_model_name varchar(50),
    IN in_scheme_name varchar(50),
    IN in_key_name varchar(50),
    IN in_parent_scheme_name varchar(50),
    IN in_parent_cardinality varchar(10),
    IN in_cardinality varchar(10)
)
#TODO: account for deletes with pk/ck stuff (do not allow deletion of pk unless it is the only ck)
#TODO: make it so that pk can be changed (if no fk's coming off of it)
begin
    set @block_change = false;
    #check if parent exists
    if (select count(*) from relation_schemes where (model_name,scheme_name) = (in_model_name,in_parent_scheme_name)) = 0
    then
        signal sqlstate '45000'
            set message_text = 'parent model-scheme does not exist';
    end if;
    #check if child exists
    if (select count(*) from relation_schemes where (model_name,scheme_name) = (in_model_name,in_scheme_name)) = 0
    then
        signal sqlstate '45000'
            set message_text = 'child model-scheme does not exist';
    end if;
    #check if key_name is available
    if (select count(*) from constraints where (key_name) = (in_key_name)) > 0
    then
        signal sqlstate '45000'
            set message_text = 'constraint name already used';
    end if;

    insert into constraints(model_name, scheme_name, key_name)
    values (in_model_name,in_scheme_name,in_key_name);
    insert into foreign_keys(model_name,key_name,parent_scheme,child_cardinality,parent_cardinality)
    values (in_model_name,in_key_name,in_parent_scheme_name,in_cardinality,in_parent_cardinality);
    set @block_change = true;
end;

drop procedure if exists add_key_att;
create procedure add_key_att(
    IN in_model_name varchar(50),
    IN in_key_name varchar(50),
    IN in_att_name varchar(50),
    IN in_index int
)
begin
    declare this_scheme varchar(50);
    declare next_key varchar(50);
    declare i,n int;
    declare done int default false;
    declare con_cur cursor for select key_name from constraints;
    declare continue handler for not found set done = true;

    set @block_change = false;
    #check if key exists
    if (select count(*) from candidate_keys where (model_name, key_name) = (in_model_name,in_key_name)) = 0
    then
        signal sqlstate '45000'
            set message_text = 'candidate/primary key does not exist in this model';
    end if;
    #get scheme
    select scheme_name into this_scheme
    from constraints
    where key_name = in_key_name;
    #check if att is part of scheme
    if (
        select count(*)
        from attributes
            inner join relation_schemes using(model_name, scheme_name)
        where (model_name,scheme_name) = (in_model_name,this_scheme)
        and
            att_name = in_att_name
        ) = 0
    then
        signal sqlstate '45000'
            set message_text = 'no att with specified name in this scheme';
    end if;
    #check if att is already in ck/pk
    if (
        select count(*)
        from key_attributes
            inner join candidate_keys using(model_name,key_name)
        where (model_name,key_name) = (in_model_name,in_key_name)
        and
            att_name = in_att_name
        ) > 0
    then
        signal sqlstate '45000'
            set message_text = 'att already in ck/pk';
    end if;

    #check if the index is the next the the sequence
    #if there are no attributes in key yet
    if (select count(*) from key_attributes where (model_name,key_name)=(in_model_name,in_key_name)) = 0 then
        if in_index <> 0 then
            signal sqlstate '45000'
                set message_text = 'starting index must be 0';
        end if;
    else
        if in_index-1 <> (select max(att_index) from key_attributes where (model_name,key_name)=(in_model_name,in_key_name)) then
            signal sqlstate '45000'
                set message_text = 'key attribute indices must be sequential';
        end if;
    end if;

    #check to see if added attribute is part of an fk
    if (select count(*) from key_attributes where (model_name,ref_scheme_name,ref_att_name) = (in_model_name,this_scheme,in_att_name)) <> 0 then
        signal sqlstate '45000'
                set message_text = 'establish ck/pk\'s before migrating to this class to avoid splitting key';
    end if;


    #subkey check
    #if this att is already in another key in the same scheme
    if (
        select count(*)
        from key_attributes
            inner join candidate_keys using(model_name,key_name)
        where (model_name, scheme_name, att_name) = (in_model_name,this_scheme, in_att_name)
        ) != 0 then
            #check if adding would make this key a subkey
                #would only happen for adding the first att if it is not already a subkey

            #if this is the first att to be added to the key
            if (
            select count(*)
            from key_attributes
                inner join candidate_keys using(model_name,key_name)
            where (model_name, scheme_name, att_name) = (in_model_name,this_scheme, in_att_name)
            ) = 0 then
                signal sqlstate '45000'
                    set message_text = 'adding would make this key a subkey of another';

            else
            #check if adding would make another key a subkey

            #find other key(s)
            open con_cur;
            check_loop: loop
                fetch con_cur into next_key;
                if done then
                    leave check_loop;
                end if;
                #make sure key is candidate and part of this scheme
                if (
                    select count(*)
                    from constraints
                        inner join candidate_keys using(model_name,key_name)
                    where (model_name,scheme_name,key_name) = (in_model_name,this_scheme,next_key)
                    ) = 0 then
                    iterate check_loop;
                end if;
                #make sure not comparing against self
                if in_key_name = next_key then
                    iterate check_loop;
                end if;
                #make sure key isn't empty
                if (select count(*) from key_attributes where (model_name,key_name) = (in_model_name,next_key)) = 0 then
                    iterate check_loop;
                end if;

                #or instead, make check if the merging of the two tables results in a table of the size of the smaller table
                if (select count(*)
                from (
                    #get table of all att names of other key
                    (select att_name from key_attributes where (model_name, key_name) = (in_model_name,next_key)) other
                    inner join
                    #get table of all att names of this key + the att we want to add
                    ((select att_name from key_attributes where (model_name,key_name) = (in_model_name,in_key_name)) union (select in_att_name))this using(att_name))
                    )=
                #find size of smaller table #doesn't account for added attribute
                (select min(att_num)
                from (
                    (select count(*)+1 as att_num from key_attributes where (model_name,key_name) = (in_model_name,in_key_name)
                        union
                    (select count(*) as att_num from key_attributes where (model_name,key_name) = (in_model_name,next_key)))
                ) as k1) then
                    set @errorval = concat('adding would make this key a subkey of ',next_key);
                    signal sqlstate '45000'
                        set message_text = @errorval;
                end if;
                    #if so, error
            end loop;



            end if;
        end if;
    insert into key_attributes(model_name, key_name, scheme_name, att_name, att_index)
    values (in_model_name,in_key_name,this_scheme,in_att_name,in_index);
    set @block_change = true;
end;

drop procedure if exists migrate_att;
create procedure migrate_att(
    IN in_model_name varchar(50),
    IN in_key_name varchar(50),
    IN migrating_att varchar(50),
    IN migrated_att varchar(50),
    IN in_index int
)
begin
    declare parent_scheme_name varchar(50);
    declare child_scheme_name varchar(50);
    set @block_change = false;
    #check if model_name/key_name is a foreign key
    if (select count(*) from foreign_keys where (model_name, key_name) = (in_model_name,in_key_name)) = 0
    then
        signal sqlstate '45000'
            set message_text = 'foreign key does not exist in this model';
    end if;
    #TODO: make sure that migrated types of parent and child are the same
    #set parent and child schemes
    select parent_scheme,scheme_name into parent_scheme_name,child_scheme_name
    from foreign_keys
        inner join constraints using(key_name,model_name)
    where (model_name,key_name) = (in_model_name,in_key_name);
    #check if migrated_att exists in child scheme
    if (
        select count(*)
        from attributes
            inner join relation_schemes using(model_name,scheme_name)
        where (model_name,scheme_name) = (in_model_name,child_scheme_name)
            and
            att_name = migrated_att
        ) = 0
    then
        signal sqlstate '45000'
            set message_text = 'migrated att is not part of child';
    end if;
    #check if migrating_att exists in primary key of parent
    if (
        select count(*)
        from key_attributes
            inner join primary_keys using(key_name,model_name)
        where (model_name,scheme_name) = (in_model_name,parent_scheme_name)
        and
              att_name = migrating_att
        ) = 0
    then
        signal sqlstate '45000'
            set message_text = 'migrated att is not part of parent\'s primary key';
    end if;
    #check index is sequential
    if (select count(*) from key_attributes where (model_name,key_name)=(in_model_name,in_key_name)) = 0 then
        if in_index <> 0 then
            signal sqlstate '45000'
                set message_text = 'starting index must be 0';
        end if;
    else
        if in_index-1 <> (select max(att_index) from key_attributes where (model_name,key_name)=(in_model_name,in_key_name)) then
            signal sqlstate '45000'
                set message_text = 'key attribute indices must be sequential';
        end if;
    end if;

    #split checks
    #if first don't check
    if (select count(*) from key_attributes inner join foreign_keys using(key_name,model_name) where key_name = in_key_name) <> 0 then
        #if in_att part of child ck but other child att's in key are not: error
        if (
            select count(*)
            from key_attributes
                inner join candidate_keys using(model_name,key_name)
            where (model_name,scheme_name,att_name) = (in_model_name,child_scheme_name,migrated_att)
            ) <> 0 then
            if(
                #all atts that are fk children but not a member of child ck's
                select count(*) from
                (select *
                from key_attributes
                    inner join foreign_keys using(model_name,key_name)) as fk_attributes
                where att_name not in (select att_name from key_attributes where (model_name,scheme_name,att_name) = (in_model_name,child_scheme_name,migrated_att))
                ) = 0 then
                    signal sqlstate '45000'
                        set message_text = 'split key, cannot add non-ck child to ck fk. clear and reassign ck and try again.';
            end if;
            #if in_att not part of child ck but other att's in key are: error
        else
            if(
                #all atts that are fk children but not a member of child ck's
                select count(*) from
                (select *
                from key_attributes
                    inner join foreign_keys using(model_name,key_name)) as fk_attributes
                where att_name not in (select att_name from key_attributes where (model_name,scheme_name,att_name) = (in_model_name,child_scheme_name,migrated_att))
                ) <> 0 then
                    signal sqlstate '45000'
                        set message_text = 'split key, cannot add ck member to fk when the rest are. clear and reassign ck and try again.';
            end if;
        end if;
    end if;


    insert into key_attributes(model_name,key_name,scheme_name,att_name,ref_att_name,ref_scheme_name,att_index)
    values (in_model_name,in_key_name,child_scheme_name,migrated_att,migrating_att,parent_scheme_name,in_index);

    set @block_change = true;
end;

drop procedure if exists get_ddl;
create procedure get_ddl(
    IN in_model_name varchar(50),
    IN in_scheme_name varchar(50),
    OUT out_ddl varchar(1000)
)
begin
    declare n,m,i,j int;
    declare next_name varchar(50);
    declare next_type varchar(50);
    declare next_key varchar(50);
    declare fk_childs, fk_refs varchar(200);
    declare done int default false;
    declare con_cur cursor for select key_name from constraints;
    declare continue handler for not found set done = true;
    #check if scheme exists
    if (select count(*) from relation_schemes where (model_name,scheme_name) = (in_model_name,in_scheme_name)) = 0
    then
        signal sqlstate '45000'
            set message_text = 'table does not exist';
    end if;


    set out_ddl = '';
    #inital declaration
    set out_ddl = concat(out_ddl,'create table ',in_scheme_name,' (\n');

    #get all columns
    select count(*) into n from attributes where (model_name,scheme_name) = (in_model_name,in_scheme_name);
    set i = 0;
    WHILE i < n do
        select att_name, att_type into next_name, next_type
        from attributes
        where (model_name,scheme_name,att_index) = (in_model_name,in_scheme_name,i);
        #if type has size
        if (select has_length from datatypes where type_name = next_type)
        then
            set next_type = concat(next_type,'(',(select att_size from attributes where (model_name,scheme_name,att_index) = (in_model_name,in_scheme_name,i)),')');
        end if;
        set out_ddl = concat(out_ddl,'    ',next_name,' ',next_type);
        if i < n-1 then
            set out_ddl = concat(out_ddl,',\n');
        end if;
        set i = i + 1;
    end while;

    open con_cur;
    read_loop: loop
        fetch con_cur into next_key;
        if done then
            leave read_loop;
        end if;
        if (select count(*) from constraints where (key_name,model_name,scheme_name) = (next_key,in_model_name,in_scheme_name)) = 0 then
            iterate read_loop;
        end if;
        #if pk, display pk values
        if (select count(*) from primary_keys where key_name = next_key) > 0 then
            select count(*) into n
            from key_attributes
            where (model_name,scheme_name,key_name) = (in_model_name,in_scheme_name,next_key);

            set out_ddl = concat(out_ddl,',\n    constraint primary key ',next_key,'(');
            set i = 0;
            while i < n do
                set out_ddl = concat(out_ddl,(select att_name from attributes where (model_name,scheme_name,att_index) = (in_model_name,in_scheme_name,i)));
                if i < n-1 then
                    set out_ddl = concat(out_ddl,',');
                end if;
                set i = i + 1;
            end while;
            set out_ddl = concat(out_ddl,')');

        #else if ck, display ck values
        else if (select count(*) from candidate_keys where key_name = next_key) > 0 then
            select count(*) into n
            from key_attributes
            where (model_name,scheme_name,key_name) = (in_model_name,in_scheme_name,next_key);

            set out_ddl = concat(out_ddl,',\n    constraint unique ',next_key,'(');
            set i = 0;
            while i < n do
                set out_ddl = concat(out_ddl,(select att_name from key_attributes where (model_name,scheme_name,key_name,att_index) = (in_model_name,in_scheme_name,next_key,i)));
                if i < n-1 then
                    set out_ddl = concat(out_ddl,',');
                end if;
                set i = i + 1;
            end while;
            set out_ddl = concat(out_ddl,')');
        #else if fk, display fk values and references
        else
            select count(*) into n
            from key_attributes
            where (model_name,scheme_name,key_name) = (in_model_name,in_scheme_name,next_key);

            set out_ddl = concat(out_ddl,',\n    constraint foreign key ',next_key,'(');
            set i = 0;
            set fk_childs = '';
            set fk_refs = '';
            while i < n do
                set fk_childs = concat(fk_childs,(select att_name from key_attributes where (model_name,scheme_name,key_name,att_index) = (in_model_name,in_scheme_name,next_key,i)));
                set fk_refs   = concat(fk_refs,(select ref_att_name from key_attributes where (model_name,scheme_name,key_name,att_index) = (in_model_name,in_scheme_name,next_key,i)));

                if i < n-1 then
                    set fk_childs = concat(fk_childs,',');
                    set fk_refs = concat(fk_refs,',');
                end if;
                set i = i + 1;
            end while;
            set out_ddl = concat(out_ddl,fk_childs,') references ',(select parent_scheme from foreign_keys where key_name = next_key),'(',fk_refs,')');
        end if;
        end if;


    end loop;
    close con_cur;
    set out_ddl = concat(out_ddl,'\n);');

end;

drop procedure if exists clear_key_atts;
create procedure clear_key_atts(
    IN in_model_name varchar(50),
    IN in_key_name varchar(50)
)
begin
    set @block_change = false;
    #check valid key
    if (select count(*) from constraints where (model_name,key_name) = (in_model_name,in_key_name)) = 0 then
        signal sqlstate '45000'
            set message_text = 'specified key does not exist in specified model';
    end if;
    #check if clearable
        #if is migrating pk, cannot
            #find scheme, see if it is parent in any fk's
    if (select count(*) from primary_keys where (model_name,key_name) = (in_model_name,in_key_name)) <> 0 then
        if (select count(*)
            from (select scheme_name from constraints where (key_name,model_name) = (in_key_name,in_model_name)) as this_scheme
                inner join foreign_keys on scheme_name = parent_scheme)
            <> 0 then
            signal sqlstate '45000'
                set message_text = 'cannot clear migrating primary key. ';
        end if;
    end if;

    delete from key_attributes
    where (model_name,key_name) = (in_model_name,in_key_name);
    set @block_change = true;
end;

drop procedure if exists delete_key;
create procedure delete_key(
    IN in_model_name varchar(50),
    IN in_key_name varchar(50)
)
begin
    declare this_scheme varchar(50);
    set @block_change = false;
    #make sure key exists
    if (select count(*) from constraints where (model_name,key_name) = (in_model_name,in_key_name)) = 0 then
        signal sqlstate '45000'
            set message_text = 'specified key does not exist in specified model';
    end if;
    #make sure key is cleared
    if (select count(*) from key_attributes where (model_name,key_name) = (in_model_name,in_key_name)) <> 0 then
        signal sqlstate '45000'
            set message_text = 'key must be cleared before it is deleted';
    end if;
    #make sure key is not primary key (unless is only key)
    if (select count(*) from primary_keys where (model_name,key_name) = (in_model_name,in_key_name)) <> 0 then
        select scheme_name into this_scheme
        from constraints
        where (model_name,key_name) = (in_model_name,in_key_name);

        if (select count(*) from candidate_keys inner join constraints using(model_name,key_name) where (model_name,scheme_name) = (in_model_name,this_scheme)) > 1 then
            signal sqlstate '45000'
                set message_text = 'cannot directly delete primary key. transfer primary key or delete all other candidate keys first.';
        end if;
    end if;

    delete from primary_keys where (model_name,key_name) = (in_model_name,in_key_name);
    delete from candidate_keys where (model_name,key_name) = (in_model_name,in_key_name);
    delete from foreign_keys where (model_name,key_name) = (in_model_name,in_key_name);
    delete from constraints where (model_name,key_name) = (in_model_name,in_key_name);

    set @block_change = true;
end;

drop procedure if exists add_scheme_att;
create procedure add_scheme_att(
    IN in_model_name varchar(50),
    IN in_scheme_name varchar(50),
    IN in_att_name varchar(50),
    IN in_index int,
    IN in_att_type varchar(10),
    IN in_att_size int
)
begin
    set @block_change = false;
    #check scheme exists
    if (select count(*) from relation_schemes where (model_name,scheme_name) = (in_model_name,in_scheme_name)) = 0 then
        signal sqlstate '45000'
            set message_text = 'specified scheme does not exist in specified model';
    end if;
    #check att does not already exist in scheme
    if (select count(*) from attributes where (model_name,scheme_name,att_name) = (in_model_name,in_scheme_name,in_att_name)) <> 0 then
        signal sqlstate '45000'
            set message_text = 'attribute is already in model';
    end if;
    #make sure index is sequential starting from 0
    if (select count(*) from attributes where (model_name,scheme_name)=(in_model_name,in_scheme_name)) = 0 then
        if in_index <> 0 then
            signal sqlstate '45000'
                set message_text = 'starting index must be 0';
        end if;
    else
        if in_index-1 <> (select max(att_index) from attributes where (model_name,scheme_name)=(in_model_name,in_scheme_name)) then
            signal sqlstate '45000'
                set message_text = 'key attribute indices must be sequential';
        end if;
    end if;

    insert into attributes(model_name,scheme_name,att_name,att_index,att_type,att_size)
    values (in_model_name,in_scheme_name,in_att_name,in_index,in_att_type,in_att_size);

    set @block_change = true;
end;

drop procedure if exists clear_scheme_atts;
create procedure clear_scheme_atts(
    IN in_model_name varchar(50),
    IN in_scheme_name varchar(50)
)
begin
    set @block_change = false;
    #check if scheme exists
    if (select count(*) from relation_schemes where (model_name,scheme_name) = (in_model_name,in_scheme_name)) = 0 then
        signal sqlstate '45000'
            set message_text = 'specified scheme does not exist in specified model';
    end if;
    #check if in key
    if (select count(*) from constraints where (model_name,scheme_name) = (in_model_name,in_scheme_name)) <> 0 then
        signal sqlstate '45000'
            set message_text = 'cannot delete attributes that are potentially part of a key for this scheme.';
    end if;
    #check if parent
    if (select count(*) from foreign_keys where (model_name,parent_scheme) = (model_name,in_scheme_name)) <> 0 then
        signal sqlstate '45000'
            set message_text = 'cannot delete attributes that are potentially part of a parent key for this scheme.';
    end if;

    delete from attributes
    where (model_name,scheme_name) = (in_model_name,in_scheme_name);
    set @block_change = true;
end;

delimiter ;
