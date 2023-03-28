# grab the CoxMap v3 and smooth it

library(qtl2)
library(qtl2convert)
library(data.table)
library(here)

coxmap <- data.table::fread("https://raw.githubusercontent.com/kbroman/CoxMapV3/main/cox_v3_map.csv",
                            data.table=FALSE)
coxmap <- coxmap[,1:6]

# pull out maps as lists
gmap_ave <- map_df_to_list(coxmap, pos_column="cM_coxV3_ave")
gmap_female <- map_df_to_list(coxmap, pos_column="cM_coxV3_female")
gmap_male <- map_df_to_list(coxmap, pos_column="cM_coxV3_male")
pmap <- map_df_to_list(coxmap, pos_column="bp_grcm39")

# smooth each of them out
gmap_ave <- smooth_gmap(gmap_ave, pmap, 0.02)
gmap_female <- smooth_gmap(gmap_female, pmap, 0.02)
gmap_male <- smooth_gmap(gmap_male, pmap, 0.02)

# paste the smoothed versions back in
coxmap$cM_coxV3_ave <- unlist(gmap_ave)
coxmap$cM_coxV3_female <- unlist(gmap_female)
coxmap$cM_coxV3_male <- unlist(gmap_male)

# save it to file
save(coxmap, file=here("data/coxmap.RData"), compress=TRUE)
