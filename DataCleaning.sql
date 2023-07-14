--Cleaning Data in SQL Queries
select * from Data_cleaning..hd

 --------------------------------------------------------------------------------------------------------------------------



-- Standardize Date Format
alter table hd
add sale_date date;
update Data_cleaning..hd
set sale_date= convert(date,SaleDate)

-- deleting column, saledate

alter table hd
drop column saledate;

 --------------------------------------------------------------------------------------------------------------------------


-- Populate Property Address data
update a
set  a.PropertyAddress= b.PropertyAddress
from Data_cleaning ..hd a join Data_cleaning.. hd b on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ] 
where a.PropertyAddress is null



 --------------------------------------------------------------------------------------------------------------------------



--Separating the PropertyAddress Column Into City and House Address

alter table hd
add houseAddress varchar(255), city varchar(255)

update hd
set houseAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1),
city =SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) 
from hd

 --------------------------------------------------------------------------------------------------------------------------



 -- spiliting owner address into ownercity. ownerstate, owner country
alter table hd
add ownerAdd nvarchar(255)
alter table hd
add ownerState nvarchar(255),owner_country nvarchar(255)

update hd 
set ownerAdd = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
 OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
 Owner_country = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 from hd

 --------------------------------------------------------------------------------------------------------------------------



 -- changing Y and N to Yes and No in soldasvacant column  
 update hd
set SoldAsVacant = Case when SoldAsVacant='N' then 'No'
                           when SoldAsVacant='Y' then 'Yes'
						   else SoldAsVacant
						   end 
from hd where SoldAsVacant='N' or SoldAsVacant='Y'

 --------------------------------------------------------------------------------------------------------------------------
