#' @title Function to estimate individual biomass for wet forests (Chave et al. 2005).
#' @description Function to estimate tree biomass using Chave et al. (2005) equation for wet forests. 
#' Height is estimated using Feldpausch (2011) regional parameters with Weibull equation.The function adds columns  to the dataset with the biomass information for all alive trees.
#' This function needs a dataset with the following information: PlotViewID, PlotID, TreeID, CensusNo, Diameter (DBH1-DBH4), Wood density (WD) and Allometric RegionID.The function assumes that the diameter used is DBH4, unless other DBH is selected.
#' See ForestPlots.net documentaion for more information.
#' @references Chave J, Andalo C, Brown, et al. 2005. Tree allometry and improved estimation of carbon stocks and balance in tropical forests. Oecologia 145 (1):87-99. doi:10.1007/s00442-005-0100-x.
#' 
#' Feldpausch TR, Banin L, Phillips OL, Baker TR, Lewis SL et al. 2011. Height-diameter allometry of tropical forest trees. Biogeosciences 8 (5):1081-1106. doi:10.5194/bg-8-1081-2011.
#' @param xdataset a dataset for estimating biomass
#' @param dbh a diameter (in mm). 
#' 
#' @export
#' @author Gabriela Lopez-Gonzalez

AGBChv05WH <- function (xdataset, dbh = "DBH4"){
        cdf <- xdataset
        ## Clean file 
        cdf <- CleaningCensusInfo(xdataset) 
        # Get Weibull Parameters
        data(WeibullHeightParameters)
        WHP <- WeibullHeightParameters
        cdf <-merge (cdf, WHP, by = "AllometricRegionID", all.x = TRUE )
        #Estimate height
        cdf$HtF <- ifelse(cdf$DBH1 > 0 | cdf$Alive == 1, cdf$a_par*(1-exp(-cdf$b_par*(cdf[,dbh]/10)^cdf$c_par)), NA)
        #Add dead and recruits when codes are improved
        #dbh_d <- paste(dbh,"_D", sep="") 
        #cdf$Htd <- ifelse(cdf$CensusStemDied==cdf$CensusNo, cdf$a_par*(1-exp(-cdf$b_par*(cdf[,dbh_d]/10)^cdf$c_par)), NA)
        
        # Calculate AGB by stem Alive type
        cdf$AGBind <- ifelse(cdf$DBH1>0, 
                             0.0776 *(cdf$WD * (cdf[,dbh]/10)^2* cdf$HtF)^0.940/1000, 
                             NA)
        cdf$AGBAl <-  ifelse(cdf$Alive == 1, cdf$AGBind, NA)
        #cdf$AGBRec <- ifelse(cdf$NewRecruit == 1, cdf$AGBind, NA)
        #cdf$AGBDead <-ifelse(cdf$CensusStemDied==cdf$CensusNo,(0.0509*cdf$WD * ((cdf[,dbh_d]/10)^2)* cdf$Htd)/1000, NA)
        
        cdf  
        
}