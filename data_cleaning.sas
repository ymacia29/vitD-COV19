LIBNAME fdata_in " \\fas8200-1.s.uw.edu\ymacia29\ymacia29\Desktop\Sister Study\formats"; 
LIBNAME fcat_out " \\fas8200-1.s.uw.edu\ymacia29\ymacia29\Desktop\Sister Study\sisformats";
PROC FORMAT CNTLIN=fdata_in.sisformats_data  LIBRARY=fcat_out.sisformats; 
RUN;

LIBNAME library " \\fas8200-1.s.uw.edu\ymacia29\ymacia29\Desktop\Sister Study\sisformats";
OPTIONS NOFMTERR FMTSEARCH=(library.sisformats);
RUN;

LIBNAME original " \\fas8200-1.s.uw.edu\ymacia29\ymacia29\Desktop\Sister Study\Data\dr00280_05_01 " access=readonly;
LIBNAME data ' \\fas8200-1.s.uw.edu\ymacia29\ymacia29\Desktop\Sister Study\Data';
LIBNAME libs ' \\fas8200-1.s.uw.edu\ymacia29\ymacia29\Desktop\Sister Study\Data';


*run two other format programs*;

DATA data.covid;
	SET original.dr00280_05_01;
RUN;

PROC FREQ data=data.covid;
	TABLES COMO COYR COVID19_dxyear COVID19_event CO_Form / missing;
RUN;

DATA data.covid;
	SET data.covid;
	WHERE CO_Form=93;
	IF COYr=2022 THEN DELETE;
	IF COMo>=5 AND CoYR=2021 THEN DELETE;
RUN;
*lose 9 withdrawals;
*lose 23,546 who did not answer COVID or who responded May 2021 or later;

*vitamin D, race/ethnicity, education;
PROC FREQ data=data.covid;
	TABLES CO5_vitD CO5_multivit SE_RACE4 SE18 LL92a LL91a LL85a TQ59a TQ69a TQ72a dh_vm_fq_itm11r dh_vm_fq_itm01r
	/ missing;
RUN;

PROC FREQ data=data.covid;
	TABLES DR280_COVID19_UnDx_EOFMonth DR280_COVID19_UnDx_EOFYear DR280_COVID19_UnDx_EOFMonth*DR280_COVID19_UnDx_EOFYear/missing;
RUN;

*did not respond to a follow-up questionnaire after Mar 2021;
DATA data.covid;
	SET data.covid;
	IF DR280_COVID19_UnDx_EOFMonth<4 AND DR280_COVID19_UnDx_EOFYear<2022 THEN EOF_select=1;
	IF DR280_COVID19_UnDx_EOFMonth=. AND DR280_COVID19_UnDx_EOFYear=. THEN EOF_select=2;
	IF DR280_COVID19_UnDx_EOFMonth>=4 AND DR280_COVID19_UnDx_EOFYear>=2021 THEN EOF_select=3;
RUN;

PROC FREQ data=data.covid;
	TABLES EOF_select/missing;
RUN;

DATA data.covid;
	SET data.covid;
	IF EOF_select<2 THEN DELETE;
RUN;
*removes 463 participants;

*did not answer COVID vit D (n=1025);
DATA data.covid;
	SET data.covid;
	IF CO5_vitD=1 | CO5_multivit=1 THEN COVID_vitDreg=1;
				ELSE IF CO5_vitD=0 AND CO5_multivit=0 THEN COVID_vitDreg=0;
	IF COVID_vitDreg<1 AND CO5_OTHER=1 AND CO5_SP IN ("1 ADAY VITAMINS", "1200 CALCIUM WITH 1000 VIT D", 
	"50000 VITAMIN PREC D", "B COMPLEX AND D", "B COMPLEX, R-LIPOIC ACID, MAGNESIUM CITRATE, PRESERVISION AREDS 2, CALCIUM W VITAMIN D, HOST", 
	"B COMPLEX; D3; MAGNESIUM", "BIOTIN, VITAMIN D", "CA CITRATE PLUS D, MG,AND ZINC.  THERMACUMIN", 
	"CALCIUM CITRATE WITH  D3", "CALCIUM GUMMIES WITH VITAMIN D3", "CALCIUM WITH D AND MAGNESIUM, ALPHA LIPOIC ACID", 
	"CALCIUM WITH MAGNESIUM AND ZINC; VITAMIN D;", "CALCIUM WITH VITAMIN D", "CALCIUM, D3", 
	"CALCIUM, MAGNESIUM, ZINC; D3", "CALTRATE+D", "CENTRUM SILVER FOR WOMEN ", 
	"CITRACAL +D3, POTASSIUM 99MG", "CITRACAL MAX PLUS D3", "D", "D-3, ALGAE OMEGAS, B-12", 
	"D3", "D3,MAGNESIUM, IRON", "DIM   IODINE  BIOTIN  CALCIUM+D", "VITAMIN D", 
	"VITAMIN D 50,00 IU ONCE WEEKLY", "VITAMIN D W/CALCIUM, MAGNESIUM AND B-12", "VITAMIN D WITH CALCIUM", 
	"VITAMIN D3, BIOTIN", "VITIMAN D", "B12,D3, TURMERIC, MAGNESIUM, RED TICE YEAS", "CALCIUM +D", "CALCIUM PLUS D", 
	"CALCIUM WITH D, FISH OIL, BABY ASPRIN", 
	"CALCIUM WITH D3", "CALCIUM WITH VITAMIN D INCLUDED", "CINNAMON, FLAXSEED,CALCIUM, MAGNESIUM, VITAMIN D", "D", 
	"D3 AND CALCIUM", 
	"GRAPE SEED AND RESVERATROL, TUMERIC, VIT D3, PRESERVISION, AIRBORNE (DAILY),", 
	"I TAKE 10,000 IU PRESCRIPTION VITAMIN D ONCE PER WEEK", "JUICE PLUS VITAMIND", "MAGNESIUM WITH CALCIUM AND VITAMIN D", 
	"MAGNESIUM, D3, B12, FOLIC,", "MULTI VITAMIN", "MULTIVITAMINS WITH VITAMIN D/W/OIRON", "ONCE A WEEK PRESCRIBED VITAMIN D", 
	"OYSCO/CALCIUM, D3, MSGNESIUM OXIDE, IRON SULFATE", "SILVER CENTRUM VITAMIN", "VIT D WITH CALCIUM", 
	"VITAMIN D WITH CALCIUM, CALCIUM 600 U, FERROUS SULFATE 65MG,", "VITAMIN D", 
	"B COMPLEX, R-LIPOIC ACID, MAGNESIUM CITRATE, PRESERVISION AREDS 2, CALCIUM W VITAMIN D, HOST DEFENSE IMMUNE SUPPORT, PYRODOXAL 5(B-6), OPTIMIZED FOLATE L-METHYLFOLATE, METHYL-COBALAMIN (B-12)", 
	"CALCIUM PLUS VITAMIN D", "COQ10 MAGNESIUM D WITH CALCIUM EYE VIT", "GLUCOSAMINE, 81 MILIGRAM ASPIRIN, VITAMIN D", 
	"JARROWS B12 CALCIUM AND D WITH VITAMINS AND MINERALS", "MULTI VIT", "MULTIPLE VITAMIN", 
	"MULTIVITAMIN WITH OMEGA 3", "ONE A DAY VITAMINS", "TUMERIC AND D3", "VIT B12 ONE A DAY VIT CALCIUM", 
	"VIT D", "VIT D,B-12,", "VITAMIN D 5000", "WOMENS ONE A DAY") THEN COVID_vitDreg=1;
	IF COVID_vitDreg<0 THEN DELETE;
RUN;

*did not answer race/ethnicity or education (n=3);
DATA data.covid;
	SET data.covid;
	IF SE_RACE4<0 OR SE18<0 THEN DELETE;
RUN;

*did not answer pre-COVID vitamin questions (N=47);
DATA data.covid;
        SET data.covid;
        IF LL92a<0 AND LL91a<0 AND LL84a<0 AND TQ59a<0 AND TQ69a<0 AND TQ72a<0 AND dh_vm_fq_itm11r<0 AND dh_vm_fq_itm01r<0 
        AND dh_vm_ever_g<0 AND TQ59<0 AND TQ69<0 AND TQ72<0 AND
        LL92<0 AND LL91<0 AND LL84<0 THEN DELETE;
RUN;

PROC FREQ data=data.covid;
	TABLES COVID19_event COVID19_DxType / missing;
RUN;

*exclude if uncertain COVID (n=1376);
DATA data.covid;
	SET data.covid;
	IF COVID19_DxType=3 THEN DELETE;
RUN;

*vitamin D;
DATA data.covid;
	SET data.covid;
	IF dh_vm_fq_itm11r in (3,4) | dh_vm_fq_itm01r in (3,4) THEN base_vitDreg=1;
		ELSE IF dh_vm_fq_itm11r in (1,2) | dh_vm_fq_itm01r in (1,2) THEN base_vitDreg=0;
	IF TQ59a in (3,4) |  TQ69a in (3,4) | TQ72a in (3,4) THEN DFU2_vitDreg=1;
		ELSE IF TQ59a in (1,2) |  TQ69a in (1,2) | TQ72a in (1,2) THEN DFU2_vitDreg=0;
	IF LL92a in (3,4) |  LL91a in (3,4) | LL84a in (3,4) THEN DFU3_vitDreg=1;
		ELSE IF LL92a in (1,2) | LL91a in (1,2) | LL84a in (1,2) THEN DFU3_vitDreg=0;
	*fill in some 0's for never users;
	IF base_vitDreg<0 AND dh_vm_ever_g=1 THEN base_vitDreg=0;
	IF DFU2_vitDreg<0 AND (TQ59=0 | TQ69=0 | TQ72=0) THEN DFU2_vitDreg=0;
	IF DFU3_vitDreg<0 AND (LL92=0 | LL91=0 | LL84=0) THEN DFU3_vitDreg=0;
RUN;
PROC FREQ data=data.covid;
	TABLES base_vitDreg DFU2_vitDreg DFU3_vitDreg dh_vm_ever_g TQ59 TQ69 TQ72 LL92 LL91 LL85;
RUN;

DATA data.covid;
	SET data.covid;
	IF SUM(base_vitDreg,DFU2_vitDreg,DFU3_vitDreg)>=2 THEN preCOVID_vitDreg=1;
		ELSE IF SUM(base_vitDreg,DFU2_vitDreg,DFU3_vitDreg)=0 THEN preCOVID_vitDreg=0;
		ELSE IF SUM(base_vitDreg,DFU2_vitDreg,DFU3_vitDreg)=1 AND DFU3_vitDreg=1 THEN preCOVID_vitDreg=1;
		ELSE IF SUM(base_vitDreg,DFU2_vitDreg,DFU3_vitDreg)=1 AND DFU3_vitDreg<0 AND DFU2_vitDreg=1 THEN preCOVID_vitDreg=1;
		ELSE IF SUM(base_vitDreg,DFU2_vitDreg,DFU3_vitDreg)=1 AND DFU3_vitDreg<0 
			AND DFU2_vitDreg<0 AND base_vitDreg=1 THEN preCOVID_vitDreg=1;
		ELSE preCOVID_vitDreg=0;
	IF preCOVID_vitDreg=0 AND COVID_vitDreg=0 THEN vitDreg="never";
		ELSE IF preCOVID_vitDreg=1 AND COVID_vitDreg=0 THEN vitDreg="former";
		ELSE IF preCOVID_vitDreg=0 AND COVID_vitDreg=1 THEN vitDreg="new";
		ELSE IF preCOVID_vitDreg=1 AND COVID_vitDreg=1 THEN vitDreg="consistent";
RUN;
PROC FREQ data=data.covid;
	TABLES base_vitDreg*DFU2_vitDreg*DFU3_vitDreg / missing;
RUN;
PROC FREQ data=data.covid;
	TABLES preCOVID_vitDreg COVID_vitDreg vitDreg;
RUN;

PROC FREQ data=data.covid;
	TABLES CO19B CO15A_2 CO50B Co50BA;
RUN;

*covars in Table 1;
DATA data.covid;
	SET data.covid;
	*education;
	IF 0<SE18<=5 THEN educ=0;
		ELSE IF 6<=SE18<=7 THEN educ=1;
		ELSE IF SE18=8 THEN educ=2;
		ELSE IF SE18>8 THEN educ=3;

	*menopause;
	IF (HR_Menopause_t0=1 | HR_Menopause_t1=1 | HR_Menopause_t2=1 | HR_Menopause_t3=1 | HR_Menopause_t4=1) THEN CO_meno=1;
		ELSE CO_meno=0;

	*smoking - use COVID Q first (TOBACCO use, then fill in as needed;
	*non-smoker;
	IF SM_Smoke_t0=0 AND SM_Smoke_t4=0 AND CO50BA=0 AND CO50B~=1 THEN COsmoke=0;
	IF SM_Smoke_t0=0 AND (SM_Smoke_t4<0 AND SM_Smoke_t3=0) AND CO50BA=0 AND CO50B~=1 THEN COsmoke=0;
	IF SM_Smoke_t0=0 AND SM_Smoke_t4=0 AND CO50BA<0 THEN COsmoke=0;
	*missing data through DFU4, non-smoker at covid;
	IF SM_Smoke_t0<0 AND SM_smoke_t4<0 AND CO50BA=0 THEN COsmoke=0;
	*current smoker;
	IF (CO50BA=1 | CO50BA<0) AND (SM_Smoke_t4=2 | (SM_Smoke_t4<0 AND SM_Smoke_t3=2)  
		| (SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2=2) 
		| (SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2<0 AND SM_Smoke_t1=2) 
		| (SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2<0 AND SM_Smoke_t1<0 AND SM_Smoke_t0=2)) THEN COsmoke=2;
	*say no "pre-covid" smoking but recently listed as current smoker and did not explicitly quit;
	IF CO50BA=0 AND SM_Smoke_t4=2 AND CO50B~=3 THEN COsmoke=2;
	*if smoking "less" move to former;
	IF CO50BA=0 AND SM_Smoke_t4=2 AND CO50B=3 THEN COsmoke=1;
	*allow people to re-start;
	IF (SM_smoke_t0>0 | SM_smoke_t1>0  | SM_smoke_t2>0 | SM_smoke_t3>0 | SM_smoke_t4>0) AND CO50B=1 THEN COsmoke=2;
	*if never smoked before, assume a different kind of tobacco;
	IF (SM_smoke_t0=0 AND SM_smoke_t1=0  AND SM_smoke_t2=0 AND SM_smoke_t3=0 AND SM_smoke_t4=0) AND CO50B=1 THEN COsmoke=0;
	*former smoker;
	IF (CO50BA=1 | CO50BA<0) AND (SM_Smoke_t4=1 | (SM_Smoke_t4<0 AND SM_Smoke_t3=1) | 
		(SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2=1) |
		(SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2<0 AND SM_Smoke_t1=1) | 
		(SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2<0 AND SM_Smoke_t1<0 AND SM_Smoke_t0=1))
		AND CO50B~=1 THEN COsmoke=1;
	*said no to "pre-covid smoking" but otherwise categorized as former smoker;
	IF CO50BA=0 AND (SM_Smoke_t4=1 | (SM_Smoke_t4<0 AND SM_Smoke_t3=1) | 
		(SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2=1) |
		(SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2<0 AND SM_Smoke_t1=1) | 
		(SM_Smoke_t4<0 AND SM_Smoke_t3<0 AND SM_Smoke_t2<0 AND SM_Smoke_t1<0 AND SM_Smoke_t0=1))
		AND CO50B~=1 THEN COsmoke=1;
	*said "yes" to "pre-covid smoking" but otherwise listed as non-smoker throughout;
	IF SM_Smoke_t0=0 AND SM_Smoke_t4=0 AND CO50BA=1 AND CO50B~=1 THEN COsmoke=0;

	*physical activity - start with DFU4 and work backwards;
	COVID_Ph_hours=PH_Activity_t4;
	IF PH_Activity_t4<0 THEN COVID_Ph_hours=PH_Activity_t3;
	IF PH_Activity_t4<0 AND PH_Activity_t3<0 THEN COVID_Ph_hours=PH_Activity_t2;
	IF PH_Activity_t4<0 AND PH_Activity_t3<0 AND PH_Activity_t2<0 THEN COVID_Ph_hours=PH_Activity_t1;
	IF PH_Activity_t4<0 AND PH_Activity_t3<0 AND PH_Activity_t2<0 AND PH_Activity_t1<0 THEN COVID_Ph_hours=PH_Activity_t0;
	*in categories;
	IF 0<=COVID_Ph_hours<2.5 THEN COVID_PA=0;
		ELSE IF 2.5<=COVID_Ph_hours<8 THEN COVID_PA=1;
		ELSE IF COVID_PH_hours>=8 THEN covid_pa=2;

	*BMI / obesity;
	CO_BMI=BMI_t4;
	IF BMI_t4<0 THEN CO_BMI=BMI_t3;
	IF BMI_t4<0 AND BMI_t3<0 THEN CO_BMI=BMI_t2;
	IF BMI_t4<0 AND BMI_t3<0 AND BMI_t2<0 THEN CO_BMI=BMI_t1;
	IF BMI_t4<0 AND BMI_t3<0 AND BMI_t2<0 AND BMI_t1<0 THEN CO_BMI=BMI_t0;
	IF 0<CO_BMI<30 THEN obese=0;
		ELSE IF CO_BMI>=30 THEN obese=1;

	*any cardiovascular disease (hypertension, heart failure, heart attack, stroke, ischemic heart disease);
	CVD=0;
	IF FU_HF_Event in (.B,.U,1) THEN CVD=1;
	IF FU_HTN_Event in (.B,.U,1) THEN CVD=1;
	IF FU_IHD_Acute_Event in (.B,.U,1) THEN CVD=1;
	IF FU_IHD_Chronic_Event in (.B,.U,1) THEN CVD=1;
	IF FU_MI_Event in (.B,.U,1) THEN CVD=1;
	IF FU_Stroke_Event in (.B,.U,1) THEN CVD=1;

	*lung disease (asthma, COPD- includes bronchitis and emphysema);
	lungdisease=0;
	IF FU_Asthma_Event in (.B,.U,1) THEN lungdisease=1;
	IF FU_COPD_Event in (.B,.U,1) THEN lungdisease=1;

	*active cancer tx;
	cancer=0;
	IF CO10=1 THEN cancer=1;

	*diabetes;
	diabetes=0;
	IF FU_Diab_Event in (.B,.U,1) then diabetes=1;

	*autoimmune (Graves', multiple sclerosis, lupus, rheumatoid arthritis, scleroderma/sclerosis, hashimoto);
	AIdisease=0;
	IF DR280_DLE=1 | DR280_Graves=1 | DR280_Hashimotos=1 | DR280_MS=1 | DR280_RA=1 |
		DR280_SLE=1 | DR280_SSC=1 | DR280_Sjogrens=1 THEN AIdisease=1;

	*osteoporosis;
	IF FU_OSTPR_Event in (.B,.U,1) THEN osteo=1;
		ELSE osteo=0;

	*kidney failure;
	kidneyfail=0;
	IF DR280_KidneyFailure=1 THEN kidneyfail=1;

	*any;
	IF obese=1 | CVD=1 | lungdisease=1 | diabetes=1 | cancer=1 | AIdisease=1 | kidneyfail=1 THEN CMany=1;
		ELSE IF obese=0 AND CVD=0 AND lungdisease=0 AND diabetes=0 AND cancer=0 AND AIdisease=0 AND kidneyfail=0 THEN CMany=0;

	*sum;
	CMsum=SUM(obese,CVD,lungdisease,diabetes,cancer,AIdisease,kidneyfail);	

	*PVI through end of May 2021;
	meanPVI=MEAN(R_COV19_PVI_20200304,R_COV19_PVI_20200311,R_COV19_PVI_20200318,R_COV19_PVI_20200325,R_COV19_PVI_20200401,
		R_COV19_PVI_20200408,R_COV19_PVI_20200415,R_COV19_PVI_20200422,R_COV19_PVI_20200429,R_COV19_PVI_20200506,R_COV19_PVI_20200513,
		R_COV19_PVI_20200520,R_COV19_PVI_20200527,R_COV19_PVI_20200603,R_COV19_PVI_20200610,R_COV19_PVI_20200617,R_COV19_PVI_20200624,
		R_COV19_PVI_20200701,R_COV19_PVI_20200708,R_COV19_PVI_20200715,R_COV19_PVI_20200722,R_COV19_PVI_20200729,R_COV19_PVI_20200805,
		R_COV19_PVI_20200812,R_COV19_PVI_20200819,R_COV19_PVI_20200826,R_COV19_PVI_20200902,R_COV19_PVI_20200909,R_COV19_PVI_20200916,
		R_COV19_PVI_20200923,R_COV19_PVI_20200930,R_COV19_PVI_20201007,R_COV19_PVI_20201014,R_COV19_PVI_20201021,R_COV19_PVI_20201028,
		R_COV19_PVI_20201104,R_COV19_PVI_20201111,R_COV19_PVI_20201118,R_COV19_PVI_20201125,R_COV19_PVI_20201202,R_COV19_PVI_20201209,
		R_COV19_PVI_20201216,R_COV19_PVI_20201223,R_COV19_PVI_20201230,R_COV19_PVI_20210106,R_COV19_PVI_20210113,R_COV19_PVI_20210120,
		R_COV19_PVI_20210127,R_COV19_PVI_20210203,R_COV19_PVI_20210210,R_COV19_PVI_20210217,R_COV19_PVI_20210224,R_COV19_PVI_20210303,
		R_COV19_PVI_20210310,R_COV19_PVI_20210317,R_COV19_PVI_20210324,R_COV19_PVI_20210331,R_COV19_PVI_20210407,R_COV19_PVI_20210414,
		R_COV19_PVI_20210421,R_COV19_PVI_20210428);

	*covid in household. re-code to 0 if misisng and lived alone;
	covid_household=CO40;
	IF CO40<0 AND CO37B=1 AND CO37C=1 AND CO37D=1 AND CO37E=1 THEN covid_household=0; 
	IF CO40<0 AND CO37B<0 AND CO37C<0 AND CO37D<0 AND CO37E<0 AND SE_HH_T4=1 THEN covid_household=0;
	*change "I don't know" to no (not knowingly exposed);
	IF CO40=.D THEN covid_household=0;

	covidother=CO43;
	IF CO43=.D THEN covidother=0;
RUN;

*indoor gatherings;
	*calculate maximum level of "leaving" during each period;
%MACRO maxlefthouse;
	DATA data.covid;
		SET data.covid;
	%DO i=2 %TO 7;
	IF CO15F_&i=1 THEN max_&i=5;
		ELSE IF CO15E_&i=1 THEN max_&i=4;
		ELSE IF CO15D_&i=1 THEN max_&i=3;
		ELSE IF CO15C_&i=1 THEN max_&i=2;
		ELSE IF CO15B_&i=1 THEN max_&i=1;
		ELSE IF CO15A_&i=1 THEN max_&i=0;
	IF CO18F_&i=1 THEN maxgather_&i=5;
		ELSE IF CO18E_&i=1 THEN maxgather_&i=4;
		ELSE IF CO18D_&i=1 THEN maxgather_&i=3;
		ELSE IF CO18C_&i=1 THEN maxgather_&i=2;
		ELSE IF CO18B_&i=1 THEN maxgather_&i=1;
		ELSE IF CO18A_&i=1 THEN maxgather_&i=0;
	%END;
	meanindoor=MEAN(max_2,max_3,max_4,max_5,max_6,max_7);
	meangather=MEAN(maxgather_2,maxgather_3,maxgather_4,maxgather_5,maxgather_6,maxgather_7);
	max_maxgather=MAX(maxgather_2,maxgather_3,maxgather_4,maxgather_5,maxgather_6,maxgather_7);
	RUN;
%MEND;
%maxlefthouse;

PROC FREQ data=data.covid;
	TABLES meanindoor meangather max_maxgather;
RUN;

DATA data.covid;
	SET data.covid;
	*never left home;
	IF meanindoor=0 THEN indoorgather=0;
	*left home but never gathered;
	IF meanindoor~=0 AND max_maxgather=0 THEN indoorgather=1;
	*very small groups;
	IF meanindoor~=0 AND 1<=max_maxgather<=4 THEN indoorgather=2;
	IF meanindoor~=0 AND max_maxgather=5 THEN indoorgather=3;

	*mask wearing - take average over period;
	CO19Br=CO19B;
		IF CO19B=6 THEN CO19Br=.;
			ELSE IF CO19B=1 THEN CO19Br=4;
			ELSE IF CO19B=2 THEN CO19Br=3;
			ELSE IF CO19B=3 THEN CO19B=2;
			ELSE IF CO19B=4 THEN CO19B=1;
	CO19Cr=CO19C;
		IF CO19C=6 THEN CO19Cr=.;
			ELSE IF CO19C=1 THEN CO19Cr=4;
			ELSE IF CO19C=2 THEN CO19Cr=3;
			ELSE IF CO19C=3 THEN CO19Cr=2;
			ELSE IF CO19C=4 THEN CO19Cr=1;
	CO19Dr=CO19D;
		IF CO19D=6 THEN CO19Dr=.;
			ELSE IF CO19D=1 THEN CO19Dr=4;
			ELSE IF CO19D=2 THEN CO19Dr=3;
			ELSE IF CO19D=3 THEN CO19Dr=2;
			ELSE IF CO19D=4 THEN CO19Dr=1;
	CO19Er=CO19E;
		IF CO19E=6 THEN CO19Er=.;
			ELSE IF CO19E=1 THEN CO19Er=4;
			ELSE IF CO19E=2 THEN CO19Er=3;
			ELSE IF CO19E=3 THEN CO19Er=2;
			ELSE IF CO19E=4 THEN CO19Er=1;
	CO19Fr=CO19F;
		IF CO19F=6 THEN CO19Fr=.;
			ELSE IF CO19F=1 THEN CO19Fr=4;
			ELSE IF CO19F=2 THEN CO19Fr=3;
			ELSE IF CO19F=3 THEN CO19Fr=2;
			ELSE IF CO19F=4 THEN CO19Fr=1;
	CO19Gr=CO19G;
		IF CO19G=6 THEN CO19Gr=.;
			ELSE IF CO19G=1 THEN CO19Gr=4;
			ELSE IF CO19G=2 THEN CO19Gr=3;
			ELSE IF CO19G=3 THEN CO19Gr=2;
			ELSE IF CO19G=4 THEN CO19Gr=1;
	
	maskindoor=MEAN(CO19Br,CO19Cr,CO19Dr,CO19Er,CO19Fr,CO19Gr);
	IF 0<=indoorgather<=1 THEN maskindoor=0;

	IF maskindoor=0 THEN maskindoor_cat=0; *not necessary;
		ELSE IF indoorgather>1 AND 0<=maskindoor<1.5 THEN maskindoor_cat=1; *never, rarely;
		ELSE IF indoorgather>1 AND 1.5<=maskindoor<2.5 THEN  maskindoor_cat=2; *sometimes;
		ELSE IF indoorgather>1 AND 2.5<=maskindoor<4 THEN maskindoor_cat=3; *most of the time;
		ELSE IF indoorgather>1 AND maskindoor=4 THEN maskindoor_cat=4; *always;

	*for essential worker, fill in those who were not working at DFU4;
	IF CO22=1 THEN essential=1;
		ELSE IF CO22=0 THEN essential=0;
	IF CO22<0 AND OCS_CurrJobCt_T4=0 THEN essential=0;

	*patient care;
	IF CO21=0 | CO21=2 THEN patientcovid=0;
		ELSE IF CO21=1 AND 
			(CO21BA_1=1 | CO21BA_2=1 | CO21BA_3=1 | CO21BA_4=1 | CO21BA_5=1 | CO21BA_6=1 | CO21BA_7=1 | CO21BA_8=1 | CO21BA_9=1) 
			THEN patientcovid=2; *covid patient care;
		ELSE IF CO21=1 AND 
			(CO21BB_1=1 | CO21BB_2=1 | CO21BB_3=1 | CO21BB_4=1 | CO21BB_5=1 | CO21BB_6=1 | CO21BB_7=1 | CO21BB_8=1 | CO21BB_9=1) 
			THEN patientcovid=1; *patient care, no covid;
		ELSE IF CO21=1 THEN patientcovid=0;

	*travel;
	travel=0;
	IF CO44=1 AND (CO44A_03=1 | CO44A_04=1 | CO44A_05=1 | CO44A_06=1 | CO44A_07=1 | CO44A_08=1 | CO44A_09=1 | CO44A_10=1) 
		THEN travel=1;
	IF CO45=1 AND (CO45A_03_1~=" " | CO45A_04_1~=" " | CO45A_05_1~=" " | CO45A_06_1~=" " | CO45A_07_1~=" " 
			| CO45A_08_1~=" " | CO45A_09_1~=" " | CO45A_10_1~=" ") THEN travel=1;
	IF CO44<0 AND CO45<0 THEN travel=.;

	*yilda's version of variables;
	*smoking - use COVID Q first, then fill in as needed;
	*non-smoker;
	IF SM_SmokeStatusN=0 AND SM_Smoke_T4=0 AND CO50BA=0 AND CO50B~=1 THEN COsmokeYM=0;
	IF SM_SmokeStatusN=0 AND SM_Smoke_T4=0 AND CO50BA<0 THEN COsmokeYM=0;
	*current smoker (assume no quitters, even if used less);
	IF CO50BA=1 AND SM_Smoke_T4=2 THEN COsmokeYM=2;
	IF CO50BA<0 AND SM_Smoke_T4=2 THEN COsmokeYM=2;
	*allow people to start or re-start;
	IF CO50B=1 THEN COsmokeYM=2;
	*former smoker;
	IF CO50BA=1 AND SM_Smoke_T4=1 AND CO50B~=1 THEN COsmokeYM=1;
	IF COsmokeYM<0 AND (SM_SmokeStatusN=1 | SM_Smoke_T4=2) THEN COsmokeYM=1;
	*recently quit;
	IF COsmokeYM<0 AND SM_Smoke_T4=2 AND CO50BA=0 THEN COsmokeYM=1;
	*one missing all previous data;
	IF COsmokeYM<0 AND SM_SmokeStatusN<0 AND SM_Smoke_T4<0 AND CO50BA=0 THEN COsmokeYM=1;
	*change 100 women who never smoked (SM_) but said yes to tobacco use (vapors?);
	IF COsmokeYM=2 AND SM_SmokeStatusN=0 AND SM_Smoke_T4=0 AND CO50BA=1 THEN COsmokeYM=0;
	IF COsmokeYM=. AND SM_SmokeStatusN=0 AND SM_Smoke_T4=0 AND CO50BA=1 THEN COsmokeYM=0;
*missing 1029 participants- go based off T3 reports;
	IF COsmokeYM<0 and SM_Smoke_T3=1 THEN COsmokeYM=1;
	IF COsmokeYM<0 and SM_Smoke_T3=2 THEN COsmokeYM=2;
*missing 3 participants;
	IF CO50BA<=0 AND CO50B~=1 AND SM_smoke_t3=2 and sm_smoke_t4=1 THEN flagYMfix=1;
	IF CO50BA=0 AND CO50B~=1 AND sm_smoke_t4=2 THEN flagYMfix=1;
	IF CO50B=1 AND sm_smoke_t4=0 THEN flagYMfix=1;
	IF CO50BA=0 AND sm_smoke_t0<0 AND sm_smoke_t4<0 THEN flagYMfix=1;
	IF CO50BA=0 AND SM_smoke_t4<0 AND sm_smoke_t3=0 THEN flagYMfix=1;

	*yilda version of indoor gather;
	*never left home - does not include July 1-Dec 31, 2021 (8/9);
	IF MEAN(CO15A_2,CO15A_3,CO15A_4,CO15A_5,CO15A_6,CO15A_7)=1 THEN indoorgatherYM=0;
	*left home but never gathered;
	IF indoorgatherYM<0 AND MEAN(CO18A_2,CO18A_3,CO18A_4,CO18A_5,CO18A_6,CO18A_7)=1 THEN indoorgatherYM=1;
	*then code based on extremes;
	IF indoorgatherYM<0 AND (CO18F_2=1 | CO18F_3=1 | CO18F_4=1 | CO18F_5=1 | CO18F_6=1 | CO18F_7=1) THEN indoorgatherYM=3;
	IF indoorgatherYM<0 AND (CO18D_2=1 | CO18D_3=1 | CO18D_4=1 | CO18D_5=1 | CO18D_6=1 | CO18D_7=1 |
							CO18E_2=1 | CO18E_3=1 | CO18E_4=1 | CO18E_5=1 | CO18E_6=1 | CO18E_7=1) THEN indoorgatherYM=3;
	IF indoorgatherYM<0 AND (CO18B_2=1 | CO18B_3=1 | CO18B_4=1 | CO18B_5=1 | CO18B_6=1 | CO18B_7=1 |
							CO18C_2=1 | CO18C_3=1 | CO18C_4=1 | CO18C_5=1 | CO18C_6=1 | CO18C_7=1) THEN indoorgatherYM=2;

	IF CO15A_2=1 AND CO15B_2<1 AND CO15C_2<1 AND CO15D_2<1 AND CO15E_2<1 AND CO15F_2<1 THEN home2=0; *did not leave home entire time;
		ELSE IF CO18A_2<=1 AND (CO15B_2=1 |CO15C_2=1 | CO15D_2=1 |CO15E_2=1| CO15F_2<1) THEN home2=1; *left home at some point;
	*May 15-Jul 31, 2020 (3);
	IF CO15A_3=1 AND CO15B_3<1 AND CO15C_3<1 AND CO15D_3<1 AND CO15E_3<1 AND CO15F_3<1 THEN home3=0; *did not leave home entire time;
		ELSE IF CO18A_3<=1 AND (CO15B_3=1 |CO15C_3=1 | CO15D_3=1 |CO15E_3=1| CO15F_3<1) THEN home3=1; *left home at some point;
	*Aug 1-Sep 30, 2020 (4);
	IF CO15A_4=1 AND CO15B_4<1 AND CO15C_4<1 AND CO15D_4<1 AND CO15E_4<1 AND CO15F_4<1 THEN home4=0; *did not leave home entire time;
		ELSE IF CO18A_4<=1 AND (CO15B_4=1 |CO15C_4=1 | CO15D_4=1 |CO15E_4=1| CO15F_4<1) THEN home4=1; *left home at some point;
	*Oct1-Dec 31, 2020 (5);
	IF CO15A_5=1 AND CO15B_5<1 AND CO15C_5<1 AND CO15D_5<1 AND CO15E_5<1 AND CO15F_5<1 THEN home5=0; *did not leave home entire time;
		ELSE IF CO18A_5<=1 AND (CO15B_5=1 |CO15C_5=1 | CO15D_5=1 |CO15E_5=1| CO15F_5<1) THEN home5=1; *left home at some point;
	*Jan 1-Mar 31, 2021 (6);
	IF CO15A_6=1 AND CO15B_6<1 AND CO15C_6<1 AND CO15D_6<1 AND CO15E_6<1 AND CO15F_6<1 THEN home6=0; *did not leave home entire time;
		ELSE IF CO18A_6<=1 AND (CO15B_6=1 |CO15C_6=1 | CO15D_6=1 |CO15E_6=1| CO15F_6<1) THEN home6=1; *left home at some point;
	*Apr 1-Jun 30, 2021 (7);
	IF CO15A_7=1 AND CO15B_7<1 AND CO15C_7<1 AND CO15D_7<1 AND CO15E_7<1 AND CO15F_7<1 THEN home7=0; *did not leave home entire time;
		ELSE IF CO18A_7<=1 AND (CO15B_7=1 |CO15C_7=1 | CO15D_7=1 |CO15E_7=1| CO15F_7<1) THEN home7=1; *left home at some point;
	*final indoorgatherB variable for did not leave home;
	IF indoorgatherB<0 AND MEAN(home2,home3,home4,home5,home6,home7)=0 THEN indoorgatherB=0; 
RUN;

PROC MEANS data=data.covid;
	VAR CO_age CMsum meanPVI;
RUN;

PROC FREQ data=data.covid;
	TABLES SE_RACE4 educ COsmoke COVID_PA CO_meno osteo obese CVD lungdisease cancer diabetes AIdisease
	kidneyfail CMany covid_household covidother indoorgather maskindoor_cat essential patientcovid travel DR280_COVID19_PrimaryCOD;
RUN;


*do covid outcomes;
DATA data.covid;
	SET data.covid;
	evercovid=COVID19_Event;
	*if occurred May 2021 or later, change back to no COVID;
	IF COVID19_event=1 AND ((COVID19_DxYear=2021 AND DR280_COVID19_DxMonth>=5) | COVID19_DxYear>2021) THEN evercovid=0;
	IF evercovid=1 AND COVID19_dxtype=2 THEN symptomcovid=1;
		ELSE symptomcovid=0;
	IF evercovid=1 AND COVID19_dayssick>28 THEN severecovid=1;
		ELSE IF evercovid=1 AND COVID19_hospital=1 THEN severecovid=1;
		ELSE IF evercovid=1 AND COVID19_Sx_severity in (3,4) THEN severecovid=1;
		ELSE severecovid=0;
	IF evercovid=1 AND COVID19_hospital=1 THEN hospitalcovid=1;
		ELSE hospitalcovid=0;
	*make sure symptomcovid includes severe;
	IF symptomcovid=0 AND severecovid=1 THEN symptomcovid=1;
	*make sure COVID-19 death is included as ever, symptom, severe, and hospital;
	IF DR280_COVID19_PrimaryCOD=1 THEN evercovid=1;
	IF R280_COVID19_PrimaryCOD=1 THEN symptomcovid=1;
	IF R280_COVID19_PrimaryCOD=1 THEN severecovid=1;
	IF R280_COVID19_PrimaryCOD=1 THEN hospitalcovid=1;

RUN;

PROC FREQ data=data.covid;
	TABLES evercovid symptomcovid severecovid hospitalcovid EOF_select / missing;
RUN;

DATA data.covidsmall;
	SET data.covid;
	KEEP CO_age base_vitDreg DFU2_vitDreg DFU3_vitDreg CO5_vitD CO5_multivit SE_RACE4 SE18 
	LL92a LL91a LL85a TQ59a TQ69a TQ72a dh_vm_fq_itm11r dh_vm_fq_itm01r
	COMO COYR COVID19_dxyear COVID19_event CO_Form preCOVID_vitDreg COVID_vitDreg vitDreg
	educ COsmoke COVID_PA CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail
	CMany CMsum meanPVI covid_household covidother indoorgather maskindoor maskindoor_cat 
	essential patientcovid travel evercovid symptomcovid severecovid hospitalcovid;
RUN;

*generate race/ethnicity datasets for stratified analyses;
DATA data.covidsmall_nhw;
	SET data.covid;
	WHERE SE_RACE4=1;
	KEEP CO_age base_vitDreg DFU2_vitDreg DFU3_vitDreg CO5_vitD CO5_multivit SE_RACE4 SE18 
	LL92a LL91a LL85a TQ59a TQ69a TQ72a dh_vm_fq_itm11r dh_vm_fq_itm01r
	COMO COYR COVID19_dxyear COVID19_event CO_Form preCOVID_vitDreg COVID_vitDreg vitDreg
	educ COsmoke COVID_PA CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail
	CMany CMsum meanPVI covid_household covidother indoorgather maskindoor maskindoor_cat 
	essential patientcovid travel evercovid symptomcovid severecovid hospitalcovid;
RUN;

PROC FREQ data=data.covidsmall_nhw;
	TABLES evercovid symptomcovid severecovid hospitalcovid/ missing;
RUN;

DATA data.covidsmall_afr;
	SET data.covid;
	WHERE SE_RACE4=2;
	KEEP CO_age base_vitDreg DFU2_vitDreg DFU3_vitDreg CO5_vitD CO5_multivit SE_RACE4 SE18 
	LL92a LL91a LL85a TQ59a TQ69a TQ72a dh_vm_fq_itm11r dh_vm_fq_itm01r
	COMO COYR COVID19_dxyear COVID19_event CO_Form preCOVID_vitDreg COVID_vitDreg vitDreg
	educ COsmoke COVID_PA CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail
	CMany CMsum meanPVI covid_household covidother indoorgather maskindoor maskindoor_cat 
	essential patientcovid travel evercovid symptomcovid severecovid hospitalcovid;
RUN;

PROC FREQ data=data.covidsmall_afr;
	TABLES evercovid symptomcovid severecovid hospitalcovid/ missing;
RUN;

DATA data.covidsmall_hisp;
	SET data.covid;
	WHERE SE_RACE4=3;
	KEEP CO_age base_vitDreg DFU2_vitDreg DFU3_vitDreg CO5_vitD CO5_multivit SE_RACE4 SE18 
	LL92a LL91a LL85a TQ59a TQ69a TQ72a dh_vm_fq_itm11r dh_vm_fq_itm01r
	COMO COYR COVID19_dxyear COVID19_event CO_Form preCOVID_vitDreg COVID_vitDreg vitDreg
	educ COsmoke COVID_PA CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail
	CMany CMsum meanPVI covid_household covidother indoorgather maskindoor maskindoor_cat 
	essential patientcovid travel evercovid symptomcovid severecovid hospitalcovid;
RUN;

PROC FREQ data=data.covidsmall_hisp;
	TABLES evercovid symptomcovid severecovid hospitalcovid/ missing;
RUN;

*dataset for sensitivity analysis -- removal of participants who worked with COVID pt;
DATA data.covidsmall_s6;
	SET data.covid;
	IF patientcovid=2 THEN DELETE;
	KEEP CO_age base_vitDreg DFU2_vitDreg DFU3_vitDreg CO5_vitD CO5_multivit SE_RACE4 SE18 
	LL92a LL91a LL85a TQ59a TQ69a TQ72a dh_vm_fq_itm11r dh_vm_fq_itm01r
	COMO COYR COVID19_dxyear COVID19_event CO_Form preCOVID_vitDreg COVID_vitDreg vitDreg
	educ COsmoke COVID_PA CO_meno obese CVD lungdisease cancer diabetes AIdisease osteo kidneyfail
	CMany CMsum meanPVI covid_household covidother indoorgather maskindoor maskindoor_cat 
	essential patientcovid travel evercovid symptomcovid severecovid hospitalcovid;
RUN;
