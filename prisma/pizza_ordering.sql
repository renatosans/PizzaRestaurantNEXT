--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5
-- Dumped by pg_dump version 12.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: add_ingredient(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_ingredient(ingredient_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN	
	INSERT INTO public.ingredients(ingredient_name) VALUES (ingredient_name);
       
END;
$$;


ALTER FUNCTION public.add_ingredient(ingredient_name character varying) OWNER TO postgres;

--
-- Name: add_ingredients(integer, integer, numeric, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_ingredients(reg_id integer, ing_id integer, price numeric, stock_v integer, supp_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE 

BEGIN	

	INSERT INTO public.ingredient_region(region_id,ingredient_id,price,stock,supplier_id) VALUES (reg_id ,ing_id ,price ,stock_v ,supp_id );

        

END;

$$;


ALTER FUNCTION public.add_ingredients(reg_id integer, ing_id integer, price numeric, stock_v integer, supp_id integer) OWNER TO postgres;

--
-- Name: add_order_ing(integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_order_ing(ingredient_region_id integer[], base integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE 
order_id_declare integer;
curtime timestamp := now();
var int;
total_ing_price numeric(8,2);
b_price numeric(8,2);
tot_price numeric(8,2);
stocks integer;
BEGIN	
	INSERT INTO public.order(timestamp) VALUES (curtime);
        select order_id into order_id_declare  from public.order 
        ORDER BY TIMESTAMP DESC
        LIMIT 1;
        <<"FOREACH ingredients">>
        foreach var in array ingredient_region_id  loop
        INSERT INTO public.order_detail(base_id,ingredient_id,order_id) VALUES (base,var,order_id_declare);
        select stock into stocks from ingredient_region where ing_reg_id=var;
        UPDATE ingredient_region SET stock=stocks-1 where ing_reg_id=var;
        end loop "FOREACH ingredients";
		select sum(price) into total_ing_price FROM ingredient_region where ing_reg_id  in(select distinct ingredient_id from order_detail where order_id=order_id_declare);
		select price  into b_price from public.pizza_base as pb where pb.base_id=base;
		tot_price := total_ing_price + b_price;
		UPDATE public.order 
		SET
		total_price= tot_price   WHERE order_id = order_id_declare;
END;
$$;


ALTER FUNCTION public.add_order_ing(ingredient_region_id integer[], base integer) OWNER TO postgres;

--
-- Name: add_supplier(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_supplier(supp_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE

BEGIN

INSERT INTO supplier(supplier_name) VALUES (supp_name);

END;

$$;


ALTER FUNCTION public.add_supplier(supp_name character varying) OWNER TO postgres;

--
-- Name: delete_ingredients(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_ingredients(ing_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE 





BEGIN	

	DELETE from ingredient_region where ing_reg_id=ing_id;



        

END;

$$;


ALTER FUNCTION public.delete_ingredients(ing_id integer) OWNER TO postgres;

--
-- Name: delete_supplier(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_supplier(supp_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE

BEGIN

DELETE from supplier where supplier_id=supp_id;

END;

$$;


ALTER FUNCTION public.delete_supplier(supp_id integer) OWNER TO postgres;

--
-- Name: get_ing(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ing() RETURNS TABLE(id integer, ingredient_name character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT i.ingredient_id,i.ingredient_name

FROM ingredients as i

;

END;

$$;


ALTER FUNCTION public.get_ing() OWNER TO postgres;

--
-- Name: get_ingredients(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ingredients() RETURNS TABLE(id integer, ingredient_name character varying, region_name character varying, price numeric, stock integer, supplier_id integer, supplier_name character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT ir.ing_reg_id, i.ingredient_name,r.region_name,ir.price,ir.stock,s.supplier_id,s.supplier_name

FROM ingredients as i

JOIN 

ingredient_region as ir

on 

(i.ingredient_id=ir.ingredient_id)

JOIN

region as r

on

(r.region_id=ir.region_id)

JOIN

supplier as s

on

(ir.supplier_id=s.supplier_id)

where (i.flag='TRUE' AND ir.stock>0)

order by i.ingredient_name;

END;

$$;


ALTER FUNCTION public.get_ingredients() OWNER TO postgres;

--
-- Name: get_ingredientsb(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ingredientsb() RETURNS TABLE(id integer, ingredient_name character varying, region_name character varying, price numeric, stock integer, supplier_id integer, supplier_name character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT ir.ing_reg_id, i.ingredient_name,r.region_name,ir.price,ir.stock,s.supplier_id,s.supplier_name

FROM ingredients as i

JOIN 

ingredient_region as ir

on 

(i.ingredient_id=ir.ingredient_id)

JOIN

region as r

on

(r.region_id=ir.region_id)

JOIN

supplier as s

on

(ir.supplier_id=s.supplier_id)

where

s.hidden='TRUE'

order by i.ingredient_name;

END;

$$;


ALTER FUNCTION public.get_ingredientsb() OWNER TO postgres;

--
-- Name: get_ingredientsbaker(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ingredientsbaker() RETURNS TABLE(id integer, ingredient_name character varying, flag boolean)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT i.ingredient_id,i.ingredient_name,i.flag

FROM ingredients as i;

END;

$$;


ALTER FUNCTION public.get_ingredientsbaker() OWNER TO postgres;

--
-- Name: get_ingredientsbyid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ingredientsbyid(ing_id integer) RETURNS TABLE(id integer, ingredient_name character varying, region_name character varying, price numeric, stock integer, supplier_id integer, supplier_name character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT ir.ing_reg_id, i.ingredient_name,r.region_name,ir.price,ir.stock,s.supplier_id,s.supplier_name

FROM ingredients as i

JOIN 

ingredient_region as ir

on 

(i.ingredient_id=ir.ingredient_id)

JOIN

region as r

on

(r.region_id=ir.region_id)

JOIN

supplier as s

on

(ir.supplier_id=s.supplier_id)

where ir.ing_reg_id = ing_id;

END;

$$;


ALTER FUNCTION public.get_ingredientsbyid(ing_id integer) OWNER TO postgres;

--
-- Name: get_onlysupplier(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_onlysupplier() RETURNS TABLE(id integer, name character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	select supplier_id,supplier_name from supplier ;

END;

$$;


ALTER FUNCTION public.get_onlysupplier() OWNER TO postgres;

--
-- Name: get_pizzabase(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_pizzabase() RETURNS TABLE(id integer, base_size character varying, price numeric)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT distinct p.base_id,p.base_size,p.price

FROM pizza_base as p

order by p.base_id;

END;

$$;


ALTER FUNCTION public.get_pizzabase() OWNER TO postgres;

--
-- Name: get_region(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_region() RETURNS TABLE(id integer, region_name character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT * from region;

END;

$$;


ALTER FUNCTION public.get_region() OWNER TO postgres;

--
-- Name: get_supplier(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_supplier() RETURNS TABLE(id integer, supplier_name character varying, ingredient_name text, flag boolean)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT s.supplier_id,s.supplier_name, STRING_AGG(i.ingredient_name::character varying, ','),s.hidden

FROM 

supplier as s

LEFT JOIN 

ingredient_region as ir

on

(ir.supplier_id=s.supplier_id)

LEFT JOIN

ingredients as i

on 

(i.ingredient_id=ir.ingredient_id)



group by s.supplier_id,s.supplier_name

;

END;

$$;


ALTER FUNCTION public.get_supplier() OWNER TO postgres;

--
-- Name: get_supplierbyid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_supplierbyid(supp_id integer) RETURNS TABLE(id integer, supp_name character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY

	SELECT s.supplier_id,s.supplier_name from supplier as s where s.supplier_id=supp_id;

END;

$$;


ALTER FUNCTION public.get_supplierbyid(supp_id integer) OWNER TO postgres;

--
-- Name: hide_ingredient(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hide_ingredient(ingr_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

DECLARE status boolean;

BEGIN

	SELECT flag INTO status from ingredients where ingredient_id = ingr_id;

	if status= TRUE

	then

		status= FALSE;

	else

		status= TRUE;

	end if;

	UPDATE ingredients SET flag = status where ingredient_id = ingr_id;

RETURN STATUS;

END;

$$;


ALTER FUNCTION public.hide_ingredient(ingr_id integer) OWNER TO postgres;

--
-- Name: hide_supplier(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hide_supplier(supp_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

DECLARE status boolean;

BEGIN

	SELECT hidden INTO status from supplier where supplier_id= supp_id;

	if status= TRUE

	then

		status= FALSE;

	else

		status= TRUE;

	end if;

	UPDATE supplier SET hidden= status where supplier_id= supp_id;

RETURN STATUS;

END;

$$;


ALTER FUNCTION public.hide_supplier(supp_id integer) OWNER TO postgres;

--
-- Name: insert_ingredients(integer, character varying, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_ingredients(id integer, name character varying, flag boolean)
    LANGUAGE sql
    AS $$

INSERT INTO ingredients VALUES (id,name,flag);

$$;


ALTER PROCEDURE public.insert_ingredients(id integer, name character varying, flag boolean) OWNER TO postgres;

--
-- Name: insert_region(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_region(id integer, name integer)
    LANGUAGE sql
    AS $$

INSERT INTO region (region_id, region_name )VALUES (id,name);

$$;


ALTER PROCEDURE public.insert_region(id integer, name integer) OWNER TO postgres;

--
-- Name: insert_supplier(integer, character varying, boolean); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.insert_supplier(id integer, name character varying, flag boolean)
    LANGUAGE sql
    AS $$

INSERT INTO supplier(supplier_id, supplier_name,flag)VALUES (id,name,flag);

$$;


ALTER PROCEDURE public.insert_supplier(id integer, name character varying, flag boolean) OWNER TO postgres;

--
-- Name: orders(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.orders() RETURNS TABLE(order_id integer, ingredients text, base_size character varying, ordered_time timestamp without time zone)
    LANGUAGE plpgsql
    AS $$

BEGIN	

RETURN QUERY

	select o.order_id  ,STRING_AGG(i.ingredient_name, ',') ingredients,b.base_size , o.timestamp 

from

public.order as o

JOIN

order_detail as od

on

(o.order_id=od.order_id)

JOIN

pizza_base as b

on

od.base_id=b.base_id

JOIN

ingredient_region as ip

on

od.ingredient_id =ip.ing_reg_id

JOIN

ingredients i

on

ip.ingredient_id=i.ingredient_id



group by  o.order_id,b.base_size,o.timestamp

ORDER by o.timestamp DESC;

END;

$$;


ALTER FUNCTION public.orders() OWNER TO postgres;

--
-- Name: recent_orders(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recent_orders() RETURNS TABLE(order_id integer, ingredient_name character varying, base_size character varying, ordered_time timestamp without time zone)
    LANGUAGE plpgsql
    AS $$

BEGIN	

RETURN QUERY

	select o.order_id,i.ingredient_name,b.base_size, o.timestamp

from

public.order as o

JOIN

order_detail as od

on

(o.order_id=od.order_id)

JOIN

pizza_base as b

on

od.base_id=b.base_id

JOIN

ingredients as i

on

od.ingredient_id =i.ingredient_id

ORDER by o.timestamp DESC

limit 5;

END;

$$;


ALTER FUNCTION public.recent_orders() OWNER TO postgres;

--
-- Name: restock(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.restock(id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE

additional_stock integer := 5;

BEGIN

	UPDATE ingredient_region

        SET stock = stock + additional_stock

        where ing_reg_id = id;

END;

$$;


ALTER FUNCTION public.restock(id integer) OWNER TO postgres;

--
-- Name: restock(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.restock(id integer, value integer)
    LANGUAGE sql
    AS $$

UPDATE ingredients

   SET stock = stock + value

WHERE ingredient_id= id;

$$;


ALTER PROCEDURE public.restock(id integer, value integer) OWNER TO postgres;

--
-- Name: update_ingredients(integer, character varying, integer, numeric, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_ingredients(ing_id integer, ing_name character varying, reg_id integer, up_price numeric, supp_id integer, up_stock integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE

ingid integer;

BEGIN

    UPDATE ingredient_region

    SET 

    region_id=reg_id,

    price = up_price,

    supplier_id=supp_id,

    stock=up_stock

    where

    ing_reg_id=ing_id;



    select i.ingredient_id into ingid

    from ingredients as i

    join

    ingredient_region as ir

    on

    (i.ingredient_id=ir.ingredient_id)

    where ir.ing_reg_id=ing_id;

     

END;

$$;


ALTER FUNCTION public.update_ingredients(ing_id integer, ing_name character varying, reg_id integer, up_price numeric, supp_id integer, up_stock integer) OWNER TO postgres;

--
-- Name: update_supplier(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_supplier(supp_name character varying, supp_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE

ingid integer;

BEGIN

 UPDATE supplier

SET supplier_name=supp_name

where

supplier_id=supp_id;

END;

$$;


ALTER FUNCTION public.update_supplier(supp_name character varying, supp_id integer) OWNER TO postgres;

--
-- Name: ing_reg_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ing_reg_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ing_reg_seq OWNER TO postgres;

--
-- Name: ing_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ing_seq
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ing_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ingredient_region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredient_region (
    region_id integer NOT NULL,
    ingredient_id integer NOT NULL,
    price numeric(8,2),
    stock integer,
    ing_reg_id integer DEFAULT nextval('public.ing_reg_seq'::regclass) NOT NULL,
    supplier_id integer
);


ALTER TABLE public.ingredient_region OWNER TO postgres;

--
-- Name: ingredient_supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredient_supplier (
    ingredient_id integer NOT NULL,
    supplier_id integer NOT NULL
);


ALTER TABLE public.ingredient_supplier OWNER TO postgres;

--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredients (
    ingredient_id integer DEFAULT nextval('public.ing_seq'::regclass) NOT NULL,
    ingredient_name character varying(250)  NOT NULL,
    flag boolean DEFAULT true,
    img character varying(250),
    supplier character varying(250)
);


ALTER TABLE public.ingredients OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    "timestamp" timestamp without time zone,
    total_price numeric(8,2),
    order_id integer NOT NULL
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: order_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_detail (
    base_id integer,
    ingredient_id integer,
    order_id integer
);


ALTER TABLE public.order_detail OWNER TO postgres;

--
-- Name: COLUMN order_detail.base_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.order_detail.base_id IS 'update cascade on delete cascade';


--
-- Name: order_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_order_id_seq OWNER TO postgres;

--
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_order_id_seq OWNED BY public."order".order_id;


--
-- Name: pizza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizza (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    description character varying(4000),
    "imageSrc" character varying(250) NOT NULL,
    heat integer,
    price numeric(10,2) NOT NULL,
    discount numeric(10,2),
    currency character varying(4) NOT NULL
);


ALTER TABLE public.pizza OWNER TO postgres;

--
-- Name: pizza_base; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizza_base (
    base_id integer NOT NULL,
    base_size character varying,
    price numeric(8,2)
);


ALTER TABLE public.pizza_base OWNER TO postgres;

--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    region_id integer NOT NULL,
    region_name character varying(500)
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    supplier_id integer DEFAULT nextval('public.order_order_id_seq'::regclass) NOT NULL,
    supplier_name character varying,
    hidden boolean DEFAULT true
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- Name: supplier_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supplier_seq OWNER TO postgres;

--
-- Name: order order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN order_id SET DEFAULT nextval('public.order_order_id_seq'::regclass);


--
-- Data for Name: ingredient_region; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient_region VALUES (4, 2, 1.00, 5, 28, 22);
INSERT INTO public.ingredient_region VALUES (4, 9, 0.50, 5, 31, 1);
INSERT INTO public.ingredient_region VALUES (1, 2, 0.50, 5, 29, 28);
INSERT INTO public.ingredient_region VALUES (1, 4, 2.00, 2, 4, 1);
INSERT INTO public.ingredient_region VALUES (3, 9, 0.50, 2, 13, 22);
INSERT INTO public.ingredient_region VALUES (5, 10, 0.50, 3, 14, 23);
INSERT INTO public.ingredient_region VALUES (4, 5, 2.00, 3, 17, 22);
INSERT INTO public.ingredient_region VALUES (1, 6, 2.00, 2, 18, 28);
INSERT INTO public.ingredient_region VALUES (1, 1, 0.50, 3, 24, 26);
INSERT INTO public.ingredient_region VALUES (2, 9, 0.50, 2, 30, 1);
INSERT INTO public.ingredient_region VALUES (1, 1, 1.00, 5, 21, 22);
INSERT INTO public.ingredient_region VALUES (3, 3, 2.00, 5, 16, 23);
INSERT INTO public.ingredient_region VALUES (3, 1, 2.00, 5, 22, 23);
INSERT INTO public.ingredient_region VALUES (3, 2, 1.00, 4, 15, 26);
INSERT INTO public.ingredient_region VALUES (4, 11, 1.00, 4, 19, 23);


--
-- Data for Name: ingredient_supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient_supplier VALUES (1, 1);
INSERT INTO public.ingredient_supplier VALUES (2, 1);
INSERT INTO public.ingredient_supplier VALUES (5, 1);


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredients VALUES (6, 'Pepperoni', true);
INSERT INTO public.ingredients VALUES (5, 'Olive', true);
INSERT INTO public.ingredients VALUES (4, 'Shredded Chicken', true);
INSERT INTO public.ingredients VALUES (9, 'Maize', true);
INSERT INTO public.ingredients VALUES (10, 'Oregano', true);
INSERT INTO public.ingredients VALUES (11, 'Tuna', true);
INSERT INTO public.ingredients VALUES (1, 'Cheese', true);
INSERT INTO public.ingredients VALUES (3, 'Salami', true);
INSERT INTO public.ingredients VALUES (2, 'Mushroom', true);


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."order" VALUES ('2021-01-28 11:46:51.315331', 7.50, 21);
INSERT INTO public."order" VALUES ('2021-02-05 15:55:53.72285', 5.50, 25);
INSERT INTO public."order" VALUES ('2021-02-07 11:13:21.086614', 12.00, 27);
INSERT INTO public."order" VALUES ('2021-02-10 10:45:35.042583', 11.00, 29);
INSERT INTO public."order" VALUES ('2021-02-10 10:46:51.126637', 11.00, 30);


--
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_detail VALUES (3, 13, 25);
INSERT INTO public.order_detail VALUES (3, 15, 27);
INSERT INTO public.order_detail VALUES (3, 18, 27);
INSERT INTO public.order_detail VALUES (3, 19, 27);
INSERT INTO public.order_detail VALUES (3, 21, 27);
INSERT INTO public.order_detail VALUES (3, 4, 29);
INSERT INTO public.order_detail VALUES (3, 13, 29);
INSERT INTO public.order_detail VALUES (3, 14, 29);
INSERT INTO public.order_detail VALUES (3, 17, 29);
INSERT INTO public.order_detail VALUES (3, 18, 29);
INSERT INTO public.order_detail VALUES (3, 24, 29);
INSERT INTO public.order_detail VALUES (3, 30, 29);
INSERT INTO public.order_detail VALUES (3, 4, 30);
INSERT INTO public.order_detail VALUES (3, 13, 30);
INSERT INTO public.order_detail VALUES (3, 14, 30);
INSERT INTO public.order_detail VALUES (3, 17, 30);
INSERT INTO public.order_detail VALUES (3, 18, 30);
INSERT INTO public.order_detail VALUES (3, 24, 30);
INSERT INTO public.order_detail VALUES (3, 30, 30);
INSERT INTO public.order_detail VALUES (3, 4, 21);


--
-- Data for Name: pizza_base; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pizza_base VALUES (1, '24 cm', 2.00);
INSERT INTO public.pizza_base VALUES (2, '27 cm', 2.50);
INSERT INTO public.pizza_base VALUES (3, '28 cm', 3.00);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.region VALUES (1, 'Germany');
INSERT INTO public.region VALUES (2, 'Italy');
INSERT INTO public.region VALUES (3, 'France');
INSERT INTO public.region VALUES (4, 'Spain');
INSERT INTO public.region VALUES (5, 'Denmark');


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.supplier VALUES (22, 'Foods Home', true);
INSERT INTO public.supplier VALUES (1, 'Organic Food', true);
INSERT INTO public.supplier VALUES (26, 'Penny', true);
INSERT INTO public.supplier VALUES (23, 'Edeka', true);
INSERT INTO public.supplier VALUES (28, 'GoodFood', true);


--
-- Name: ing_reg_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ing_reg_seq', 31, true);


--
-- Name: ing_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ing_seq', 14, true);


--
-- Name: order_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_order_id_seq', 30, true);


--
-- Name: supplier_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplier_seq', 3, false);


--
-- Name: ingredient_region ing_reg_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_region
    ADD CONSTRAINT ing_reg_pk PRIMARY KEY (ing_reg_id);


--
-- Name: ingredient_supplier ingredient_supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_supplier
    ADD CONSTRAINT ingredient_supplier_pkey PRIMARY KEY (ingredient_id, supplier_id);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (ingredient_id);


--
-- Name: order order_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pk PRIMARY KEY (order_id);


--
-- Name: pizza_base pizza_base_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza_base
    ADD CONSTRAINT pizza_base_pkey PRIMARY KEY (base_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplier_id);


--
-- Name: ingredient_region ingredient_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_region
    ADD CONSTRAINT ingredient_fk FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(ingredient_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_detail ingredient_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT ingredient_fk FOREIGN KEY (ingredient_id) REFERENCES public.ingredient_region(ing_reg_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ingredient_supplier ingredient_supplier_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_supplier
    ADD CONSTRAINT ingredient_supplier_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(ingredient_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ingredient_supplier ingredient_supplier_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_supplier
    ADD CONSTRAINT ingredient_supplier_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_detail order_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_fk FOREIGN KEY (order_id) REFERENCES public."order"(order_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_detail orders_base_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT orders_base_id_fkey FOREIGN KEY (base_id) REFERENCES public.pizza_base(base_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ingredient_region region_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_region
    ADD CONSTRAINT region_fk FOREIGN KEY (region_id) REFERENCES public.region(region_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ingredient_region supplier_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_region
    ADD CONSTRAINT supplier_fk FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

