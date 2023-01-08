-- Знаходження загальної суми капіталу компаній однієї країни
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
