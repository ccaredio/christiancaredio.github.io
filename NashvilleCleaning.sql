-- Written By: Christian Caredio
-- Date: 02/14/2022
-- Purpose: This project is to practice and showcase my data cleaning skills using Microsoft SQL Server using housing data from Nashville.

/*

Cleaning the data using SQL Queries

*/

SELECT 
	*
FROM 
	PortfolioProject..NashvilleHousing


-- Standardize Date Format

ALTER TABLE PortfolioProject..NashvilleHousing
Add SaleDateConverted Date; 

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT 
	SaleDateConverted
FROM 
	PortfolioProject..NashvilleHousing


-- Populate Property Address Data

SELECT 
	*
FROM 
	PortfolioProject..NashvilleHousing
--WHERE
	--PropertyAddress is Null
ORDER BY
	ParcelID

SELECT 
	a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
	PortfolioProject..NashvilleHousing as a
JOIN PortfolioProject..NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE 
	a.PropertyAddress is null

UPDATE 
	a
SET
	PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
	PortfolioProject..NashvilleHousing as a
JOIN PortfolioProject..NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE 
	a.PropertyAddress is null

-- Break the Addresses into Individual Columns (Address, City, State)

SELECT 
	PropertyAddress
FROM 
	PortfolioProject..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM 
	PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255); 

Update PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255); 

Update PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


SELECT 
	*
FROM 
	PortfolioProject..NashvilleHousing


SELECT 
	OwnerAddress
FROM 
	PortfolioProject..NashvilleHousing

SELECT 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM 
	PortfolioProject..NashvilleHousing




ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255); 

Update PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255); 

Update PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255); 

Update PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



-- Change the Y and N to Yes and No in "Sold as Vacant" field

SELECT
	DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM
	PortfolioProject..NashvilleHousing
GROUP BY 
	SoldAsVacant
ORDER BY
	2

SELECT 
	SoldAsVacant, 
CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END
FROM
	PortfolioProject..NashvilleHousing


Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END


-- Remove Duplicates

WITH RowNumCTE AS(

SELECT 
	*,
	ROW_NUMBER() OVER (
	PARTITION BY
	ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
		UniqueID
		) row_num
FROM 
	PortfolioProject..NashvilleHousing
)

DELETE
FROM
	RowNumCTE
WHERE
	row_num > 1



-- Delete Unused Columns

Select
	*
FROM
	PortfolioProject..NashvilleHousing

ALTER TABLE
	PortfolioProject..NashvilleHousing
DROP COLUMN
	OwnerAddress, TaxDistrict, PropertyAddress, SaleDate