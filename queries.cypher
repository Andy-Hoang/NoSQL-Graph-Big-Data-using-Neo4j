// -----------------1. A Simple Use Case: List books that have the keyword "database" in title -----------------
MATCH (b:BOOK)
WHERE b.Title =~'.*(?i)database.*'
RETURN b 

// -----------------2. A Moderately Complex Use Case: List the books that the student named Henry has borrowed-----------------
MATCH (:aUSER {FName:"Henry"})-->(:LOAN)<--(b:BOOK)
RETURN distinct b.Title AS BookTitle
 

// -----------------3. A Complex Use Case: List the first name and last surname of the students and the number of books they read-----------------
MATCH (u:aUSER)-->(:LOAN)<--(b:BOOK)
RETURN u.FName as FirstName, u.LName as LastName, count(distinct b) as NumberofBooks
Order by NumberofBooks desc


//----------------- EXTRA -----------------

//.1.	List all users who are students
match(n:aUSER) where n.Student = "1" return n  

//.2.	List all staff of the system and their roles
MATCH (u:aUSER),(r:aROLE) WHERE u.RoleID = r.RoleID and u.Staff = "1"  
return u, r  

//.3.	List all books which are available at Casuarina campus
match(n:BOOK) where n.BID = "Cas01" and n.Availability ="1"  

//.4.	List all books of publisher named Pearson AU and are available at Casuarina campus
match(n:BOOK),(m:PUBLISHER)   
where n.BID = "Cas01" and n.Availability ="1" and n.PID = m.PID and m.P_Name ="Pearson AU"
return n,m  

//.5.	List all lecturers who have borrowed books and its names
match(n:aUser),(m:aRole),(l:LOAN),(d:LOANDETAIL),(b:BOOK)   
where n.RoleID = m.RoleID and m.RoleName = "Tutor" and n.UserID = l.UserID  
and l.LoanID = d.LoanID and d.BOOKID = b.BOOKID  
return n,b  

//-------Graph Similarity Algorithm--------
MATCH(u1:aUSER{FName:"Henry"})-->(:LOAN)<--(b1:BOOK)  
WITH u1, COLLECT(DISTINCT id(b1)) AS u1BOOK  
MATCH (u2:aUSER)-->(:LOAN)<--(b2:BOOK) WHERE u1 <> u2  
WITH u1, u1BOOK, u2, COLLECT(DISTINCT id(b2)) AS u2BOOK  
RETURN u1.FName AS From,  
        u2.FName AS To,  
        gds.alpha.similarity.jaccard(u1BOOK,u2BOOK) AS jaccard   
ORDER BY jaccard DESC 
