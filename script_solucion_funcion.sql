-- Mismo script de 'script_solucion.sql' pero con la función 'get_payload' que recibe un parámetro 'batch' para paginar los resultados.
CREATE OR REPLACE FUNCTION get_payload(batch INTEGER)
    RETURNS JSON AS
$$
BEGIN
    RETURN
        (WITH ordered_entries AS (SELECT *
                                  FROM data
                                  ORDER BY client_id, CAST(top AS INTEGER))
         select json_build_object(
                        'content', json_agg(
                         json_build_object(
                                 'identifiers', json_build_object('accountId', unique_data.acc_id),
                                 'list', unique_data.list
                         )
                                   ),
                        'entityType', 'PRIORITY'
                )
         from (select ordered_entries.client_id                                 as acc_id,
                      row_number() OVER (ORDER BY ordered_entries.client_id)    AS gn,
                      json_agg(json_build_object(
                                       'value', sku,
                                       'category', category,
                                       'position', top
                               ) ORDER BY CAST(top AS INTEGER)) as list
               from ordered_entries
               group by ordered_entries.client_id)
                  as unique_data
         where gn > batch
           AND gn <= batch + 10);
END;
$$ LANGUAGE plpgsql;

select get_payload(0);