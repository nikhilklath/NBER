clear all
import excel "C:\Users\nik596\Documents\GitHub\NBER\NBER_WP.xlsx", sheet("Sheet1") firstrow

split papermonth, p(" ")
destring papermonth2, replace 
rename papermonth2 year
rename papermonth1 month
drop if year > 2021
drop if year < 1981
duplicates drop paper, force
di _N

drop papertopic* paperprogram* papergroup* paperproject* authoraddress* A
tostring authorposition*, replace
reshape long author authoraffiliation authorlink authorposition, i(paper) j(count)
drop if mi(author)
sort year
bys paper: gen num_authors = _N

preserve
duplicates drop paper, force
hist num_authors
sum num_authors, d
restore

export delimited using "C:\Users\nik596\Documents\GitHub\NBER\NBER_WP_long.csv", replace