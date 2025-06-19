

/* available covars in data set;
	CO_age base_vitDreg DFU2_vitDreg DFU3_vitDreg CO5_vitD CO5_multivit SE_RACE4 SE18 
	LL93a LL91a LL85a TQ59a TQ69a TQ72a dh_vm_fq_itm11r dh_vm_fq_itm01r
	COMO COYR COVID19_dxyear COVID19_event CO_Form preCOVID_vitDreg COVID_vitDreg vitDreg
	educ COsmoke COVID_PA CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail
	CMany CMsum meanPVI covid_household covidother indoorgather maskindoor maskindoor_cat 
	essential patientcovid travel evercovid symptomcovid severecovid hospitalcovid;
*/



*cross-sectional table 1 -- descriptive;
PROC MEANS data=data.covidsmall;
	CLASS COVID_vitDreg;
	VAR CO_age CMsum meanPVI;
RUN;
PROC FREQ data=data.covidsmall;
	TABLES COVID_vitDreg*SE_RACE4 COVID_vitDreg*educ COVID_vitDreg*COsmoke COVID_vitDreg*COVID_PA COVID_vitDreg*CO_meno COVID_vitDreg*osteo COVID_vitDreg*obese 
	COVID_vitDreg*CVD COVID_vitDreg*lungdisease COVID_vitDreg*cancer COVID_vitDreg*diabetes COVID_vitDreg*AIdisease COVID_vitDreg*kidneyfail COVID_vitDreg*CMany 
	COVID_vitDreg*covid_household COVID_vitDreg*covidother COVID_vitDreg*indoorgather COVID_vitDreg*maskindoor_cat COVID_vitDreg*essential 
	COVID_vitDreg*patientcovid COVID_vitDreg*travel / missing NOCUM NOCOL NOPERCENT;
RUN;

*prospective table 1 -- descriptive;
PROC MEANS data=data.covidsmall;
	CLASS preCOVID_vitDreg;
	VAR CO_age CMsum meanPVI;
RUN;
PROC FREQ data=data.covidsmall;
	TABLES preCOVID_vitDreg*SE_RACE4 preCOVID_vitDreg*educ preCOVID_vitDreg*COsmoke preCOVID_vitDreg*COVID_PA preCOVID_vitDreg*CO_meno preCOVID_vitDreg*osteo preCOVID_vitDreg*obese 
	preCOVID_vitDreg*CVD preCOVID_vitDreg*lungdisease preCOVID_vitDreg*cancer preCOVID_vitDreg*diabetes preCOVID_vitDreg*AIdisease preCOVID_vitDreg*kidneyfail preCOVID_vitDreg*CMany 
	preCOVID_vitDreg*covid_household preCOVID_vitDreg*covidother preCOVID_vitDreg*indoorgather preCOVID_vitDreg*maskindoor_cat preCOVID_vitDreg*essential 
	preCOVID_vitDreg*patientcovid preCOVID_vitDreg*travel / missing NOCUM NOCOL NOPERCENT;
RUN;

*covars by regular vitamin D status -- combined categories;
DATA data.covidsmall;
	SET data.covidsmall;
	IF vitDreg="never" THEN vitDreg2="0never";
		ELSE IF vitDreg="forme" THEN vitDreg2="1former";
		ELSE IF vitDreg="new" THEN vitDreg2="2new";
		ELSE IF vitDreg="consi" THEN vitDreg2="3consistent";
RUN; 


*table 2: cross-sectional and prospective OR;
PROC FREQ data=data.covidsmall;
	TABLES COVID_vitDreg preCOVID_vitDreg;
RUN;
PROC FREQ data=data.covidsmall;
	WHERE COVID_vitDreg=0;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;
PROC FREQ data=data.covidsmall;
	WHERE COVID_vitDreg=1;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;
PROC FREQ data=data.covidsmall;
	WHERE preCOVID_vitDreg=0;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;
PROC FREQ data=data.covidsmall;
	WHERE preCOVID_vitDreg=1;
	TABLES evercovid symptomcovid severecovid hospitalcovid;
RUN;


%MACRO table2 (outcome= ,vitd= ,covars= ,cat_covars= ,model= );
PROC LOGISTIC data=data.covidsmall DESC;
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


%table2(outcome=evercovid,vitd=COVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%table2(outcome=evercovid,vitd=COVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table2(outcome=evercovid,vitd=COVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table2(outcome=evercovid,vitd=COVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_evercovid_cross;
	SET ORs2_evercovid_unadj ORs2_evercovid_mod1 ORs2_evercovid_mod2 ORs2_evercovid_mod3;
RUN;

%table2(outcome=evercovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%table2(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table2(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table2(outcome=evercovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_evercovid_prosp;
	SET ORs2_evercovid_unadj ORs2_evercovid_mod1 ORs2_evercovid_mod2 ORs2_evercovid_mod3;
RUN;

%table2(outcome=symptomcovid,vitd=COVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%table2(outcome=symptomcovid,vitd=COVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table2(outcome=symptomcovid,vitd=COVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table2(outcome=symptomcovid,vitd=COVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_symptomcovid_cross;
	SET ORs2_symptomcovid_unadj ORs2_symptomcovid_mod1 ORs2_symptomcovid_mod2 ORs2_symptomcovid_mod3;
RUN;

%table2(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%table2(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table2(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table2(outcome=symptomcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_symptomcovid_prosp;
	SET ORs2_symptomcovid_unadj ORs2_symptomcovid_mod1 ORs2_symptomcovid_mod2 ORs2_symptomcovid_mod3;
RUN;

%table2(outcome=severecovid,vitd=COVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%table2(outcome=severecovid,vitd=COVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table2(outcome=severecovid,vitd=COVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table2(outcome=severecovid,vitd=COVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_severecovid_cross;
	SET ORs2_severecovid_unadj ORs2_severecovid_mod1 ORs2_severecovid_mod2 ORs2_severecovid_mod3;
RUN;

%table2(outcome=severecovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%table2(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table2(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table2(outcome=severecovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_severecovid_prosp;
	SET ORs2_severecovid_unadj ORs2_severecovid_mod1 ORs2_severecovid_mod2 ORs2_severecovid_mod3;
RUN;

%table2(outcome=hospitalcovid,vitd=COVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%table2(outcome=hospitalcovid,vitd=COVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table2(outcome=hospitalcovid,vitd=COVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table2(outcome=hospitalcovid,vitd=COVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_hospitalcovid_cross;
	SET ORs2_hospitalcovid_unadj ORs2_hospitalcovid_mod1 ORs2_hospitalcovid_mod2 ORs2_hospitalcovid_mod3;
RUN;

%table2(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars= ,cat_covars= ,model=unadj);
%table2(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table2(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table2(outcome=hospitalcovid,vitd=preCOVID_vitDreg, covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);
DATA ORs2_hospitalcovid_prosp;
	SET ORs2_hospitalcovid_unadj ORs2_hospitalcovid_mod1 ORs2_hospitalcovid_mod2 ORs2_hospitalcovid_mod3;
RUN;

DATA Table2_ORs;
	SET ORs2_evercovid_cross ORs2_evercovid_prosp ORs2_symptomcovid_cross ORs2_symptomcovid_prosp
	ORs2_severecovid_cross ORs2_severecovid_prosp ORs2_hospitalcovid_cross ORs2_hospitalcovid_prosp;
RUN;

PROC PRINT data=Table2_ORs;
RUN;


*Table 3: ORs for covid by vitamin D -- combined;
PROC FREQ data=data.covidsmall;
	TABLES vitDreg2*evercovid vitDreg2*symptomcovid vitDreg2*severecovid vitDreg2*hospitalcovid / NOCUM NOCOL NOPERCENT;
RUN;

DATA data.covidsmall;
	SET data.covidsmall;
	IF vitDreg="new" THEN vitDreg_new=1;
		ELSE vitDreg_new=0;
	IF vitDreg="forme" THEN vitDreg_former=1;
		ELSE vitDreg_former=0;
	IF vitDreg="consi" THEN vitDreg_consistent=1;
		ELSE vitDreg_consistent=0;
RUN;

%MACRO table3 (outcome= ,covars= ,cat_covars= ,model= );
PROC LOGISTIC data=data.covidsmall DESC;
	CLASS &cat_covars;
	MODEL &outcome = vitDreg_former vitDreg_new vitDreg_consistent &cat_covars &covars;
	ODS output OddsRatios=ORs_&outcome._&model; 
RUN;
DATA ORs_&outcome._&model;
	SET ORs_&outcome._&model;
	WHERE effect in ("vitDreg_former","vitDreg_new","vitDreg_consistent");
	outcome="&outcome";
	model="&model";
RUN;
%MEND;

%table3(outcome=evercovid,covars= ,cat_covars= ,model=unadj);
%table3(outcome=evercovid,covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table3(outcome=evercovid,covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table3(outcome=evercovid,covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);

DATA ORs_evercovid;
	SET ORs_evercovid_unadj ORs_evercovid_mod1 ORs_evercovid_mod2 ORs_evercovid_mod3;
RUN;

%table3(outcome=symptomcovid,covars= ,cat_covars= ,model=unadj);
%table3(outcome=symptomcovid,covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table3(outcome=symptomcovid,covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table3(outcome=symptomcovid,covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);

DATA ORs_symptomcovid;
	SET ORs_symptomcovid_unadj ORs_symptomcovid_mod1 ORs_symptomcovid_mod2 ORs_symptomcovid_mod3;
RUN;

%table3(outcome=severecovid,covars= ,cat_covars= ,model=unadj);
%table3(outcome=severecovid,covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table3(outcome=severecovid,covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table3(outcome=severecovid,covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);

DATA ORs_severecovid;
	SET ORs_severecovid_unadj ORs_severecovid_mod1 ORs_severecovid_mod2 ORs_severecovid_mod3;
RUN;

%table3(outcome=hospitalcovid,covars= ,cat_covars= ,model=unadj);
%table3(outcome=hospitalcovid,covars=CO_age,cat_covars=SE_RACE4 educ,model=mod1);
%table3(outcome=hospitalcovid,covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA,model=mod2);
%table3(outcome=hospitalcovid,covars=CO_age CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail meanPVI,
		cat_covars=SE_RACE4 educ COsmoke COVID_PA indoorgather,model=mod3);

DATA ORs_hospitalcovid;
	SET ORs_hospitalcovid_unadj ORs_hospitalcovid_mod1 ORs_hospitalcovid_mod2 ORs_hospitalcovid_mod3;
RUN;

DATA Table3_ORs;
	SET ORs_evercovid ORs_symptomcovid ORs_severecovid ORs_hospitalcovid;
RUN;
PROC PRINT data=Table3_ORs;
RUN;
