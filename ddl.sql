create table if not exists public.data
(
    client_id varchar(35) not null,
    sku       varchar(35) not null,
    top       varchar(35) not null,
    category  varchar(35),
    month     varchar(35),
    year      integer,
    primary key (client_id, sku, top)
);

alter table public.data
    owner to postgres;

