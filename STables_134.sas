*Supplementary Tables;

*ST1 -- combined analysis descriptive;
PROC MEANS data=data.covidsmall;
	CLASS vitDreg2;
	VAR CO_age CMsum meanPVI;
RUN;
PROC FREQ data=data.covidsmall;
	TABLES vitDreg2*SE_RACE4 vitDreg2*educ vitDreg2*COsmoke vitDreg2*COVID_PA vitDreg2*CO_meno vitDreg2*osteo vitDreg2*obese 
	vitDreg2*CVD vitDreg2*lungdisease vitDreg2*cancer vitDreg2*diabetes vitDreg2*AIdisease vitDreg2*kidneyfail vitDreg2*CMany 
	vitDreg2*covid_household vitDreg2*covidother vitDreg2*indoorgather vitDreg2*maskindoor_cat vitDreg2*essential 
	vitDreg2*patientcovid vitDreg2*travel / missing NOCUM NOCOL NOPERCENT;
RUN;


*ST3 -- sensitivity analysis, prospective;
PROC FREQ data=data.covidsmall_s6;
	TABLES preCOVID_vitDreg;
RUN;

PROC FREQ data=data.covidsmall_s6;
	WHERE preCOVID_vitDreg=0;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;
PROC FREQ data=data.covidsmall_s6;
	WHERE preCOVID_vitDreg=1;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;


%MACRO tableS3 (outcome= ,vitd= ,covars= ,cat_covars= ,model= );
PROC LOGISTIC data=data.covidsmall_s6 DESC;
	CLASS &cat_covars;
	MODEL &outcome = &vitD &cat_covars &covars;
	ODS output OddsRatios=ORs2_&outcome._&model; 
RUN;
DATA ORs2_&outcome._&model;
	SET ORs2_&outcome._&model;
	WHERE effect in ("&vitD");
	outcome="&outcome";
	model="&model";
RUN;
%MEND;


%tableS3(outcome=evercovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS3(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS3(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS3(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_evercovid_prosp;
	SET ORs2_evercovid_unadj ORs2_evercovid_mod1 ORs2_evercovid_mod2 ORs2_evercovid_mod3;
RUN;


%tableS3(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS3(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS3(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS3(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_symptomcovid_prosp;
	SET ORs2_symptomcovid_unadj ORs2_symptomcovid_mod1 ORs2_symptomcovid_mod2 ORs2_symptomcovid_mod3;
RUN;

%tableS3(outcome=severecovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS3(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS3(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS3(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_severecovid_prosp;
	SET ORs2_severecovid_unadj ORs2_severecovid_mod1 ORs2_severecovid_mod2 ORs2_severecovid_mod3;
RUN;


%tableS3(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS3(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS3(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS3(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_hospitalcovid_prosp;
	SET ORs2_hospitalcovid_unadj ORs2_hospitalcovid_mod1 ORs2_hospitalcovid_mod2 ORs2_hospitalcovid_mod3;
RUN;

DATA TableS3_ORs;
	SET ORs2_evercovid_prosp ORs2_symptomcovid_prosp
	ORs2_severecovid_prosp ORs2_hospitalcovid_prosp;
RUN;

PROC PRINT data=TableS3_ORs;
RUN;



*S4 - race/ethnicity stratified analyses;

*NHW;
PROC FREQ data=data.covidsmall_nhw;
	TABLES preCOVID_vitDreg;
RUN;

PROC FREQ data=data.covidsmall_nhw;
	WHERE preCOVID_vitDreg=0;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;
PROC FREQ data=data.covidsmall_nhw;
	WHERE preCOVID_vitDreg=1;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;


%MACRO tableS4_nhw (outcome= ,vitd= ,covars= ,cat_covars= ,model= );
PROC LOGISTIC data=data.covidsmall_nhw DESC;
	CLASS &cat_covars;
	MODEL &outcome = &vitD &cat_covars &covars;
	ODS output OddsRatios=ORs2_&outcome._&model; 
RUN;
DATA ORs2_&outcome._&model;
	SET ORs2_&outcome._&model;
	WHERE effect in ("&vitD");
	outcome="&outcome";
	model="&model";
RUN;
%MEND;


%tableS4_nhw(outcome=evercovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_nhw(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_nhw(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_nhw(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_evercovid_prosp;
	SET ORs2_evercovid_unadj ORs2_evercovid_mod1 ORs2_evercovid_mod2 ORs2_evercovid_mod3;
RUN;


%tableS4_nhw(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_nhw(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_nhw(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_nhw(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_symptomcovid_prosp;
	SET ORs2_symptomcovid_unadj ORs2_symptomcovid_mod1 ORs2_symptomcovid_mod2 ORs2_symptomcovid_mod3;
RUN;

%tableS4_nhw(outcome=severecovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_nhw(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_nhw(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_nhw(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_severecovid_prosp;
	SET ORs2_severecovid_unadj ORs2_severecovid_mod1 ORs2_severecovid_mod2 ORs2_severecovid_mod3;
RUN;


%tableS4_nhw(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_nhw(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_nhw(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_nhw(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_hospitalcovid_prosp;
	SET ORs2_hospitalcovid_unadj ORs2_hospitalcovid_mod1 ORs2_hospitalcovid_mod2 ORs2_hospitalcovid_mod3;
RUN;

DATA TableS4_nhw_ORs;
	SET ORs2_evercovid_prosp ORs2_symptomcovid_prosp
	ORs2_severecovid_prosp ORs2_hospitalcovid_prosp;
RUN;

PROC PRINT data=TableS4_nhw_ORs;
RUN;


*AA/BLACK;
PROC FREQ data=data.covidsmall_afr;
	TABLES preCOVID_vitDreg;
RUN;

PROC FREQ data=data.covidsmall_afr;
	WHERE preCOVID_vitDreg=0;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;
PROC FREQ data=data.covidsmall_afr;
	WHERE preCOVID_vitDreg=1;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;


%MACRO tableS4_aa (outcome= ,vitd= ,covars= ,cat_covars= ,model= );
PROC LOGISTIC data=data.covidsmall_afr DESC;
	CLASS &cat_covars;
	MODEL &outcome = &vitD &cat_covars &covars;
	ODS output OddsRatios=ORs2_&outcome._&model; 
RUN;
DATA ORs2_&outcome._&model;
	SET ORs2_&outcome._&model;
	WHERE effect in ("&vitD");
	outcome="&outcome";
	model="&model";
RUN;
%MEND;


%tableS4_aa(outcome=evercovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_aa(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_aa(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_aa(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_evercovid_prosp;
	SET ORs2_evercovid_unadj ORs2_evercovid_mod1 ORs2_evercovid_mod2 ORs2_evercovid_mod3;
RUN;


%tableS4_aa(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_aa(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_aa(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_aa(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_symptomcovid_prosp;
	SET ORs2_symptomcovid_unadj ORs2_symptomcovid_mod1 ORs2_symptomcovid_mod2 ORs2_symptomcovid_mod3;
RUN;

%tableS4_aa(outcome=severecovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_aa(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_aa(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_aa(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_severecovid_prosp;
	SET ORs2_severecovid_unadj ORs2_severecovid_mod1 ORs2_severecovid_mod2 ORs2_severecovid_mod3;
RUN;


%tableS4_aa(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_aa(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_aa(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_aa(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_hospitalcovid_prosp;
	SET ORs2_hospitalcovid_unadj ORs2_hospitalcovid_mod1 ORs2_hospitalcovid_mod2 ORs2_hospitalcovid_mod3;
RUN;

DATA TableS4_aa_ORs;
	SET ORs2_evercovid_prosp ORs2_symptomcovid_prosp
	ORs2_severecovid_prosp ORs2_hospitalcovid_prosp;
RUN;

PROC PRINT data=TableS4_aa_ORs;
RUN;


*HISP;
PROC FREQ data=data.covidsmall_hisp;
	TABLES preCOVID_vitDreg;
RUN;

PROC FREQ data=data.covidsmall_hisp;
	WHERE preCOVID_vitDreg=0;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;
PROC FREQ data=data.covidsmall_hisp;
	WHERE preCOVID_vitDreg=1;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;


%MACRO tableS4_hisp (outcome= ,vitd= ,covars= ,cat_covars= ,model= );
PROC LOGISTIC data=data.covidsmall_hisp DESC;
	CLASS &cat_covars;
	MODEL &outcome = &vitD &cat_covars &covars;
	ODS output OddsRatios=ORs2_&outcome._&model; 
RUN;
DATA ORs2_&outcome._&model;
	SET ORs2_&outcome._&model;
	WHERE effect in ("&vitD");
	outcome="&outcome";
	model="&model";
RUN;
%MEND;


%tableS4_hisp(outcome=evercovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_hisp(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_hisp(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_hisp(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_evercovid_prosp;
	SET ORs2_evercovid_unadj ORs2_evercovid_mod1 ORs2_evercovid_mod2 ORs2_evercovid_mod3;
RUN;


%tableS4_hisp(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_hisp(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_hisp(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_hisp(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_symptomcovid_prosp;
	SET ORs2_symptomcovid_unadj ORs2_symptomcovid_mod1 ORs2_symptomcovid_mod2 ORs2_symptomcovid_mod3;
RUN;

%tableS4_hisp(outcome=severecovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_hisp(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_hisp(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_hisp(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_severecovid_prosp;
	SET ORs2_severecovid_unadj ORs2_severecovid_mod1 ORs2_severecovid_mod2 ORs2_severecovid_mod3;
RUN;


%tableS4_hisp(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%tableS4_hisp(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%tableS4_hisp(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%tableS4_hisp(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_hospitalcovid_prosp;
	SET ORs2_hospitalcovid_unadj ORs2_hospitalcovid_mod1 ORs2_hospitalcovid_mod2 ORs2_hospitalcovid_mod3;
RUN;

DATA TableS4_hisp_ORs;
	SET ORs2_evercovid_prosp ORs2_symptomcovid_prosp
	ORs2_severecovid_prosp ORs2_hospitalcovid_prosp;
RUN;

PROC PRINT data=TableS4_hisp_ORs;
RUN;

