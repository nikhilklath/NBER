clear all
import excel "C:\Users\nikhi\Desktop\NBER Networks\NBER_detailed.xlsx", sheet("Sheet1") firstrow

split papermonth, p(" ")
destring papermonth2, replace 
rename papermonth2 year
drop if year > 2020
drop if year < 1981
duplicates drop paper, force
di _N

drop papertopic* paperprogram* papergroup* paperproject* authorposition*
reshape long author authoraffiliation, i(paper) j(count)
drop if mi(author)
sort year
bys paper: gen num_authors = _N

preserve
duplicates drop paper, force
hist num_authors
sum num_authors, d
restore