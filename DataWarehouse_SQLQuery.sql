create table ASM2_Staging
(PetID int, 
TypeID int, Type varchar(3), 
Age int, 
Breed1ID int, Breed1 varchar(255), 
Breed2ID int, Breed2 varchar(255),
GenderID int, Gender varchar(6), 
Color1ID int, Color1 varchar(255), 
Color2ID int, Color2 varchar(255), 
Color3ID int, Color3 varchar(255), 
MaturitySizeID int, MaturitySize varchar(13), 
FurLengthID int, FurLength varchar(13), 
VaccinatedID int, Vaccinated varchar(8), 
DewormedID int, Dewormed varchar(8),
SterilizedID int, Sterilized varchar(8), 
Health varchar(14), 
Quantity int, 
Fee int, 
StateID int, State varchar(255), 
RescuerID int);


create table Type_DIM
(TypeID int identity(1,1), Type varchar(3));

create table Breed1_DIM
(Breed1ID int identity(1,1), Breed1 varchar(255));

create table Breed2_DIM
(Breed2ID int identity(1,1), Breed2 varchar(255));

create table Gender_DIM
(GenderID int identity(1,1), Gender varchar(6));

create table Color1_DIM
(Color1ID int identity(1,1), Color1 varchar(255));

create table Color2_DIM
(Color2ID int identity(1,1), Color2 varchar(255));

create table Color3_DIM
(Color3ID int identity(1,1), Color3 varchar(255));

create table MaturitySize_DIM
(MaturitySizeID int identity(1,1), MaturitySize varchar(13));

create table FurLength_DIM
(FurLengthID int identity(1,1), FurLength varchar(13));

create table Vaccinated_DIM
(VaccinatedID int identity(1,1), Vaccinated varchar(8));

create table Dewormed_DIM
(DewormedID int identity(1,1), Dewormed varchar(8));

create table Sterilized_DIM
(SterilizedID int identity(1,1), Sterilized varchar(8));

create table State_DIM
(StateID int identity(1,1), State varchar(255));


create table ASM2_FACT
(PetID int, 
TypeID int, 
Age int, 
Breed1ID int, 
Breed2ID int,
GenderID int, 
Color1ID int, 
Color2ID int, 
Color3ID int, 
MaturitySizeID int, 
FurLengthID int, 
VaccinatedID int, 
DewormedID int,
SterilizedID int, 
Health varchar(14), 
Quantity int, 
Fee int, 
StateID int, 
RescuerID int);



select * from ASM2_Staging;
select * from ASM2_FACT;

select * from Type_DIM;
select * from Breed1_DIM;
select * from Breed2_DIM;
select * from Gender_DIM;
select * from Color1_DIM;
select * from Color2_DIM;
select * from Color3_DIM;
select * from MaturitySize_DIM;
select * from FurLength_DIM;
select * from Vaccinated_DIM;
select * from Dewormed_DIM;
select * from Sterilized_DIM;
select * from State_DIM;


select sum (case when F.GenderID='1' then F.Quantity else null end) as TotalMixed,
       sum (case when F.GenderID='2' then F.Quantity else null end) as TotalMale,
	   sum (case when F.GenderID='3' then F.Quantity else null end) as TotalFemale,
	   sum(F.Quantity) as TotalQuantity,
	   cast((sum (case when F.GenderID='1' then F.Quantity else null end)*1.0/sum(F.Quantity)*1.0) as decimal(10,3)) as PercentageOfMixed,
	   cast((sum (case when F.GenderID='2' then F.Quantity else null end)*1.0/sum(F.Quantity)*1.0) as decimal(10,3)) as PercentageOfMale,
	   cast((sum (case when F.GenderID='3' then F.Quantity else null end)*1.0/sum(F.Quantity)*1.0) as decimal(10,3)) as PercentageOfFemale
	   from ASM2_FACT F;
	   


select sum(F.Quantity) as Result
       from ASM2_FACT F where F.VaccinatedID=2 and F.DewormedID=2 and F.SterilizedID=2; 


select T.Type, C.Color1,
       sum(F.quantity) as Result from ASM2_FACT F join Type_DIM T on F.TypeID=T.TypeID 
	                                              join Color1_DIM C on F.Color1ID=C.Color1ID
	  group by T.Type, C.Color1; 



select max(F.age) as MaxAge, min(F.age) as MinAge from ASM2_FACT F where F.TypeID=2;


select sum(case when F.Age=255 then F.quantity else null end) as QuantityOfMaxAge,
	   sum(case when F.Age=0 then F.quantity else null end) as QuantityOfMinAge,
	   sum(F.quantity) as TotalQuantity,
	   cast((sum(case when F.Age=255 then F.quantity else null end)*1.0)/(sum(F.quantity)*1.0) as decimal(10,5))
	       as PercentageOfMaxAge,
	   cast((sum(case when F.Age=0 then F.quantity else null end)*1.0)/(sum(F.quantity)*1.0) as decimal(10,5)) 
	       as PercentageOfMinAge
from ASM2_FACT F where F.TypeID=2;
