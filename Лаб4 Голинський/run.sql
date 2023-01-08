-- ФУНКЦІЯ (Знаходження загальної суми капіталу компаній однієї країни)

DROP FUNCTION IF EXISTS country_com_valuation;

CREATE OR REPLACE FUNCTION country_com_valuation(name_country char(50))
RETURNS INTEGER
LANGUAGE 'plpgsql'

AS $$
   BEGIN
      RETURN (SELECT SUM(CAST(SUBSTRING(com_valuation, 2, 10) AS INT))
              FROM Place, Company
              WHERE place.place_id = company.place_id 
              AND place_country = name_country);
   END;
$$

SELECT * FROM company
SELECT country_com_valuation('Ukraine')
SELECT country_com_valuation('United States')



-- ПРОЦЕДУРА (Додає нову компанію в таблицю)

DROP PROCEDURE add_new_company;

CREATE OR REPLACE PROCEDURE add_new_company(c_name char(100), c_valuation char(10), p_id int, i_id int)

LANGUAGE'plpgsql'
AS $$
   DECLARE 
      c_id company.com_id%type;
      c_joined company.com_joined%type := NULL;

   BEGIN
      SELECT (com_id+1) INTO c_id FROM company ORDER BY com_id DESC LIMIT 1;
      INSERT INTO company(com_id, com_name, com_valuation, com_joined, place_id, ind_id)
      VALUES(c_id, c_name, c_valuation, c_joined, p_id, i_id);
   END;
$$

CALL add_new_company('My new company', '$999', 0, 0)
SELECT * FROM company


-- ТРІГЕР (Додає дату додавання компанії)

DROP TRIGGER IF EXISTS added_new_company ON company;
DROP FUNCTION IF EXISTS set_data CASCADE;

CREATE FUNCTION set_data() RETURNS TRIGGER
LANGUAGE 'plpgsql'
AS
$$
   BEGIN 
      UPDATE Company
      SET
		   com_joined = now()
      WHERE 
         company.com_id = NEW.com_id;
      RETURN NULL;
   END;
$$;

CREATE TRIGGER add_new_company
AFTER INSERT ON company
FOR EACH ROW EXECUTE FUNCTION set_data();


CALL add_new_company('My best company', '$500', 1, 2)
SELECT * FROM company



