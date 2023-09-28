create table progress_bar_types(
	id serial primary key,
	type varchar(255),
	show_on_bar boolean,
	parent_id integer,
	autotrigger boolean,
	autotrigger_id integer,
	lock boolean,
	isbucket boolean,
	bucket_desc varchar(255),
	iscomplete boolean,
	end_bar boolean,
	added_by bigint,
	added_on timestamp without time zone default now(),
	isactive boolean,
	is_assignee boolean default false);
	
	
INSERT INTO public.progress_bar_types (id, type, show_on_bar, parent_id, autotrigger, autotrigger_id, lock, isbucket, bucket_desc, iscomplete, end_bar, added_by, added_on, isactive, is_assignee)
VALUES
    (1, 'Type 1', true, NULL, false, NULL, false, true, 'Bucket 1', false, false, NULL, now(), true, false),
    (2, 'Type 2', true, 1, true, 2, false, false, 'Bucket 2', false, false, NULL, now(), true, false),
    (3, 'Type 3', true, 1, true, 2, true, true, 'Bucket 3', false, false, NULL, now(), true, false),
    (4, 'Type 4', true, 2, true, 2, false, true, 'Bucket 4', false, false, NULL, now(), true, false),
    (5, 'Type 5', true, 3, true, 2, true, false, 'Bucket 5', false, false, NULL, now(), true, false),
    (6, 'Type 6', true, 3, true, 2, false, true, 'Bucket 6', false, false, NULL, now(), true, false),
    (7, 'Type 7', true, 5, true, 2, true, true, 'Bucket 7', false, false, NULL, now(), true, false);
	
	
-- real life sample 

/*
INSERT INTO public.progress_bar_types (type, show_on_bar, parent_id, autotrigger, autotrigger_id, lock, isbucket, bucket_desc, iscomplete, end_bar, added_by, isactive, is_assignee)
VALUES
    ('Task', true, null, false, null, false, false, null, false, false, 1, true, false),
    ('Subtask', true, 1, false, null, false, false, null, false, false, 1, true, false),
    ('Milestone', true, null, false, null, false, false, null, false, false, 1, true, false),
    ('Bug', true, null, false, null, false, false, null, false, false, 1, true, false),
    ('Feature', true, null, false, null, false, false, null, false, false, 1, true, false),
    ('Design', true, null, false, null, false, false, null, false, false, 1, true, false),
    ('Development', true, null, false, null, false, false, null, false, false, 1, true, false),
    ('Testing', true, null, false, null, false, false, null, false, false, 1, true, false),
    ('Completed', true, null, false, null, false, false, null, true, true, 1, true, false);
*/
--
	
select * from progress_bar_types




with recursive get_data as(
	select id, type, show_on_bar, parent_id, autotrigger, autotrigger_id, lock, isbucket, bucket_desc, 
	iscomplete, end_bar, added_by, added_on, isactive, is_assignee
	from progress_bar_types
	where id=1
	union
	select p.id, p.type, p.show_on_bar, p.parent_id, p.autotrigger, p.autotrigger_id, p.lock, p.isbucket, p.bucket_desc, 
	p.iscomplete, p.end_bar, p.added_by, p.added_on, p.isactive, p.is_assignee
	from progress_bar_types p
	join get_data s on p.parent_id =s.id)
select * from get_data;












-- create function public.udf_get_all_hierarichal_top_to_bottom_parent_child_data(_id varchar)
-- returns json
-- as
-- $body$
-- 	with recursive rec_tbl



