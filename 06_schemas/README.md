* schemas
* distinct
* begin;commit;

* generate_series
```sql
SELECT * FROM generate_series(
    '2024-01-01'::date,
    '2024-01-05'::date,
    '1 day'::interval
);
```
* SELECT generate_series(1, 10);

* array no sql: SELECT array['2332','2323'];

* random(): SELECT matricula from aluno order by random() limit 3;


* Distinct, Schemas, transações e etc.

* Exists, IN e etc.
