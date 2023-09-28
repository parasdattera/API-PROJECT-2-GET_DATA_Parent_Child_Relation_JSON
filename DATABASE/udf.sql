-- FUNCTION: public.get_complete_progress_data()

-- DROP FUNCTION IF EXISTS public.get_complete_progress_data();

CREATE OR REPLACE FUNCTION public.get_complete_progress_data(
	)
    RETURNS jsonb
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    result jsonb;
BEGIN
    SELECT jsonb_agg(jsonb_build_object(
        'id', p.id,
        'type', p.type,
        'lock', p.lock,
        'is_bucket', p.isbucket,
        'parent_id', p.parent_id,
        'bucket_desc', p.bucket_desc,
        'is_complete', p.iscomplete,
        'show_on_bar', p.show_on_bar,
        'auto_trigger', p.autotrigger,
        'autotrigger_id', p.autotrigger_id,
        'sub_progress_data', CASE WHEN has_children(p.id) THEN get_progress_data(p.id) ELSE '[]'::jsonb END
    )) INTO result
    FROM progress_bar_types p
    WHERE p.parent_id IS NULL;

    RETURN result;
END;
$BODY$;

ALTER FUNCTION public.get_complete_progress_data()
    OWNER TO postgres;






-- FUNCTION: public.has_children(integer)

-- DROP FUNCTION IF EXISTS public.has_children(integer);

CREATE OR REPLACE FUNCTION public.has_children(
	parent_id integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    RETURN EXISTS (SELECT 1 FROM progress_bar_types WHERE progress_bar_types.parent_id = has_children.parent_id);
END;
$BODY$;

ALTER FUNCTION public.has_children(integer)
    OWNER TO postgres;






-- FUNCTION: public.get_progress_data(integer)

-- DROP FUNCTION IF EXISTS public.get_progress_data(integer);

CREATE OR REPLACE FUNCTION public.get_progress_data(
	parent_id integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    result jsonb;
BEGIN
    SELECT jsonb_agg(jsonb_build_object(
        'id', p.id,
        'type', p.type,
        'lock', p.lock,
        'is_bucket', p.isbucket,
        'parent_id', p.parent_id,
        'bucket_desc', p.bucket_desc,
        'is_complete', p.iscomplete,
        'show_on_bar', p.show_on_bar,
        'auto_trigger', p.autotrigger,
        'autotrigger_id', p.autotrigger_id,
        'sub_progress_data', CASE WHEN has_children(p.id) THEN get_progress_data(p.id) ELSE '[]'::jsonb END
    )) INTO result
    FROM progress_bar_types p
    WHERE p.parent_id = get_progress_data.parent_id;
    
    RETURN result;
END;
$BODY$;

ALTER FUNCTION public.get_progress_data(integer)
    OWNER TO postgres;
