-- Додає нову компанію в таблицю
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


