-- Додає дату додавання компанії

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