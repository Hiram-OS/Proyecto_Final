-- Views --

--------------------------------------------- Vista de doctores a nivel Provincia ----------------------------------------

--- Creación ---
create view number_of_doctors_province as(
with number_of_doctors as (
	select id_hospital as id, country as countrys, province as provinces 
	from hospital h
	order by country asc
), sec as(
	select s.amount_of_doctors_in_hospital as num_doctors,
	lower(nb.countrys) as country, lower(nb.provinces) as province, nb.id as id_hosp,
	s.last_update - extract(day from s.last_update)*'1 day'::interval + '1 day'::interval as star_date_month, 
	s.last_update - extract(day from s.last_update)*'1 day'::interval + '1 day'::interval + 30*'1 day':: interval as month_end_date,
	extract(month from s.last_update)
	from number_of_doctors nb
	join staff s on (nb.id = s.id_hospital)
	window w as (partition by extract(month from s.last_update), lower(nb.provinces) order by nb.provinces)
	order by nb.countrys asc
)
	select sum(s.num_doctors) as number_of_doctors, upper(s.country) as COUNTRY, upper(s.province) as PROVINCE,
	s.star_date_month, s.month_end_date
	from sec s
	group by s.country, s.province, s.star_date_month, s.month_end_date
	order by s.country);

--- Selección ---
select * from number_of_doctors_province;

--- Drop de la view ---  
drop view number_of_doctors_province;

----------------------------------------------- Vista de doctores a nivel Provincia -------------------------------------

--- Creación ---
create view number_of_doctors_hospital as(
with number_of_doctors as (
	select id_hospital as id, country as countrys, province as provinces, name_hospital as hospitals
	from hospital h
	order by country asc
), sec as(
	select s.amount_of_doctors_in_hospital as num_doctors,
	lower(nb.countrys) as country, lower(nb.provinces) as province, lower(nb.hospitals) as hospital, nb.id as id_hosp,
	s.last_update - extract(day from s.last_update)*'1 day'::interval + '1 day'::interval as star_date_month, 
	s.last_update - extract(day from s.last_update)*'1 day'::interval + '1 day'::interval + 30*'1 day':: interval as month_end_date,
	extract(month from s.last_update)
	from number_of_doctors nb
	join staff s on (nb.id = s.id_hospital)
	window w as (partition by extract(month from s.last_update), lower(nb.provinces) order by nb.provinces)
	order by nb.countrys asc
)
	select sum(s.num_doctors) as number_of_doctors, upper(s.hospital) as HOSPITAL, upper(s.province) as PROVINCE,
	upper(s.country) as COUNTRY, s.star_date_month, s.month_end_date
	from sec s
	group by s.hospital, s.country, s.province, s.star_date_month, s.month_end_date
	order by s.country);

--- Selección ---
select * from number_of_doctors_hospital;

--- Drop de la view ---  
drop view number_of_doctors_hospital;

--------------------------------------------------- Inventarios a nivel país -------------------------------------------

--- Creación de vista ---
create view media_inventario_pais as
	select upper(h.country) as Country, round(avg(i.oxygen),2) as oxygen, round(avg(i.antypiretic),2) as antypirectic, 
	round(avg(i.anesthesia), 2) as anesthesia, round(avg(i.soap_alcohol_solution), 2) as soap_alcohol_solution,
	round(avg(i.disposable_masks), 2) as disposable_mask, round(avg(i.disposable_gloves), 2) as disposable_gloves, 
	round(avg(i.disposable_hats), 2) as disposable_hats, round(avg(i.disposable_aprons), 2) as disposable_aprons,
	round(avg(i.surgical_gloves), 2) as surgical_gloves, round(avg(i.shoe_covers), 2) as shoe_covers, 
	round(avg(i.visors), 2) as visors, round(avg(i.covid_test_kits), 2) as covid_test_kits,
	h.last_update as ultima_actualizacion
	from hospital h
    join inventory i using (id_hospital)
    group by upper(h.country) , ultima_actualizacion order by upper(h.country)

--- Selección de la vista ---
select * from media_inventario_pais;

--- Drop de la vista ---
drop view media_inventario_pais;


--------------------------------------------------- Inventarios a nivel Provincia -------------------------------------------

--- Creación de vista ---
create view media_inventario_province as
	select upper(h.country) as country, upper(h.province) as province, round(avg(i.oxygen),2) as oxygen, 
	round(avg(i.antypiretic),2) as antypirectic, 
	round(avg(i.anesthesia), 2) as anesthesia, round(avg(i.soap_alcohol_solution), 2) as soap_alcohol_solution,
	round(avg(i.disposable_masks), 2) as disposable_mask, round(avg(i.disposable_gloves), 2) as disposable_gloves, 
	round(avg(i.disposable_hats), 2) as disposable_hats, round(avg(i.disposable_aprons), 2) as disposable_aprons,
	round(avg(i.surgical_gloves), 2) as surgical_gloves, round(avg(i.shoe_covers), 2) as shoe_covers, 
	round(avg(i.visors), 2) as visors, round(avg(i.covid_test_kits), 2) as covid_test_kits,
	h.last_update as ultima_actualizacion
	from hospital h
    join inventory i using (id_hospital)
    group by upper(h.country), upper(h.province), ultima_actualizacion order by upper(h.country)

--- Selección de la vista ---
select * from media_inventario_province;

--- Drop de la vista ---
drop view media_inventario_province;


--------------------------------------------------- Staff a nivel Provincia -------------------------------------------

--- Creación de vista ---
create view number_of_staff_province as (
with number_of_staff as (
	select id_hospital as id, country as countrys, province as provinces from hospital h
	order by country asc
), sec as(
	select s.amount_of_paramedical_staff_in_hospital as num_medic_staff, lower(ns.countrys) as country, 
	ns.id as id_hosp, lower(ns.provinces) as province,
	s.last_update - extract(day from s.last_update)*'1 day'::interval + '1 day'::interval as star_date_month, 
	s.last_update - extract(day from s.last_update)*'1 day'::interval + '1 day'::interval + 30*'1 day':: interval as month_end_date,
	extract(month from s.last_update)
	from number_of_staff ns
	join staff s on (ns.id = s.id_hospital)
	window w as (partition by extract(month from s.last_update), lower(ns.countrys) order by ns.countrys)
	order by ns.countrys asc
)
	select sum(s.num_medic_staff) as number_of_staff_medical, upper(s.country) as country, 
	upper(s.province) as province, s.star_date_month, s.month_end_date
	from sec s
	group by s.country, s.province, s.star_date_month, s.month_end_date
	order by s.country);

--- Selección de la vista ---
select * from number_of_staff_province;

--- Drop de la vista ---
drop view number_of_staff_province;

--------------------------------------------------- Staff a nivel Hospital -------------------------------------------

--- Creación de vista ---
create view number_of_staff_hospital as (
	select s.amount_of_paramedical_staff_in_hospital, h.name_hospital, h.country , h.province,
	s.last_update - extract(day from s.last_update)*'1 day'::interval + '1 day'::interval as star_date_month, 
	s.last_update - extract(day from s.last_update)*'1 day'::interval + '1 day'::interval + 30*'1 day':: interval as month_end_date,
	extract(month from s.last_update)
	from hospital h
	join staff s on (s.id_hospital = h.id_hospital)
	order by h.country);

--- Selección de la vista ---
select * from number_of_staff_hospital;

--- Drop de la vista ---
drop view number_of_staff_hospital;



