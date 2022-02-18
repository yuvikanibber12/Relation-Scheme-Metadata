insert into datatypes (type_name, has_length)
values ('Varchar',true),
       ('Int', false),
       ('Text',true),
       ('Enumerated',false),
       ('Time',false);

insert into models (model_name)
values ('m1');

insert into relation_schemes (model_name, scheme_name)
values ('m1','courses'),
       ('m1','sections'),
       ('m1','departments'),
       ('m1','days'),
       ('m1','instructors'),
       ('m1','students'),
       ('m1','enrollments'),
       ('m1','transcript_entries'),
       ('m1','grades'),
       ('m1','semesters');

#attempt to add invalid type:
call add_scheme_att('m1','courses','name',0,'notvar',null);

call add_scheme_att('m1','courses','name',0,'Varchar',50);
call add_scheme_att('m1','courses','number',1,'Int',null);
call add_scheme_att('m1','courses','description',2,'Varchar',200);
call add_scheme_att('m1','courses','units',3,'Int',null);
call add_scheme_att('m1','courses','title',4,'Varchar',50);
call add_scheme_att('m1','sections','department_name',0,'Varchar',50);
call add_scheme_att('m1','sections','course_number',1,'Int',null);
call add_scheme_att('m1','sections','number',2,'Int',null);
call add_scheme_att('m1','sections','year',3,'Int',null);
call add_scheme_att('m1','sections','semester',4,'Varchar',50);
call add_scheme_att('m1','sections','instructor',5,'Varchar',50);
call add_scheme_att('m1','sections','start_time',6,'Time',null);
call add_scheme_att('m1','sections','days',7,'Varchar',50);
call add_scheme_att('m1','semesters','name',0,'Varchar',20);
call add_scheme_att('m1','departments','name',0,'Varchar',20);
call add_scheme_att('m1','instructors','instructor_name',0,'Varchar',30);
call add_scheme_att('m1','days','weekday_combinations',0,'Varchar',7);
call add_scheme_att('m1','students','student_id',0,'Int',null);
call add_scheme_att('m1','students','last_name',1,'Varchar',30);
call add_scheme_att('m1','students','first_name',2,'Varchar',30);
call add_scheme_att('m1','grades','grade_letter',0,'Varchar',2);
call add_scheme_att('m1','enrollments','student_id',0,'Int',null);
call add_scheme_att('m1','enrollments','department_name',1,'Varchar',20);
call add_scheme_att('m1','enrollments','course_number',2,'Int',null);
call add_scheme_att('m1','enrollments','section_number',3,'Int',null);
call add_scheme_att('m1','enrollments','year',4,'Int',null);
call add_scheme_att('m1','enrollments','semester',5,'Varchar',50);
call add_scheme_att('m1','enrollments','grade',6,'Varchar',2);
call add_scheme_att('m1','transcript_entries','student_id',0,'Int',null);
call add_scheme_att('m1','transcript_entries','department_name',1,'Varchar',20);
call add_scheme_att('m1','transcript_entries','course_number',2,'Int',null);
call add_scheme_att('m1','transcript_entries','section_number',3,'Int',null);
call add_scheme_att('m1','transcript_entries','year',4,'Int',null);
call add_scheme_att('m1','transcript_entries','semester',5,'Varchar',50);

call new_candidate('m1','departments','departments_pk',true);
call new_candidate('m1','days','days_pk',true);
call new_candidate('m1','instructors','instructors_pk',true);
call new_candidate('m1','grades','grades_pk',true);
call new_candidate('m1','students','students_pk',true);
call new_candidate('m1','enrollments','enrollments_pk',true);
call new_candidate('m1','transcript_entries','transcript_entries_pk',true);
call new_candidate('m1','semesters','semesters_pk',true);
call new_candidate('m1','sections','sections_pk',true);
#always have exactly 1 primary key example:
call new_candidate('m1','courses','courses_ck01',false);
call new_candidate('m1','courses','courses_pk',true);

call new_candidate('m1','courses','courses_ck02',false);
call delete_key('m1','courses_ck02');

#can't have same key name even if another type example:
call new_foreign('m1','sections','sections_pk','courses','1..1','0..*');

call add_key_att('m1','departments_pk','name',0);
call add_key_att('m1','days_pk','weekday_combinations',0);
call add_key_att('m1','instructors_pk','instructor_name',0);
call add_key_att('m1','semesters_pk','name',0);
call add_key_att('m1','grades_pk','grade_letter',0);
call add_key_att('m1','students_pk','student_id',0);
call add_key_att('m1','sections_pk','department_name',0);
call add_key_att('m1','sections_pk','course_number',1);
call add_key_att('m1','sections_pk','number',2);
call add_key_att('m1','sections_pk','year',3);
call add_key_att('m1','sections_pk','semester',4);
call add_key_att('m1','enrollments_pk','student_id',0);
call add_key_att('m1','enrollments_pk','department_name',1);
call add_key_att('m1','enrollments_pk','course_number',2);
call add_key_att('m1','enrollments_pk','section_number',3);
call add_key_att('m1','enrollments_pk','year',4);
call add_key_att('m1','enrollments_pk','semester',5);
call add_key_att('m1','transcript_entries_pk','student_id',0);
call add_key_att('m1','transcript_entries_pk','department_name',1);
call add_key_att('m1','transcript_entries_pk','course_number',2);
#prevent gaps in indices example:
call add_key_att('m1','courses_pk','number',1);
call add_key_att('m1','courses_pk','name',0);
call add_key_att('m1','courses_pk','number',1);

#key subkey test example
call add_key_att('m1','courses_ck01','name',0);
call add_key_att('m1','courses_ck01','title',0);
call add_key_att('m1','courses_ck01','name',1);

call new_foreign('m1','courses','courses_departments_fk01','departments','1..1','1..*');
call new_foreign('m1','sections','sections_courses_fk01','courses','1..1','0..*');
call new_foreign('m1','sections','sections_semesters_fk02','semesters','1..1','0..*');
call new_foreign('m1','sections','sections_instructors_fk03','instructors','1..1','0..*');
call new_foreign('m1','sections','sections_days_fk04','days','1..1','0..*');
call new_foreign('m1','enrollments','enrollments_students_fk01','students','1..1','0..*');
call new_foreign('m1','enrollments','enrollments_sections_fk02','sections','1..1','0..*');
call new_foreign('m1','enrollments','enrollments_grades_fk03','grades','1..1','0..*');
call new_foreign('m1','transcript_entries','transcript_entries_enrollments_fk01','enrollments','1..1','0..1');



call migrate_att('m1','courses_departments_fk01','name','name',0);
call migrate_att('m1','sections_semesters_fk02','name','semester',0);
call migrate_att('m1','sections_instructors_fk03','instructor_name','instructor',0);
call migrate_att('m1','sections_days_fk04','weekday_combinations','days',0);
call migrate_att('m1','enrollments_students_fk01','student_id','student_id',0);
call migrate_att('m1','enrollments_grades_fk03','grade_letter','grade',0);
#test invalid migrated column
call migrate_att('m1','sections_courses_fk01','name','title',0);
#test migrate from non-primary key
call migrate_att('m1','sections_courses_fk01','title','department_name',0);

call migrate_att('m1','sections_courses_fk01','name','department_name',0);
call migrate_att('m1','sections_courses_fk01','number','course_number',1);
call migrate_att('m1','enrollments_sections_fk02','department_name','department_name',0);
call migrate_att('m1','enrollments_sections_fk02','course_number','course_number',1);
call migrate_att('m1','enrollments_sections_fk02','number','section_number',2);
call migrate_att('m1','enrollments_sections_fk02','year','year',3);
call migrate_att('m1','enrollments_sections_fk02','semester','semester',4);
call migrate_att('m1','transcript_entries_enrollments_fk01','student_id','student_id',0);
call migrate_att('m1','transcript_entries_enrollments_fk01','department_name','department_name',1);
call migrate_att('m1','transcript_entries_enrollments_fk01','course_number','course_number',2);
#split key check example:
call migrate_att('m1','transcript_entries_enrollments_fk01','section_number','section_number',3);
#onto fixing the split:
call clear_key_atts('m1','transcript_entries_enrollments_fk01');
call delete_key('m1','transcript_entries_enrollments_fk01');
call add_key_att('m1','transcript_entries_pk','section_number',3);
call add_key_att('m1','transcript_entries_pk','year',4);
call add_key_att('m1','transcript_entries_pk','semester',5);
call new_foreign('m1','transcript_entries','transcript_entries_enrollments_fk01','enrollments','1..1','0..1');
call migrate_att('m1','transcript_entries_enrollments_fk01','student_id','student_id',0);
call migrate_att('m1','transcript_entries_enrollments_fk01','department_name','department_name',1);
call migrate_att('m1','transcript_entries_enrollments_fk01','course_number','course_number',2);
#now works:
call migrate_att('m1','transcript_entries_enrollments_fk01','section_number','section_number',3);

call migrate_att('m1','transcript_entries_enrollments_fk01','year','year',4);
call migrate_att('m1','transcript_entries_enrollments_fk01','semester','semester',5);


#ddl test
call get_ddl('m1','sections',@finish);
select @finish;
#ddl test 2
call get_ddl('m1','courses',@finish);
select @finish;

