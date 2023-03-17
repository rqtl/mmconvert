# grab annotation information for the MUGA arrays
# subset and place in data/

library(here)
library(data.table)

url <- "https://raw.githubusercontent.com/kbroman/MUGAarrays/main/UWisc/"

files <- c(gm="gm_uwisc_v3.csv",
           mm="mm_uwisc_v3.csv",
           mini="mini_uwisc_v4.csv",
           muga="muga_uwisc_v3.csv")

MUGAmaps <- as.list(files)
col2keep <- c("marker", "chr", "bp_grcm39", "cM_cox")

for(i in seq_along(files)) {
    file <- files[i]
    local_file <- here("inst/scripts", file)

    # download file
    if(!file.exists(file)) {
        download.file(paste0(url, file), local_file)
    }

    # read file
    tmp <- data.table::fread(local_file, data.table=FALSE)

    # subset to unique, mapped, on chr 1-19, X
    tmp <- tmp[tmp$unique & !tmp$unmapped & !is.na(tmp$chr) &
               tmp$chr %in% c(1:19,"X") & !is.na(tmp$bp_grcm39), col2keep]

    tmp <- tmp[order(factor(tmp$chr, c(1:19,"X")), tmp$bp_grcm39),]

    MUGAmaps[[i]] <- tmp
}

save(MUGAmaps, file=here("data", "MUGAmaps.RData"))
