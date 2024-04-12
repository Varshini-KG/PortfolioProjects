-- Cleaning the data

SELECT * 
FROM PortfolioProject.dbo.Housing

-- Changing the Date format

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM PortfolioProject.dbo.Housing

UPDATE PortfolioProject.dbo.Housing
SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE PortfolioProject.dbo.Housing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.Housing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate Property Address data

SELECT *
FROM PortfolioProject.dbo.Housing
-- WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Housing a
JOIN PortfolioProject.dbo.Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Housing a
JOIN PortfolioProject.dbo.Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Breaking out Address into Individual columns (address, city, state)

SELECT PropertyAddress
FROM PortfolioProject.dbo.Housing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject.dbo.Housing

ALTER TABLE PortfolioProject.dbo.Housing
Add PropertySplitAddress NVARCHAR(255);

Update PortfolioProject.dbo.Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.Housing
Add PropertySplitCity NVARCHAR(255);

Update PortfolioProject.dbo.Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) 


SELECT*
FROM PortfolioProject.dbo.Housing


SELECT OwnerAddress
FROM PortfolioProject.dbo.Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.Housing


ALTER TABLE PortfolioProject.dbo.Housing
Add OwnerSplitAddress NVARCHAR(255);

Update PortfolioProject.dbo.Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject.dbo.Housing
Add OwnerSplitCity NVARCHAR(255);

Update PortfolioProject.dbo.Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortfolioProject.dbo.Housing
Add OwnerSplitState NVARCHAR(255);

Update PortfolioProject.dbo.Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject.dbo.Housing

--Changing Y and N to Yes and No in Sold as Vacant column

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.Housing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,CASE when SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject.dbo.Housing

UPDATE PortfolioProject.dbo.Housing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

--REMOVING DUPLICATES
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					)row_num
FROM PortfolioProject.dbo.Housing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num >1
--ORDER BY ParcelID

--DELETE UNUSED COLUMNS

SELECT *
FROM PortfolioProject.dbo.Housing

ALTER TABLE PortfolioProject.dbo.Housing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress