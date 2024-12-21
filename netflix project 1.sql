
CREATE TABLE netflix
(
    show_id      VARCHAR(6),
    type         VARCHAR(10),
    title        VARCHAR(150),
    director     VARCHAR(208),
	casts       varchar(1000),
    country      VARCHAR(150),
    date_added   VARCHAR(50),
    release_year INT,
    rating       VARCHAR(10),
    duration     VARCHAR(15),
    listed_in    VARCHAR(25),
    description  VARCHAR(250)
);
select * from netflix;

select 
     count(*) as total_content
from netflix;
select 
     distinct type
from netflix;

--  15 business problems
1. Count the Number of Movies vs TV Shows

 select 
     type,
	 count(*) as total_content
from netflix
group by type

2. Find the Most Common Rating for Movies and TV Shows

select
     type,
	 rating
from	 
(
   select 
     type,
	 rating,
	 count(*),
	 rank() over(partition by type order by count (*) desc) as ranking
   from netflix
   group by 1,2
) as t1
where
     ranking = 1
	 
3. List All Movies Released in a Specific Year (e.g., 2020)

-- filter 2020 
-- movies

select * from netflix
where 
     type = ' Movie'
     and 
	 release_year = 2020


4. Find the Top 5 Countries with the Most Content on Netflix

select 
     unnest(string_to_array(country,',')) as new_country,
	 count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5
 




5.Identify the Longest Movie

select * from netflix
where
    type  = 'Movie'
    and
    duration = (select max(duration) from netflix)


6. Find Content Added in the Last 5 Years

select
     *
from netflix
where 
    to_date(date_added, 'Month DD,YYYY')  >= CURRENT_DATE - interval '5 years'

select current_date - interval '5 years'	

7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select * from netflix
where director Ilike '%Rajiv Chilaka%'

8. List All TV Shows with More Than 5 Seasons

select
     *
from netflix
where
     type = ' tv shows'
	 and
	 split_part(duration, ' ', 1) ::numeric > 5


9. Count the Number of Content Items in Each Genre

select 
     unnest(string_to_array(listed_in, ',')) as genre,
	 count(show_id) as total_content
from netflix	  
group by 1

10.Find each year and the average numbers of content release in India on netflix.
return top 5 years with highest avg content release:

--total content 333/972

select 
      extract(year from  to_date(date_added, 'Month DD YYYY')) as year,
	  count(*) as yearly_content,
	  round(
	  count(*)::numeric/(select count(*) from netflix where country ='india')::numeric * 100
	  ,2)as avg_content_per_year
from netflix 	  
where country = 'india'
group by 1


11. List All Movies that are Documentaries

select * from netflix
where
     listed_in Ilike '%documentaries'
	 

12. Find All Content Without a Director

select * from netflix
where
     director is null
	 
13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

select * from netflix
where 
    casts Ilike '%salman khan%'
	and
	release_year > extract(year from current_date) - 10

	
14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select 
--show_id,
--casts,
unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country Ilike '%india'
group by 1
order by 2 desc
limit 10

15.categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.label content containing these keywords as 'bad' and all other content as 'good'
.count how many items fall into each category.

with new_table
as
(

select
*, 
   case
   when 
       description Ilike '%kill%' or
       description Ilike '%violence%' then 'bad_content'
	   else 'good content'
   end category
from netflix  
)
select
      category,
	  count(*) as total_content
from new_table
group by 1



where 
    description Ilike '%kill%'
	or 
	description Ilike '%violence%'






