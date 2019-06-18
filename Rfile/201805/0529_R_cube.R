# Read packages into R library
library(data.table)
library(data.cube)
library(rpivotTable)

# Crerate sample slide array
set.seed(1L)
ar.dimnames = list(color = sort(c("green","yellow","red")), 
                   year = as.character(2011:2015), 
                   status = sort(c("active","inactive","archived","removed")))
ar.dim = sapply(ar.dimnames, length)
ar = array(sample(c(rep(NA, 4), 4:7/2), prod(ar.dim), TRUE), 
           unname(ar.dim),
           ar.dimnames)
print(ar)

cb = as.cube(ar)
print(cb)
str(cb)
all.equal(ar, as.array(cb))
all.equal(dim(ar), dim(cb))
all.equal(dimnames(ar), dimnames(cb))

# slice

arr = ar["green",,]
print(arr)
r = cb["green",]
print(r)
all.equal(arr, as.array(r))

arr = ar["green",,,drop=FALSE]
print(arr)
r = cb["green",,,drop=FALSE]
print(r)
all.equal(arr, as.array(r))

arr = ar["green",,"active"]
r = cb["green",,"active"]
all.equal(arr, as.array(r))

# dice

arr = ar["green",, c("active","archived","inactive")]
r = cb["green",, c("active","archived","inactive")]
all.equal(arr, as.array(r))
as.data.table(r)
as.data.table(r, na.fill = TRUE)

# apply
format(aggregate(cb, c("year","status"), sum))
format(capply(cb, c("year","status"), sum))

# rollup and drilldown
# granular data with all totals
r = rollup(cb, MARGIN = c("color","year"), FUN = sum)
format(r)

# chose subtotals - drilldown to required levels of aggregates
r = rollup(cb, MARGIN = c("color","year"), INDEX = 1:2, FUN = sum)
format(r)

# pivot
r = capply(cb, c("year","status"), sum)
format(r, dcast = TRUE, formula = year ~ status)
library(rpivotTable)
r = rollup(cb, c("year","status"), FUN = sum, normalize=FALSE)
rpivotTable(r,rows="year", cols=c("status"),width="100%", height="400px")
