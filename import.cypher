//-----------------------Load csv files (tables) to Neo4j-----------------------

	LOAD CSV WITH HEADERS FROM "file:///AUTHOR.csv" AS row
CREATE (a:AUTHOR)
SET a = row;
	
	LOAD CSV WITH HEADERS FROM "file:///BOOK.csv" AS row
CREATE (a:BOOK)
SET a = row;
	
	LOAD CSV WITH HEADERS FROM "file:///BRANCH.csv" AS row
CREATE (a:BRANCH)
SET a = row;
	
	LOAD CSV WITH HEADERS FROM "file:///CARD.csv" AS row
CREATE (a:CARD)
SET a = row;
	
	LOAD CSV WITH HEADERS FROM "file:///LOAN.csv" AS row
CREATE (a:LOAN)
SET a = row;

	
	LOAD CSV WITH HEADERS FROM "file:///MATERIAL.csv" AS row
CREATE (a:MATERIAL)
SET a = row;
	
	LOAD CSV WITH HEADERS FROM "file:///PUBLISHER.csv" AS row
CREATE (a:PUBLISHER)
SET a = row;
	
	LOAD CSV WITH HEADERS FROM "file:///ROLE.csv" AS row
CREATE (a:aROLE)   
SET a = row;
//lable name for ROLE table: aROLE (because Role is a function)
	
	LOAD CSV WITH HEADERS FROM "file:///USER.csv" AS row
CREATE (a:aUSER)  
SET a = row;
	//lable name for USER table: aUSER (because User is a function)

//-----------------------End Load csv files (tables) to Neo4j-----------------------


	
//-----------------------Create Indexes-----------------------
	
	CREATE INDEX ON :AUTHOR(AID);
	
	CREATE INDEX ON :BOOK(BOOKID);
	
	CREATE INDEX ON :BRANCH(BID);
	
	CREATE INDEX ON :CARD(CID);
	
	CREATE INDEX ON :LOAN(LoanID);
	
	CREATE INDEX ON :MATERIAL(MID);
	
	CREATE INDEX ON :PUBLISHER(PID);
	
	CREATE INDEX ON :aROLE(RoleID);
	
	CREATE INDEX ON :aUSER(UserID);

//-----------------------End Create Indexes-----------------------



//-----------------------Create Relationships-----------------------

//BOOK_AUTHOR (weak entity in EER)
	LOAD CSV WITH HEADERS FROM "file:///BOOK_AUTHOR.csv" AS row
MATCH (b:BOOK), (a:AUTHOR)
WHERE b.BOOKID = row.BOOKID AND a.AID = row.AUTHORID
CREATE (b)-[details:BOOK_AUTHOR]->(a)
SET details = row;

//LOAN_DETAIL (weak entity in EER)
	LOAD CSV WITH HEADERS FROM "file:///LOANDETAIL.csv" AS row
MATCH (b:BOOK), (l:LOAN)
WHERE b.BOOKID = row.BOOKID AND l.LoanID = row.LoanID
CREATE (b)-[details:LOAN_DETAIL]->(l)
SET details = row;

//aUSER-LOAN
	MATCH (u:aUSER),(l:LOAN)
WHERE u.UserID = l.UserID
CREATE (u)-[:has]->(l);

//aUSER-CARD
MATCH (u:aUSER),(c:CARD)
WHERE u.UserID = c.UserID
CREATE (u)-[:has]->(c);

//aUSER-aROLE
MATCH (u:aUSER),(r:aROLE)
WHERE u.RoleID = r.RoleID
CREATE (u)-[:has]->(r);

//BOOK - BRANCH
MATCH (b:BOOK),(br:BRANCH)
WHERE b.BID = br.BID 
CREATE (b)-[: belong_to]->(br);

//BOOK - MATERIAL
MATCH (b:BOOK),(m:MATERIAL)
WHERE b.MID = m.MID 
CREATE (b)-[:belong_to]->(m);

//BOOK - PUBLISHER
MATCH (b:BOOK),(p:PUBLISHER)
WHERE b.PID = p.PID 
CREATE (b)<-[:publish]-(p);

//-----------------------End Create Relationships-----------------------
