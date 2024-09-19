WITH ordered_entries AS (SELECT *
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
from (select client_id                                 as acc_id,
             row_number() OVER (ORDER BY client_id) AS gn,
             json_agg(json_build_object(
                              'value', sku,
                              'category', category,
                              'position', top
                      ) ORDER BY CAST(top AS INTEGER)) as list
      from ordered_entries
      group by client_id
      )
         as unique_data
      where gn > 0 AND gn <= 0 + 10;