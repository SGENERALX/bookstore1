DROP PROCEDURE IF EXISTS get_books;

DELIMITER //

create procedure get_books(IN type varchar(20), IN lefttable varchar(15),IN jointable varchar(20), IN jointype varchar(10),IN onleft varchar(10), IN onright varchar(20),IN tocompare varchar(20), IN wherequery varchar(20))

BEGIN
	SET @fromjoin = lefttable;
	SET @tojoin = jointable;
	SET @jointype = jointype;
	SET @onleft = onleft;
	SET @onright = onright;
	SET @wherequery = wherequery;
	SET @type = type;
	SET @tocompare = tocompare;
	
	CASE @type
		when 'all' then
			SET @select = 'books.Title, books.Category_id, category.name';
			SET @tocompare = '';
			SET @wherequery = '';
		when 'popular' then
			SET @select = 'books.ISBN, Title, Authors, Publisher, DATE_FORMAT(YOP, "%Y-%m-%d") as YOP, Available_copies, Price, Format, Keywords, Subject, image_loc, Category_id';
			SET @tocompare = concat('where ', @tojoin,'.ISBN = ', @fromjoin, '.ISBN');
			SET @wherequery = '';
		when 'bycategory' then 
			SET @select = 'ISBN, Title, Authors, Publisher, DATE_FORMAT(YOP, "%Y-%m-%d") as YOP, Available_copies, Price, Format, Keywords, Subject, image_loc, cc.name as childcategory';
			SET @tocompare = conact('where ', @tojoin, '.cat_id = ', @fromjoin, '.Category_id');
		END CASE;

	SET @sql_stmt = concat('select ', @select, ' from books ', @jointype, ' join ', @tojoin, ' on ', @tocompare, @wherequery);

	SELECT @sql_stmt AS ReturnQuery;

END //



-- SELECT @sql_stmt AS ReturnQuery;
--	EXEC (@sql_stmt);

-- if type = 'all' then 
-- SET @select = "books.Title, books.Category_id, category.name";

-- "select books.title ,books.Category_id, category.name from books left join category on books.Category_id = category.cat_id;"
-- "select books.ISBN as ISBN, title, Authors, publishe]r, DATE_FORMAT(YOP,'%Y-%m-%d') as YOP, Available_copies, Price, Format, Keywords, Subject, image_loc, Category_id"
--                      "from books"
--                      " left join rating"
--                      " on rating.ISBN = books.ISBN"
--                      " where rating.score <={} and rating.score> {};"

-- "select book.ISBN as ISBN, title, Authors, Publisher, DATE_FORMAT(YOP,'%Y-%m-%d') as YOP, Available_copies, Price, Format, Keywords, Subject, image_loc, cc.name as childcategory "
--                     "from books"
--                     " inner join category cc "
--                     "on cc.cat_id = books.Category_id "
--                     "where cc.parent={} or Category_id = {};"
