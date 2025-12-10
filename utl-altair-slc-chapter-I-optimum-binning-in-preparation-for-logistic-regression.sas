%let pgm=utl-altair-slc-chapter-I-optimum-binning-in-preparation-for-logistic-regression;

%stop_submission;

Altair slc chapter I optimum binning in preparation for logistic regression

Too long to post on a listserve, see github

github
https://github.com/rogerjdeangelis/utl-altair-slc-chapter-I-optimum-binning-in-preparation-for-logistic-regression

Key output reports

Binned character covariates excel report
https://github.com/rogerjdeangelis/utl-altair-slc-chapter-I-optimum-binning-in-preparation-for-logistic-regression/blob/main/lgs_MgmChrCut.xlsx

Binned numeric covariates excel report
https://github.com/rogerjdeangelis/utl-altair-slc-chapter-I-optimum-binning-in-preparation-for-logistic-regression/blob/main/lgs_MgmNumCut.xlsx


SECTIONS

   I   ANALYSIS OVERVIEW
  II   CAMPAIGN STRATEGY
 III   KEY OUTPUT SAMPLE OF BINNING ONE COVARIATE
  IV   INTERPRETING BINNED DATA
   V   INPUT
  VI   OUTPUT FIVE TABLES
 VII   THEORY
VIII   METHOD  (program
         1   Contents of raw input data
         2   Validate and verify raw data. fix issues with raw data
         3   One missing vale
             Drop one to one variable. Very low cardinality variables.
             Convert the many missing variable formats to just '?'
         4   Optimize variable length to the longest in the data
         5   Create Holdout and Training Tables
         6.  Bin the character variables in groups with common odds ratios
               Create normalized (long and skinny binned data wirh just 5 variables)
               Create denormalized (wide binned table with 30 variables)
         7   Create excel character data summary bin report with chi square and  Mantel Haenszel Stats
         8   Bin the numeric variables in groups with common odds ratios
               Create normalized (long and skinny binned table wirh just 5 variables)
               Create denormalized (wide binned table with 38 variables)
         9   Create excel numeric data summary bin report with chi square and  Mantel Haenszel Stats
        10   Join raw training table, numeric binned data with character binned data for analys
IX    CONTENTS OF FUTURE CHAPTERS
         Logistic diagnosis and related reports
         Fitting logistic regression on training data
         Validate training model using holdout sample
         lgs_mgmFinalLogisticDiag   Logistic Model (Diagnostics)
         lgs_MgmGainsChart          Gains Chart
         lgs_mgmTopChiValues        Most Influential Variables
         lgs_mgmTopIndexValues      Highest Response Variables
         lgs_MgmTopTen              List of Top 12 scores
         lgs_MgmVenn n              Comparison of covariate contribution to top ptile
         Final pdf presentation of results (slidedeck)

Only Input
https://github.com/rogerjdeangelis/utl-altair-slc-chapter-I-optimum-binning-in-preparation-for-logistic-regression/blob/main/lgs_raw.zip

Final logistic ready output
https://github.com/rogerjdeangelis/utl-altair-slc-chapter-I-optimum-binning-in-preparation-for-logistic-regression/blob/main/lgs_mgmallchrnum.zip

MACROS  (put these in your autocall library)
=============================================

https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories
  utlfkil
  slc_optimalbin.sas  (also in this repor=)

https://github.com/rogerjdeangelis/utl_optlen
  utloptlen.sas
  slc_voodoo20251126.sas

https://github.com/rogerjdeangelis/voodoo
  slc_voodoo20251126.sas  (doc on slc_voodoo20251126.sas)

https://github.com/rogerjdeangelis/utl-altair-slc-chapter-I-optimum-binning-in-preparation-for-logistic-regression
  slc_optimalbin.sas

NOTE: You can start with step '3  One Missing value.'.
      The first two steps are data cleaning and step 3 applies the changes suggested by
      the validation and verification macro.


NOTE: VALIDATION AND VERIFICATION OUTPUT (suggested changes)
------------------------------------------------------------

              Correlated    Correlation     Number    Spearman
Variable         With           Coef        of Obs       P

PURYER         HOMEYEAR            1          46684     0.4308 drop homeyear
SPENT          RENT                1          76643     0.4329 drop spent

AND

Variable        Populated      Missing       rcent
INCOME2               635       99,365     99.37%   drop income2
LOANS                 635       99,365     99.37%   drop loans

AND

One to One      DIVISION to DIVISIONCDE          drop division
One to One      REGION to REGIONCDE              drop region
One to One      OWNHOME to LOAN2VAL              drop loan2val
One to One      LOANHOME to HOMEVAL              drop homeval


Missing vs Populated Frequencies

   Populated,  Missing and Missing Frequencies and Percents
                                              Missing#Pe
  Variable     Populated             Missing       rcent

  INCOME2            635              99,365     99.37%
  LOANS              635              99,365     99.37%

  RENT            76,643              23,357     23.36%
  SPENT           76,643              23,357     23.36%

  PURYER          46,684              53,316     53.32%
  HOMEYEAR        46,684              53,316     53.32%

  HOMEVAL         56,931              43,069     43.07%
  LOANHOME        56,931              43,069     43.07%


            TABLE               STATISTIC      VALUE

  Table NOCHILDREN * CHILDRE    Cramer's V    1.00000  drop nochildren
  Table DIVISION * REGIONCDE    Cramer's V    1.00000
  Table DIVISIONCDE * REGION    Cramer's V    1.00000
  Table DIVISIONCDE * REGION    Cramer's V    1.00000
  Table LOADHOME * HOMEVAL      Cramer's V    1.00000
  Table OWNHOME * LOAN2VAL      Cramer's V    1.00000
  Table DIVISION * DIVISIONC    Cramer's V    1.00000
  Table DIVISION * REGION       Cramer's V    1.00000
  Table REGION * REGIONCDE      Cramer's V    1.00000
  Table HOMEYEAR * PURYER       Cramer's V    1.00000
  Table INCOME2 * LOANS         Cramer's V    1.00000

            Less Info
CHILDREN    NOCHILDREN    Frequency
-------------------------------------
?                    0       54861
N                    1       15499
Y                    0       29640




SECTIONS

   I   ANALYSIS OVERVIEW
  II   CAMPAIGN STRATEGY
 III   KEY OUTPUT SAMPLE OF BINNING ONE COVARIATE
  IV   INTERPRETING BINNED DATA
   V   INPUT
  VI   OUTPUT FIVE TABLES
 VII   THEORY
VIII   METHOD
  IX   FUTURE CHAPTERS



I  ANALYSIS OVERVIEW
--------------------

  The binary response variable identifies Bentley car owners
  (1 if owner, 0 otherwise) within a sample of 100,000 ZIP+4 codes (zip9s),
   where each code had at least one Bentley sale recorded.
  This setup filters the dataset to areas with proven Bentley demand,
  creating a targeted pool for modeling. The campaign aims to identify
  Bentley owners most likely to upgrade to Rolls-Royce, leveraging
  their luxury brand affinity for cross-selling ultra-premium vehicles.?
  I high quality Rolls-Royce model car will be sent to all residents in
  the target Zip+4.


II CAMPAIGN STRATEGY
--------------------

  Target high-propensity Bentley owners via personalized direct marketing,
  similar to Bentley's "Knowledge Bank" dossiers for bespoke outreach
  to affluent prospects. Rolls-Royce competes in the same ultra-luxury space,
  where owners often upgrade for prestige (e.g., from Bentley SUVs to Rolls-Royce models).
  Focus on zip9-level granularity for hyper-local targeting, optimizing ROI in a
  niche market.?


III KEY OUTPUT REPORT FOR SAMPLE COVARIATE
------------------------------------------

  FILE: d:/lgs/xls/lgs_mgmChrCutRpt.xlsx

                                 ZIP9 WITH                                                 Bin Coverage  Odds Ratio    Bin Pct
                                 At Least    Obs     Pct      Response  No        Total    Coverage      Bin Pct /     at least
                                 One Bentley Income  Bentley  Bentleys  Bentleys  Records  Total in Bin  Overall Rate  one Bently
   BINS  HHINCOME                Owner       Range   Owners   in Bin    in Bin    in Bin    / 70000      Bentleys/70k
         -------------------------------------------------------------------------------------------------------------------------
   1     $15,000 - $19,999      (  3,         525,   0.6%)
         $30,000 - $39,999      ( 13,        1999,   0.7%)
         $40,000 - $49,999      ( 15,        2690,   0.6%)
         LESS THAN $15,000      (  1,         696,   0.1%)      32        5878      5910     8.44%        0.33          0.54%
         -------------------------------------------------------------------------------------------------------------------------
   2     $20,000 - $29,999      ( 10,        1144,   0.9%)
         $50,000 - $74,999      (100,        9318,   1.1%)
         ?  (Missing)           (379,       32470,   1.2%)     489       42443     42932    61.33%        0.74          1.14%
         -------------------------------------------------------------------------------------------------------------------------
   3     $75,000 - $99,999      (118,        7938,   1.5%)     118        7820      7938    11.34%        1.00          1.49%
         --------------------------------------------------------------------------------
   4     $100,000 - $124,999    (128,        5510,   2.3%)     128        5382      5510     7.87%        1.54          2.32%
         -------------------------------------------------------------------------------------------------------------------------
   5     GREATER THAN $124,999  (278,        7710,   3.6%)     276        7432      7710    11.01%        2.41          3.61%
         -------------------------------------------------------------------------------------------------------------------------
                                1045        68955

  IV INTERPRETING BINNED DATA
  ---------------------------

   The report provides a breakdown of Bentley ownership likelihood based on zip9
   household income categorized into five income bins. Here s a clarification of the key points:

   1 INCOME AND BENTLEY OWNERSHIP ODDS: Zip9 areas with average household income greater
     than $124,999 (Bin 5) have an odds ratio of 2.41, meaning they are about 2.4 times
     more likely to have at least one Bentley owner compared to the overall zip9 population
     baseline. This bin records that 3.6% of households own at least one Bentley, notably
     higher than the overall rate [Bin 5, Odds Rat
     io 2.41, Bin Pct 3.6%].

   2 LOWER INCOME ZIP9 AREAS: Zip9 areas with incomes less than $50,000 (grouped in Bin 1)
     show a much lower Bentley ownership likelihood, about half the overall average rate
     (odds ratio ~0.33). Only about 0.54% of households in these low-income bins own a Bentley,
     reflecting the exclusivity of Bentley ownership aligned with higher income [Bin 1, Odds Ratio 0.33, Bin Pct 0.54%].

   3 INCOME BIN GROUPING: The five income bins effectively segment households by Bentley
     ownership propensity, where the bins increase in ownership odds and coverage.
     This stratification helps target campaigns by income groups, optimizing focus on
     higher-income areas with a greater Bentley presence.

   4 BIN COVERAGE AND RESPONSE: Each bin shows the number of observed Bentley owners
     (Response Owners) and the total households or records in that bin, providing
     coverage metrics and the percentage owning Bentleys in that income bracket.
     Bin 5, despite covering 11.01% of total records, has the highest ownership
     rate, affirming it as a prime target group.

V   INPUT
----------

    ---------------------------------------------------------
    TABLE:  d:/lgs/lgs_raw.sas7bdat  (Only one table needed)
    ---------------------------------------------------------

    THREE SAMPLE OBSERVATIONS FROM THE 100,000 D:/LGS/LGS_RAW.SAS7BDAT

    lgs.lgs_raw

    Observations          100000
    Variables             36


     -- NUMERIC -

    VARIABLE      TYP    VALUE1

    ZIP9           N8    434402039        434402039         330193725  >> Primary Key
    RESPONSE       N8    0                                  0          >> Zip9 with at least one Bentley

    INCOME         N8    20818.61         0                 1777.48
    INCOME2        N8    .                20818.61          .
    RENT           N8    28761            .                 41745
    INTEREST       N8    783406.08        28761             852674.76
    INCOM_USED     N8    61231.2          783406.08         88873.8
    SPENT          N8    191740           61231.2           278300
    LOANS          N8    .                191740            .
    HOMES          N8    1                .                 1
    CENINCOME      N8    .                1                 56500
    HOMEYEAR       N8    .                .                 2000
    OWNHOME        N8    .                .                 .
    LOADHOME       N8    .                .                 237500
    PURYER         N8    .                .                 2000
    SINGLEWIDOW    N8    0                .                 0
    NOCHILDREN     N8    0                0                 0
    AGEGTR65       N8    0                0                 0


     -- CHARACTER --

    MARRIED        C1    M                M                 S
    DWELLING       C29                                      S
    LOAN2VAL       C255
    HOMEVAL        C255                                     $225,000 - $249,999
    HHINCOME       C255                                     $100,000 - $124,999
    HOMEYRS        C46                                      10 YEARS
    OCUPASHN       C255
    AGE            C50                                      24 - 25
    ACSMARRIED     C16                                      MARRIED
    ACSGENDER      C7                                       MALE
    ACSADULTS      C40                                      4
    CHILDREN       C1                                       Y
    RETAILCARD     C39                                      UNKNOWN            >> need to chage to slc missing
    DEBITCARD      C39                                      UNKNOWN
    REGION         C16   SOUTH REGION     SOUTH REGION      SOUTH REGION
    DIVISION       C27   SOUTH ATLANTIC   SOUTH ATLANTIC    SOUTH ATLANTIC
    REGIONCDE      C5    3                3                 3
    DIVISIONCDE    C5    5                5                 5


VI OUTPUT FIVE TABLES
---------------------

   OUTPUT CONTENTS SEVEN TABLES

       DESCRIPTION                   OBS      TABLE                             COMMENT

    1.  RAW TRAINING (no binning)    70,000   d/:lgs/lgs_rawTrain.sas7bdat
    2.  RAW HOLDOUT  (no binning)    30,000   d/:lgs/lgs_rawHold.sas7bdat
    3.  LOGISTIC INPUT BINNED        70,000   d/:lgs/lgs_MgmAllChrNum.sas7bdat
    4.  NORMAILIZED CHAR BINNED     980,000   d:/lgs/lgs_mgmNrmChr.sas7bdat     14 vars*70000 observation
    5.  NORMAILIZED NUM  BINNED     910,000   d:/lgs/lgs_mgmNrmNumSrt.sas7bdat  13 vars*70000 observation
    6   CHR EXCEL REPORT INPUT          40    d:/lgs/lgs_mgmChrCutRpt           14 vars 40 obs
    7   NUM EXCEL REPORT INPUT          46    d:/lgs/lgs_mgmNumCut              13 vars 46 obs

    YOU NEED FOLDER D:/LGS

    ------------------------------------------------------------------------------------
    1. TRAINING TABLE: d/:lgs/lgs_rawTrain.sas7bdat   SELECTED=0 70,000 training dataset
    ------------------------------------------------------------------------------------

    2. HOLDOUT SAMPLE: d/:lgs/lgs_rawHold.sas7bdat    SELECTED=1 30,000 training dataset
    ------------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------
    3. LOGISTIC INPUT BINNED lgs.lgs_mgmallchrnum
    -----------------------------------------------------------------------------------==

       Middle Observation(350000 ) of table = lgs.lgs_mgmallchrnum- Total Obs 70,000 07DEC2025:13:58:22

       DIMENSION VARIABLES

       ZIP9N                N6    330193725  Primary Key
       RESPONSE             N3    0          0/1 zip9n has at least one Bentley
       SELECTED             N8    0          Always 0 is selected Training Sample

        -- CHARACTER --

       Variable            Typ    Value

       MARRIED              C1    S
       DWELLING             C1    S
       HHINCOME             C21   $100,000 - $124,999
       HOMEYRS              C16   10 YEARS
       OCUPASHN             C41   ?
       AGE                  C15   24 - 25
       ACSMARRIED           C16   MARRIED
       ACSGENDER            C6    MALE
       ACSADULTS            C21   4
       CHILDREN             C1    Y
       RETAILCARD           C39   ?
       DEBITCARD            C39   ?
       REGIONCDE            C5    3
       DIVISIONCDE          C5    5
       INCOME               N8    1777.48
       RENT                 N8    41745
       INTEREST             N8    852674.76
       INCOM_USED           N8    88873.8
       SPENT                N5    278300
       HOMES                N3    1
       CENINCOME            N4    56500
       OWNHOME              N3    .
       LOANHOME             N4    237500
       PURYER               N3    2000
       SINGLEWIDOW          N3    0
       NOCHILDREN           N3    0
       AGEGTR65             N3    0

        -- NUMERIC --   (bins of odds ratios) - odds ratio is just percent in bin/pverall response)

       _MARRIED             N8    0.5358851685
       _DWELLING            N8    1.2057416291
       _HHINCOME            N8    1.5406698594
       _HOMEYRS             N8    1.4736842133
       _OCUPASHN            N8    0.8038277527
       _AGE                 N8    0.0669856461
       _ACSMARRIED          N8    1.3397129212
       _ACSGENDER           N8    1.7416267976
       _ACSADULTS           N8    1.2727272752
       _CHILDREN            N8    1.138755983
       _RETAILCARD          N8    0.8708133988
       _DEBITCARD           N8    0.8038277527
       _REGIONCDE           N8    1.071770337
       _DIVISIONCDE         N8    1.138755983
       _INCOME              N8    0.0669856461
       _RENT                N8    0.5358851685
       _INTEREST            N8    0.5358851685
       _INCOM_USED          N8    0.6698564606
       _SPENT               N8    0.5358851685
       _CENINCOME           N8    1.071770337
       _HOMES               N8    1.0047846909
       _PURYER              N8    1.6076555055
       _LOANHOME            N8    0.7368421067
       _SINGLEWIDOW         N8    1.0047846909
       _OWNHOME             N8    1.0047846909
       _NOCHILDREN          N8    0.9377990449
       _AGEGTR65            N8    0.8708133988

   -------------------------------------------------
   4.  NORMAILIZED CHAR BINNED lgs.lgs_mgmnrmchrsrt
   -------------------------------------------------

     CHARACTER VARIABLES: LGS.LGS_mgmNrmChrSrt

     ---------------------------------------------------------------------------------
     TABLE: LGS.LGS_mgmNrmChrSrt (NORMALIZED CHAR VARS IN  LGS.LGS_mgmAllChrNum ABOVE)
     980,000 OBSERVATIONS 14*70,000
                                                          ODDS
                                                          RATIO
     Obs        ZIP9N     RESPONSE       VAR       VAL    NEWVAL

       1      10129717        0       ACSADULTS     1      0.012
       2      10133807        0       ACSADULTS     1      0.012
       3      10282473        0       ACSADULTS     1      0.012
       4      10369626        0       ACSADULTS     1      0.012
      .....
      55000   100025262       0       ACSMARRIED    3      0.019
      55001   100026551       0       ACSMARRIED    3      0.019
      55002   100035205       0       ACSMARRIED    3      0.019
      55003   100039722       0       ACSMARRIED    3      0.019
      .....
      97997   85204655        0       ACSGENDER     ?      0.011
      97998   85205346        0       ACSGENDER     ?      0.011
      97999   85251914        0       ACSGENDER     ?      0.011
      98000   85252109        0       ACSGENDER     ?      0.011

   ---------------------------------------------------------------
   5.  NORMAILIZED NUM BINNED  lgs.lgs_mgmNrmNumSrt (Pivitot long)
   ---------------------------------------------------------------

                                                                 ODDS
                  ZIP9N     RESPONSE      VAR             VAL     NEWVAL

     1          10011550        0       AGEGTR65           0     0.87081
     2          10012118        0       AGEGTR65           0     0.87081
     3          10012327        0       AGEGTR65           0     0.87081
     4          10012602        0       AGEGTR65           0     0.87081
     5          10012920        0       AGEGTR65           0     0.87081
     ...
     ...
     909996    240540000        1       SPENT    14199100.00     4.35407
     909997     64307340        0       SPENT    15198534.00     4.35407
     909998    941174225        1       SPENT    17298904.00     4.35407
     909999    140479651        0       SPENT    19532274.00     4.35407
     910000    210143428        0       SPENT    24274231.00     4.35407


   ---------------------------------------------------------
   6.   CHR EXCEL REPORT INPUT  d:/lgs/lgs_mgmChrCutRpt
   ---------------------------------------------------------

   Middle Observation(20 ) of table = lgs.lgs_mgmChrCutRpt - Total Obs 6 10DEC2025:16:35:20


    -- CHARACTER --

   Variable            Typ    Value                       Label
   ZIP9N                N8       950352628                ZIP9N

   GRP                  C1024 ?       (343, 30444, 1.1%)  Levels with#similar giving
   VAR                  C32   DWELLING                    Variable
   PERCENTRESPONSE      C200  1.13%                       Percent#Planned#Givers
   COVERAGE             C200  43.49%                      Percent#Coverage
   PVL                  C200  Chi-Square= 49.12857877 P-V Chi-Square
   GRPSUB               C1024 ?       (343, 30444, 1.1%)  GRPSUB


    -- NUMERIC --
   ONEVAL               N8               1                ONEVAL
   RNK                  N8               1                Response#Rank from#Low to High
   RESPONDERS           N8             343                Responders#Planned Givers
   NONRESPONDERS        N8           30101                Non-Responders#Others
   TOTAL                N8           30444                Total
   NEWVAL               N8    0.7368421067                Response Rate
   INDEX                N8    49.357844561                Index#Response Rate#divided by#Overall .


   ---------------------------------------------------------
   7.  NUM EXCEL REPORT INPUT   d:/lgs/lgs_mgmNumCut
   ---------------------------------------------------------

   Middle Observation(23 ) of table = lgs.lgs_MgmNumCut - Total Obs 6 10DEC2025:16:38:58


    -- CHARACTER --
   Variable            Typ    Value                       Label

   GRP                  C200  709999.8<=INTEREST<=1050835 Levels with#similar giving
   VAR                  C32   INTEREST                    Variable
   PERCENTRESPONSE      C200  0.80%                       Percent
   COVERAGE             C200  16.78%                      Percent#Coverage
   PVL                  C200  Chi-Square= 1189.6145848 P- Chi-Square


    -- NUMERIC --
   ONEVAL               N8               1                ONEVAL
   RNK                  N8               3                Response#Decile from#Low to High
   RESPONDERS           N8              94                Responders
   NONRESPONDERS        N8           11650                Non-Responders#All Others
   TOTAL                N8           11744                Total
   NEWVAL               N8    0.5358851685                Response Rate
   INDEX                N8    0.5361589518                Index#Response Rate#divided by#Overall
   AVGVAL               N8    878539.17134                AVGVAL


VII  THEORY
-----------

  Compute all the Optimal cutpoints for all covarates
  The optimal FIRST cutpoint for smoker cancel progression is 7.5 years.
  Note this is a recusive process, so futher cutpoints are possible.

  The KS statistic, or Kolmogorov-Smirnov statistic, is a non-parametric measure
  from the Kolmogorov-Smirnov test that quantifies the maximum vertical distance
  between two cumulative distribution functions (CDFs).

  See the graph is the maximum distance between
  CDFs the best cutpoint for logistic binning

          Covariate for Survival in Logistic Regression

               Theorectical Optimum Cutpoint for
   Prob      0            5           10           15 Probability
   Disease  -+------------+------------+------------- Disease
   Progress |                                       | Progres
        1.0 + The Theoretical Best    *             + 1.0
            | Cutpoint for         **           *** |
            | Logistic Binning   |*            *    |
            |                   ** K-S        *     |
            | K-S Analysi      **| cutpoint  *      |
            | determines       * |          *       |
        0.8 + the best point  *  | 7.5 yrs **       + 0.8
            |                 *  |         *        |
            | Find Maximum   *   |        *         |
            | vertical       *   |       **         |
            | distance      *    |       *          |
            |               *    |       *          |
        0.6 +              *     |      *           + 0.6
            |              *     |      *           |
            |             **     |     **           |
            |      SMOKER *      |     *            |
            |             *      |    **            |
            |            *       |    *             |
        0.4 +            *       |    *             + 0.4
            |           **       |   * NON-SMOKERS  |
            |           *        |   *              |
            |          **        |  *               |
            |          *         |  *               |
            |         **         | *                |
        0.2 +        **          | *                + 0.2
            |        *           |*                 |
            |       **           * 7.5 yrs          |
            |                   **                  |
            |     **          * *                   |
            |   **          **                      |
        0.0 +**        *****                        + 0.0
            |                                       |
            -+------------+------------+-------------
             0            5           10           15
                            YEARS
            Disease Progression after Initial Diagnosis


VIII Method
-----------

  We will use the odds ratio instead of bin number for independent variables in the final logistic model

  1   Contents of raw input data
  2   VALIDATE AND VERIFY RAW DATA. FIX ISSUES WITH RAW DATA
  3   One missing vale
      Drop one to one variable. Very low caedinality variables.
      Convert the many missing variable formats to just '?'
  4   Optimize variable length to the longest in the data
  5   Create Holdout and Training Tables
  6.  Bin the character variables in groups with common odds ratios
        Create normalized (long and skinny binned data wirh just 55 variables)
        Create denormalized (wide binned table with 30 variables)
  7   Create excel character data summary bin report with chi square and  Mantel Haenszel Stats
  8   Bin the numeric variables in groups with common odds ratios
        Create normalized (long and skinny binned table wirh just 55 variables)
        Create denormalized (wide binned table with 38 variables)
  9   Create excel numeric data summary bin report with chi square and  Mantel Haenszel Stats
 10   Join raw training table, numeric binned data with character binned data for analys

IX  Contents of future Chapters
    Logistic diagnosis and related reports
    Fitting logistic regression on training data
    lgs_mgmFinalLogisticDiag   Logistic Model (Diagnostics)
    lgs_MgmGainsChart          Gains Chart
    lgs_mgmTopChiValues        Most Influential Variables
    lgs_mgmTopOdds Ratios      Highest Response Variables
    lgs_MgmTopTen ZiP9s        List of Top 12 scores
    lgs_MgmVenn                Comparison of covariate contribution to top pcile
    Final pdf presentation of results (slidedeck)

/*                _
| |__   ___  __ _(_)_ __
| `_ \ / _ \/ _` | | `_ \
| |_) |  __/ (_| | | | | |
|_.__/ \___|\__, |_|_| |_|
 _           |___/
/ |  _ __ __ ___      __ (_)_ __  _ __  _   _| |_
| | | `__/ _` \ \ /\ / / | | `_ \| `_ \| | | | __|
| | | | | (_| |\ V  V /  | | | | | |_) | |_| | |_
|_| |_|  \__,_| \_/\_/   |_|_| |_| .__/ \__,_|\__|
                                 |_|
### 1 RAW INPUT

*/

d:/lgs/lgs_raw.sas7bdat

THREE SAMPLE OBSERVATIONS FROM THE 100,000 D:/LGS/LGS_RAWINPUT.SAS7BDAT

 -- CHARACTER --

VARIABLE      TYP    VALUE1

ZIP9           C9    434402039      330193725            434402039
MARRIED        C1    M              S                    M
DWELLING       C29                  S
LOAN2VAL       C255
HOMEVAL        C255                 $225,000 - $249,999
HHINCOME       C255                 $100,000 - $124,999
HOMEYRS        C46                  10 YEARS
OCUPASHN       C255
AGE            C50                  24 - 25
ACSMARRIED     C16                  MARRIED
ACSGENDER      C7                   MALE
ACSADULTS      C40                  4
CHILDREN       C1                   Y
RETAILCARD     C39                  UNKNOWN
DEBITCARD      C39                  UNKNOWN
REGION         C16   SOUTH REGION   SOUTH REGION         SOUTH REGION
DIVISION       C27   SOUTH ATLANTIC SOUTH ATLANTIC       SOUTH ATLANTIC
REGIONCDE      C5    3              3                    3
DIVISIONCDE    C5    5              5                    5

 -- NUMERIC -
RESPONSE       N8    0              0
INCOME         N8    20818.61       1777.48              0
INCOME2        N8    .              .                    20818.61
RENT           N8    28761          41745                .
INTEREST       N8    783406.08      852674.76            28761
INCOM_USED     N8    61231.2        88873.8              783406.08
SPENT          N8    191740         278300               61231.2
LOANS          N8    .              .                    191740
HOMES          N8    1              1                    .
CENINCOME      N8    .              56500                1
HOMEYEAR       N8    .              2000                 .
OWNHOME        N8    .              .                    .
LOADHOME       N8    .              237500               .
PURYER         N8    .              2000                 .
SINGLEWIDOW    N8    0              0                    .
NOCHILDREN     N8    0              0                    0
AGEGTR65       N8    0              0                    0

/*___                  _  __         ___               _ _     _       _
|___ \ __   _____ _ __(_)/ _|_   _  ( _ )  __   ____ _| (_) __| | __ _| |_ ___
  __) |\ \ / / _ \ `__| | |_| | | | / _ \/\\ \ / / _` | | |/ _` |/ _` | __/ _ \
 / __/  \ V /  __/ |  | |  _| |_| || (_>  < \ V / (_| | | | (_| | (_| | ||  __/
|_____|  \_/ \___|_|  |_|_|  \__, | \___/\/  \_/ \__,_|_|_|\__,_|\__,_|\__\___|
                             |___/
## 2 VERIFY & VALIDATE

see

*/

libname lgs "d:/lgs";

%inc "c:/wpsoto/slc_voodoo20251126.sas";


%utlvdoc
    (
    libname        = lgs          /* libname of input dataset */
    ,data          = lgs_raw      /* name of input dataset */
    ,key           = zip9         /* 0 or variable */
    ,ExtrmVal      = 10           /* display top and bottom 30 frequencies */
    ,UniPlot       = 0            /* 1    ' enables (0     ' disables) plot option on univariate output */
    ,UniVar        = 0            /* 1      enables (o       disables) plot option on univariate output */
    ,misspat       = 1            /* 0 or 1 missing patterns */
    ,chart         = 1            /* 0 or 1 line printer chart */
    ,taball        = RESPONSE          /* variable 0 */
    ,tabone        = RESPONSE     /* 0 or  variable vs all other variables          */
    ,mispop        = 1            /* 0 or 1  missing vs populated*/
    ,mispoptbl     = 1            /* 0 or 1  missing vs populated*/
    ,dupcol        = 0            /* 0 or 1  columns duplicated  */
    ,unqtwo        = 0
    ,vdocor        = 1            /* 0 or 1  correlation of numeric variables */
    ,oneone        = 1            /* 0 or 1  one to one - one to many - many to many */
    ,cramer        = 1            /* 0 or 1  association of character variables    */
    ,optlength     = 1
    ,maxmin        = 1
    ,unichr        = 0
    ,outlier       = 1
    ,printto       = output   /* file or output if output window */
    ,Cleanup       = 0           /* 0 or 1 delete intermediate datasets */
    );

KNOW YOUR DATA
==============

******************************************************************
*                                                                *
* No duplicates in zip9 in lgs lgs_raw                           *
*                                                                *
******************************************************************

DROP THESE VARIABLES

Variable    Populated     Missing       rcent
ZIP9          100,000           0      0.00%
INCOME2           635      99,365     99.37%     drop income2
LOANS             635      99,365     99.37%     drop loans


One to One      DIVISION to DIVISIONCDE          drop division
One to One      REGION to REGIONCDE              drop regionc
One to One      OWNHOME to LOAN2VAL              drop loan2val
One to One      LOANHOME to HOMEVAL              drop homeval

Many to One     DIVISIONCDE to REGIONCDE         drop regioncde
Many to One     DIVISIONCDE to REGION            drop region

One to Many     NOCHILDREN to CHILDREN
One to Many     INCOME2 to LOANS


  #     Variable              Unique Values
---    --------               -------------

 35    ZIP9          char           100,000

  1    ACSADULTS     char                 6
  2    ACSGENDER     char                 3
  3    ACSMARRIED    char                 5
  4    AGE           char                42
  5    AGEGTR65      num                  2
  6    CENINCOME     num              1,376
  7    CHILDREN      char                 2
  8    DEBITCARD     char                 2
  9    DIVISION      char                10
 10    DIVISIONCDE   char                10
 11    DWELLING      char                 2
 12    HHINCOME      char                 9
 13    HOMES         num                 40
 14    HOMEVAL       char                19
 15    HOMEYEAR      num                 72
 16    HOMEYRS       char                17
 17    INCOME        num             63,932
 18    INCOME2       num                542
 19    INCOM_USED    num             32,428
 20    INTEREST      num             70,296
 21    LOADHOME      num                 19
 22    LOAN2VAL      char                11
 23    LOANS         num                552
 24    NOCHILDREN    num                  2
 25    OCUPASHN      char                25
 26    OWNHOME       num                 11
 27    PURYER        num                 72
 28    REGION        char                 5
 29    REGIONCDE     char                 5
 30    RENT          num             29,714
 31    RESPONSE      num                  2
 32    RETAILCARD    char                 2
 33    SINGLEWIDOW   num                  2
 34    SPENT         um              29,716

                                    Cumulative    Cumulative
OWNHOME     Frequency    Percent     Frequency       Percent
------------------------------------------------------------
Missing         77805      77.81         77805         77.81
Zero               52       0.05         77857         77.86
Positive        22143      22.14        100000        100.00

                                    Cumulative    Cumulative
CENINCOME    Frequency    Percent     Frequency       Percent
------------------------------------------------------------
Missing          42768      42.77         42768         42.77
Zero                31       0.03         42799         42.80
Positive         57201      57.20        100000        100.00

 Missing vs Populated Frequencies
                Populated,  Missing and Missing Frequencies and Percents
                                                 Missing#Pe
  Variable        Populated             Missing       rcent
  ZIP9              100,000                   0      0.00%
  RESPONSE          100,000                   0      0.00%
  INCOME             83,870              16,130     16.13%
  INCOME2               635              99,365     99.37%
  RENT               76,643              23,357     23.36%
  INTEREST           84,033              15,967     15.97%
  INCOM_USED         84,049              15,951     15.95%
  SPENT              76,643              23,357     23.36%
  LOANS                 635              99,365     99.37%
  HOMES              76,856              23,144     23.14%
  married           100,000                   0      0.00%
  DWELLING           56,613              43,387     43.39%
  LOAN2VAL           22,195              77,805     77.81%
  HOMEVAL            56,931              43,069     43.07%
  HHINCOME           53,669              46,331     46.33%
  CENINCOME          57,232              42,768     42.77%
  HOMEYEAR           46,684              53,316     53.32%
  HOMEYRS            57,232              42,768     42.77%
  OCUPASHN           42,442              57,558     57.56%
  AGE                56,357              43,643     43.64%
  ACSMARRIED         57,232              42,768     42.77%
  ACSGENDER          57,232              42,768     42.77%
  ACSADULTS          56,092              43,908     43.91%
  CHILDREN           45,139              54,861     54.86%
  RETAILCARD         57,232              42,768     42.77%
  DEBITCARD          57,232              42,768     42.77%
  OWNHOME            22,195              77,805     77.81%
  LOADHOME           56,931              43,069     43.07%
  PURYER             46,684              53,316     53.32%
  REGION            100,000                   0      0.00%
  DIVISION          100,000                   0      0.00%
  REGIONCDE         100,000                   0      0.00%
  DIVISIONCDE       100,000                   0      0.00%
  SINGLEWIDOW       100,000                   0      0.00%
  NOCHILDREN        100,000                   0      0.00%
  AGEGTR65          100,000                   0      0.00%

ALL ARE SIMUTANEOUSLY MISSING 35% OF THE TIME


 V12     DWELLING
 V13     LOAN2VAL
 V14     HOMEVAL
 V15     HHINCOME
 V16     CENINCOME
 V17     HOMEYEAR
 V18     HOMEYRS
 V19     OCUPASHN
 V20     AGE
 V21     ACSMARRIED
 V22     ACSGENDER
 V23     ACSADULTS
 V24     CHILDREN
 V25     RETAILCARD
 V26     DEBITCARD
 V27     OWNHOME
 V28     LOADHOME
 V29     PURYER

FREQ   V12 V13 V14 V15 V16 V17 V18 V19 V20 V21 V22 V23 V24 V25 V26 V27 V28 V29

19,372  .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .
15,936  .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .



Maximums and Minimums lgs.lgs_raw

 variable         MIN                                        MAX

ZIP9           010011550                                  950354335
MARRIED        M                                          S
DWELLING       M                                          S
LOAN2VAL       0% (NO LOANS)                              95 - 99%
HOMEVAL        $1,000 - $24,999                           $750,000 - $999,999
HHINCOME       $100,000 - $124,999                        LESS THAN $15,000
HOMEYRS        1 YEAR                                     UNKNOWN
OCUPASHN       ADMINISTRATION/MANAGERIAL                  STUDENT
AGE            18 - 19                                    GREATER THAN 99
ACSMARRIED     INFERRED MARRIED                           UNKNOWN
ACSGENDER      FEMALE                                     UNKNOWN
ACSADULTS      1                                          GREATER THAN 5 ADULTS
CHILDREN       N                                          Y
RETAILCARD     PREMIUM CREDIT (DEPT STORE) CARD HOLDER    UNKNOWN
DEBITCARD      UNKNOWN                                    UPSCALE CREDIT (DEPT STORE) CARD HOLDER
REGION         MIDWEST REGION                             WEST REGION
DIVISION       EAST NORTH CENTRAL DIVISION                WEST SOUTH CENTRAL DIVISION
REGIONCDE      1                                          OTHER
DIVISIONCDE    1                                          OTHER
RESPONSE       0                                          1

INCOME         10                                         5131452.9
INCOME2        10                                         953528101
RENT           10                                         6068557.75
INTEREST       10                                         9535281010
INCOM_USED     10                                         14661294
SPENT          10                                         24274231
LOANS          10                                         9535281010

HOMES          1                                          77
CENINCOME      0                                          200000
HOMEYEAR       1900                                       2010
OWNHOME        0                                          99.5
LOADHOME       12500                                      1000000
PURYER         1900                                       2010
SINGLEWIDOW    0                      1
NOCHILDREN     0                      1
AGEGTR65       0                      1


  #     Variable              Unique Values
---    --------               -------------

 35    ZIP9          char           100,000

  1    ACSADULTS     char                 6
  2    ACSGENDER     char                 3
  3    ACSMARRIED    char                 5
  4    AGE           char                42
  5    AGEGTR65      num                  2
  6    CENINCOME     num              1,376
  7    CHILDREN      char                 2
  8    DEBITCARD     char                 2
  9    DIVISION      char                10
 10    DIVISIONCDE   char                10
 11    DWELLING      char                 2
 12    HHINCOME      char                 9
 13    HOMES         num                 40
 14    HOMEVAL       char                19
 15    HOMEYEAR      num                 72
 16    HOMEYRS       char                17
 17    INCOME        num             63,932
 18    INCOME2       num                542
 19    INCOM_USED    num             32,428
 20    INTEREST      num             70,296
 21    LOADHOME      num                 19
 22    LOAN2VAL      char                11
 23    LOANS         num                552
 24    NOCHILDREN    num                  2
 25    OCUPASHN      char                25
 26    OWNHOME       num                 11
 27    PURYER        num                 72
 28    REGION        char                 5
 29    REGIONCDE     char                 5
 30    RENT          num             29,714
 31    RESPONSE      num                  2
 32    RETAILCARD    char                 2
 33    SINGLEWIDOW   num                  2
 34    SPENT         um              29,716


bs              TABLE               STATISTIC      VALUE

 1    Table NOCHILDREN * CHILDRE    Cramer's V    1.00000
 2    Table DIVISION * REGIONCDE    Cramer's V    1.00000
 3    Table DIVISIONCDE * REGION    Cramer's V    1.00000
 4    Table DIVISIONCDE * REGION    Cramer's V    1.00000
 5    Table LOADHOME * HOMEVAL      Cramer's V    1.00000
 6    Table OWNHOME * LOAN2VAL      Cramer's V    1.00000
 7    Table DIVISION * DIVISIONC    Cramer's V    1.00000
 8    Table DIVISION * REGION       Cramer's V    1.00000
 9    Table REGION * REGIONCDE      Cramer's V    1.00000
10    Table HOMEYEAR * PURYER       Cramer's V    1.00000
11    Table INCOME2 * LOANS         Cramer's V    1.00000


Variable Correlations (Spearman)

               Correlated    Correlation     Number    Spearman
 Variable         With           Coef        of Obs       P

PURYER         HOMEYEAR                 1     46684     0.4308
SPENT          RENT                     1     76643     0.4329
LOANS          INCOME2       0.9999924427       635     0.6721
SPENT          INTEREST      0.9807287258     76643     0.4329
INTEREST       RENT          0.9807287258     76643     0.3890

OP 50 FOR RESPONSE WITH ALL OTHER VARIABLES WHERE MAX LEVELS IS 2000 AND MAX NUMBER OF VARIA
RESPONSE with RETAILCARD other variables

bs    RESPONSE                  RETAILCARD                   COUNT    PERCENT

1         0                                                  42283     42.283
2         0       UNKNOWN                                    40324     40.324
3         0       PREMIUM CREDIT (DEPT STORE) CARD HOLDER    15905     15.905
4         1       UNKNOWN                                      627      0.627
5         1                                                    485      0.485
6         1       PREMIUM CREDIT (DEPT STORE) CARD HOLDER      376      0.376

TOP 50 FOR RESPONSE WITH ALL OTHER VARIABLES WHERE MAX LEVELS IS 2000 AND MAX NUMBER OF VARIABLES IS 100
 RESPONSE with DEBITCARD other variables

Obs    RESPONSE                   DEBITCARD                   COUNT    PERCENT

 1         0                                                  42283     42.283
 2         0       UNKNOWN                                    28881     28.881
 3         0       UPSCALE CREDIT (DEPT STORE) CARD HOLDER    27348     27.348
 4         1       UPSCALE CREDIT (DEPT STORE) CARD HOLDER      633      0.633
 5         1                                                    485      0.485
 6         1       UNKNOWN                                      370      0.370



 RESPONSE with NOCHILDREN other variables

Obs    RESPONSE    NOCHILDREN    COUNT    PERCENT

 1         0            0        83324     83.324
 2         0            1        15188     15.188
 3         1            0         1177      1.177
 4         1            1          311      0.311

/*____                              _         _                         _              __
|___ /  ___  _ __   ___   _ __ ___ (_)___ ___(_)_ __   __ _ __   ____ _| |_   _  ___ |__ \
  |_ \ / _ \| `_ \ / _ \ | `_ ` _ \| / __/ __| | `_ \ / _` |\ \ / / _` | | | | |/ _ \  / /
 ___) | (_) | | | |  __/ | | | | | | \__ \__ \ | | | | (_| | \ V / (_| | | |_| |  __/ |_|
|____/ \___/|_| |_|\___| |_| |_| |_|_|___/___/_|_| |_|\__, |  \_/ \__,_|_|\__,_|\___| (_)
                                                       |___/
## 3. Use one missing value, '?', for all missing character variables
      Note the data have 'UNKNOWN' to represent missings/
*/

libname lgs "d:/lgs";

proc delete data=lgs.lgs_rawMisFix;
run;quit;

proc format;
   value $chr2mis
   'Unknown',' ','UNK','NOT DONE','ND','NA','null','na'
            ,'UNKNOWN','Missing','MISSING','NaN','NULL','MISS' ='?'
   other =[$255.]
    ;
run;quit;

data lgs.lgs_rawMisFix (
  drop=
    division
    region
    loan2val
    homeval
    income2
    loans
    homeyear
    spent
    nochildren
    );

  set lgs.lgs_raw ;

  array chr _character_;

  do over chr;
     chr = put(strip(chr),$chr2mis.);
  end;

run;quit;

/*---

SAMPLE SHOWING THE CONVERSION OF MISSING CHARACTER VALUES TO '?'

 -- CHARACTER --
Variable        Typ    Value

ZIP9N            N8    434402039   327896130

MARRIED          C1    M           M
DWELLING         C29   ?           S
HHINCOME         C255  ?           GREATER THAN $124,999
HOMEYRS          C46   ?           14 YEARS
OCUPASHN         C255  ?           RETIRED
AGE              C50   ?           84 - 85
ACSMARRIED       C16   ?           MARRIED
ACSGENDER        C7    ?           MALE
ACSADULTS        C40   ?           2
CHILDREN         C1    ?           N
RETAILCARD       C39   ?           ?
DEBITCARD        C39   ?           UPSCALE CREDIT
REGIONCDE        C5    3           3
DIVISIONCDE      C5    5           5


 -- NUMERIC --
RESPONSE         N8    0           1
INCOME           N8    20818.61    28709.1
RENT             N8    28761       21750
INTEREST         N8    783406.08   722091
INCOM_USED       N8    61231.2     46305
HOMES            N8    1           1
CENINCOME        N8    .           70200
OWNHOME          N8    .           .
LOANHOME         N8    .           237500
PURYER           N8    .           1996
SINGLEWIDOW      N8    0           0
AGEGTR65         N8    0           1

---*/

/*  _     ___        _   _           _          _                  _   _
| || |   / _ \ _ __ | |_(_)_ __ ___ (_)_______ | | ___ _ __   __ _| |_| |__  ___
| || |_ | | | | `_ \| __| | `_ ` _ \| |_  / _ \| |/ _ \ `_ \ / _` | __| `_ \/ __|
|__   _|| |_| | |_) | |_| | | | | | | |/ /  __/| |  __/ | | | (_| | |_| | | \__ \
   |_|   \___/| .__/ \__|_|_| |_| |_|_/___\___||_|\___|_| |_|\__, |\__|_| |_|___/
              |_|                                            |___/
## 4 optimize lengths

see
https://github.com/rogerjdeangelis/utl_optlen

*/

libname lgs "d:/lgs";

%utl_optlen(inp=lgs.lgs_rawMisFix,out=lgs.lgs_rawMisFix);

/*---

                   BEFORE    AFTER
 -- CHARACTER --   ------    -----

Variable           Typ

ZIP9N               N8        N8
MARRIED             C1        C1
DWELLING            C29       C1
HOMEVAL             C255      C19
HHINCOME            C255      C21
HOMEYRS             C46       C16
OCUPASHN            C255      C41
AGE                 C50       C15
ACSMARRIED          C16       C16
ACSGENDER           C7        C6
ACSADULTS           C40       C21
CHILDREN            C1        C1
RETAILCARD          C39       C39
DEBITCARD           C39       C39
REGIONCDE           C5        C5
DIVISIONCDE         C5        C5

 -- NUMERIC --
RESPONSE            N8        N3
INCOME              N8        N8
RENT                N8        N8
INTEREST            N8        N8
INCOM_USED          N8        N8
LOANS               N8        N6
HOMES               N8        N3
CENINCOME           N8        N4
OWNHOME             N8        N3
LOANHOME            N8        N4
PURYER              N8        N3
SINGLEWIDOW         N8        N3
AGEGTR65            N8        N3
___*/

/*___                       _         _           _     _             _
| ___|   ___ _ __ ___  __ _| |_ ___  | |__   ___ | | __| | ___  _   _| |_
|___ \  / __| `__/ _ \/ _` | __/ _ \ | `_ \ / _ \| |/ _` |/ _ \| | | | __|
 ___) || (__| | |  __/ (_| | ||  __/ | | | | (_) | | (_| | (_) | |_| | |_
|____/  \___|_|  \___|\__,_|\__\___| |_| |_|\___/|_|\__,_|\___/ \__,_|\__|

## 5 Create holdout
*/

libname lgs "d:/lgs";

proc delete data=lgs_rawHoldTrain lgs.lgs_rawTrain lgs.lgs_rawHold;
run;quit;

proc surveyselect
  data=lgs.lgs_rawmisfix
  out=lgs_rawHoldTrain
  samprate=0.3
  outall
  method=srs
  seed=4396;
run;

/*--- TRAINING/HOLD DATASET ---*/
data lgs.lgs_rawTrain(where=(selected=0))
     lgs.lgs_rawHold (where=(selected=1));

 set lgs_rawHoldTrain;

run;quit;

proc freq data=lgs_rawHoldTrain;
  tables selected*response;
run;quit;

/*---

LGS.LGS_RAWTRAIN   Observations 70000 Vars 30
LGS.LGS_RAWHOLD    Observations 30000 Vars 30


Frequency|
Percent  |     RESPONSE
Row Pct  |
Col Pct  |      0|       1|  Total
        -+-------+-------+-------
 H      0|  68955|   1045|  70000
 O       |  98.51|   1.49|
 L       |  70.00|  70.23|
 D      -+-------+-------+-------
 O      1|  29557|    443|  30000
 U       |  98.52|   1.48|
 T       |  30.00|  29.77|
        -+-------+-------+-------
  Total  |  98512|   1488| 100000
         |  98.51|   1.49| 100.00


Training and hOLDOUT tABLES
Middle Observation(50000 ) of table = lgs_rawHoldTrain - Total OBS = 100,000

SELECTED             N8     0   (0 fOR 70K TRAINGING TABLE. 1 FOR 30K HOLDOUT)

 -- CHARACTER --
Variable            Typ    Value

MARRIED              C1    M
DWELLING             C1    ?
HHINCOME             C21   ?
HOMEYRS              C16   ?
OCUPASHN             C41   ?
AGE                  C15   ?
ACSMARRIED           C16   ?
ACSGENDER            C6    ?
ACSADULTS            C21   ?
CHILDREN             C1    ?
RETAILCARD           C39   ?
DEBITCARD            C39   ?
REGIONCDE            C5    3
DIVISIONCDE          C5    5

 -- NUMERIC --
ZIP9N                N6     434402039
RESPONSE             N3     0
INCOME               N8     20818.61
RENT                 N8     28761
INTEREST             N8     783406.08
INCOM_USED           N8     61231.2
HOMES                N3     1
CENINCOME            N4     .
OWNHOME              N3     .
LOANHOME             N4     .
PURYER               N3     .
SINGLEWIDOW          N3     0
AGEGTR65             N3     0

---*/

/*__                _   _                 _ _     _             _
 / /_    ___  _ __ | |_(_)_ __ ___   __ _| | |__ (_)_ __    ___| |__   __ _ _ __  __   ____ _ _ __
| `_ \  / _ \| `_ \| __| | `_ ` _ \ / _` | | `_ \| | `_ \  / __| `_ \ / _` | `__| \ \ / / _` | `__|
| (_) || (_) | |_) | |_| | | | | | | (_| | | |_) | | | | || (__| | | | (_| | |     \ V / (_| | |
 \___/  \___/| .__/ \__|_|_| |_| |_|\__,_|_|_.__/|_|_| |_| \___|_| |_|\__,_|_|      \_/ \__,_|_|
             |_|
## 6 Optimal bins for char vars
*/

libname lgs "d:/lgs";

proc delete data=lgs_mkeMor lgs_all lgs.lgs_mgmNrmChr lgs.lgs_mgmMkeChr lgs_mgmMkeChr;
run;quit;

/*--- get character variables ----*/
proc sql;
  select
    name into :chrvar separated by ' '
  from
    sashelp.vcolumn
  where
    name not in ('ZIP9','SELECTED','RESPONSE') and
    libname = 'LGS' and
    memname = 'LGS_RAWTRAIN' and
    type    = 'char'

;quit;

/*---
  Char Vars
  Column Names
  -----------
  MARRIED
  DWELLING
  HHINCOME
  HOMEYRS
  OCUPASHN
  AGE
  ACSMARRIED
  ACSGENDER
  ACSADULTS
  CHILDREN
  RETAILCARD
  DEBITCARD
  REGIONCDE
  DIVISIONCDE

---*/

/*--- CREATE STATS NEEDED BY OPTIMALBIN --*/
proc sql;
 select mean(response) into :lgs_avgrsp separated by '' from lgs.lgs_rawtrain;
 select count(*)      into  :lgs_cntrec separated by '' from lgs.lgs_rawtrain;
;quit;
%put the overall response is &lgs_avgrsp -- total records are &lgs_cntrec;

/*******************************************************************/
/*  the overall response is 0.014929 -- total records are 70000    */
/*******************************************************************/

/****************************************************************************************************/
/*  You need to work through this application manually. Logistic regression is a bit of an art and  */
/*  you have to make decision at several places in the code                                         */
/****************************************************************************************************/

/*--- WRAPPER MACRO CALL TO OUTPUT WINDOW ---*/

data _null_;

  file print;

  set sashelp.vcolumn(where=(
   libname = 'LGS'         and
   type    = 'char'        and
   memname = 'LGS_RAWHOLD' and
   name not in ('ZIP9N','SELECTED','RESPONSE')));

   cmd=cats('%lgs_bucket(',name,');');
   put cmd;

run;quit;

/*--- CUT AND PASTE MACRO CALLS FROM OUTPUT WINDOW HERE     ---*/
/*--- OUTPUT WINDOW SHOULD HAVE                             ---*/

/*--- from output window
%lgs_bucket(MARRIED);
%lgs_bucket(DWELLING);
%lgs_bucket(HHINCOME);
%lgs_bucket(HOMEYRS);
%lgs_bucket(OCUPASHN);
%lgs_bucket(AGE);
%lgs_bucket(ACSMARRIED);
%lgs_bucket(ACSGENDER);
%lgs_bucket(ACSADULTS);
%lgs_bucket(CHILDREN);
%lgs_bucket(RETAILCARD);
%lgs_bucket(DEBITCARD);
%lgs_bucket(REGIONCDE);
%lgs_bucket(DIVISIONCDE);
---*/

/*--- BUKETING MACRO ---*/

%macro lgs_bucket(chr010,meth=free,key=zip9n,numbuk=5);

/*---
* METHOD (default=FREE): method used for merge of bins.
   Note: only in effect when MERGE=YES. Domain:
   FREE for nominal (categorical) variables.
   ORD for ordinal/continuous variables where missing values are to be
           merged with the lowest bin.
   FLOAT for ordinal/continuous variables where missing values may be
           merged with any other bin.;
---*/

%slc_optimalbin
   (
     tla=lgs
    ,lib=work
    ,set=lgs_mkemor
    ,target=response
    ,pre=_
    ,key=&key
    ,varinl=&chr010
    ,method=&meth
    ,mincl=2
    ,maxcl=&numbuk
    ,rank=yes
    ,merge=yes
    ,alpha=.05
    ,round=.001
    ,addvar=yes
    ,typevar=lin
    ,cnval=20
   );

%mend lgs_bucket;

/*--- wrapper macro call to output window ---*/

data _null_;
 set lgs.lgs_rawTrain(obs=1 drop=zip9n selected);
 array chr[*] _character_;
 array num[*] _numeric_;
 do i=1 to dim(chr);
   var=lowcase(vname(chr[i]));
   put '%lgs_bucket(' var ');';
 end;
 put //;
 do i=1 to dim(num);
   var=lowcase(vname(num[i]));
   put '%lgs_bucketn(' var ',meth=ord );';
 end;
 put // 'numeric' //;
 do i=1 to dim(num);
   var=lowcase(vname(num[i]));
   put var;
 end;
 put // 'charcacter' //;
 do i=1 to dim(chr);
   var=lowcase(vname(chr[i]));
   put var;
 end;
run;

/*--- place for intermdiate result---*/
data lgs_mkemor ;
  set lgs.lgs_rawtrain(keep=&chrvar zip9n response);
run;

/*--- set up an empty dataset to add optimin bins output to ---*/
/*--- place for appened results ---*/
* make empty dataset;
data lgs_all;
 if _n_=0 then output;;
 length zip9n 8  response  8 var $32 val $96 newval 8.;
run;
/*--- cut and paste macro calls from output window here     ---*/

%lgs_bucket(MARRIED);
%lgs_bucket(DWELLING);
%lgs_bucket(HHINCOME);
%lgs_bucket(HOMEYRS);
%lgs_bucket(OCUPASHN);
%lgs_bucket(AGE);
%lgs_bucket(ACSMARRIED);
%lgs_bucket(ACSGENDER);
%lgs_bucket(ACSADULTS);
%lgs_bucket(CHILDREN);
%lgs_bucket(RETAILCARD);
%lgs_bucket(DEBITCARD);
%lgs_bucket(REGIONCDE);
%lgs_bucket(DIVISIONCDE);

data lgs.lgs_mgmNrmChr;
  set lgs_all;
  newval=newval/&lgs_avgRsp; /*--- odds ratio ---*/
run;quit;

data lgs_mgmMkeChr;
  set lgs_mkemor;
  array und _:;
  do over und;
    und = und/&lgs_avgRsp; /*--- odds ratio ---*/
  end;
run;quit;

proc sort data=lgs.lgs_mgmnrmchr out=lgs.lgs_mgmNrmChr;
by var newval val;
run;quit;

%utl_optlen(inp=lgs_mgmMkeChr,out=lgs.lgs_mgmMkeChr);

/*           _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| `_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
*/

/*---
TWO TABLES

---------------------------------------------------
1. TABLE: LGS.LGS_MGMMKECHR OBS=70,000 30 VARUABLES
   --------------------------------------------------

14 CHARACTER VARIABLE and 14 MATCHING VARIABLES WITH GROUPS WITH COMMOM ODDS RATIOS

FOR EACH CHARACTER VARIABLE AN ADDITIONAL VARIABLE WITH THE SAME NAME BUT UNDERLINED
IS CREATED. THE UNDERLINED VARIABLES CONTAIN THE BIN LEVEL WHICH IS THE ODDS RATION
FOR THE BIN.

data x ;
set lgs.lgs_mgmMkeChrSrt(where=(zip9n=330193725));
run;quit;


 -- CHARACTER --

Variable                        Typ    Value

ZIP9N                            N6    327896130

MARRIED                          C1    M
DWELLING                         C1    S
HHINCOME                         C21   GREATER THAN $124,999
HOMEYRS                          C16   14 YEARS
OCUPASHN                         C41   RETIRED
AGE                              C15   84 - 85
ACSMARRIED                       C16   MARRIED
ACSGENDER                        C6    MALE
ACSADULTS                        C21   2
CHILDREN                         C1    N
RETAILCARD                       C39   ?
DEBITCARD                        C39   UPSCALE CREDIT
REGIONCDE                        C5    3
DIVISIONCDE                      C5    5

 -- NUMERIC --  ODDS RATIO BINS

RESPONSE                         N3    1

                                       BINS
_MARRIED                         N8    0.5358851685  >>>> ADDED NUMERIC VARIABLES
_DWELLING                        N8    1.2057416291  CONVERTED TO BINNED NUMERIC ODD RATIOS
_HHINCOME                        N8    1.5406698594
_HOMEYRS                         N8    1.4736842133
_OCUPASHN                        N8    0.8038277527
_AGE                             N8    0.0669856461
_ACSMARRIED                      N8    1.3397129212
_ACSGENDER                       N8    1.7416267976
_ACSADULTS                       N8    1.2727272752
_CHILDREN                        N8     1.138755983
_RETAILCARD                      N8    0.8708133988
_DEBITCARD                       N8    0.8038277527
_REGIONCDE                       N8     1.071770337
_DIVISIONCDE                     N8     1.138755983

NOTE: YOU CAN SHOW THE BINNING WITH A SIMPLE PROC FREQ

Proc freq data=lgs.lgs_mgmMkeChr ;
  tables _hhincome*hhincome /list;
run;quit;

PROPENSITY
ODDS RATIOS
_HHINCOME       HHINCOME                 Frequency
--------------------------------------------------
0.3349282303    $15,000 - $19,999             525
0.3349282303    $30,000 - $39,999            1999
0.3349282303    $40,000 - $49,999            2690
0.3349282303    LESS THAN $15,000             696

0.7368421067    $20,000 - $29,999            1144
0.7368421067    $50,000 - $74,999            9318
0.7368421067    ?                           32470

1.0047846909    $75,000 - $99,999            7938

1.5406698594    $100,000 - $124,999          5510

2.4114832582    GREATER THAN $124,999        7710


-------------------------------------------------------------
2. TABLE: LGS.LGS_MGMNRMCHRSRT (NORMALIZED LGS.LGS_MGMMKECHR)
980,000 OBSERVATIONS 14*70,000
-------------------------------------------------------------
                                                     ODDS
                                                     RATIO
Obs        ZIP9N     RESPONSE       VAR       VAL    NEWVAL

  1      10129717        0       ACSADULTS     1      0.80
  2      10133807        0       ACSADULTS     1      0.80
  3      10282473        0       ACSADULTS     1      0.80
  4      10369626        0       ACSADULTS     1      0.80
 .....
 55000   100025262       0       MARRIED       M      1.81
 55001   100026551       0       MARRIED       M      1.81
 55002   100035205       0       MARRIED       M      1.81
 55003   100039722       0       MARRIED       M      1.81
 .....
 97997   85204655        0       ACSGENDER     ?      0.74
 97998   85205346        0       ACSGENDER     ?      0.74
 97999   85251914        0       ACSGENDER     ?      0.74
 98000   85252109        0       ACSGENDER     ?      0.74

---*/

/*____       _                                    _                             _
|___  |  ___| |__   __ _ _ __    _____  _____ ___| |  _ __ ___ _ __   ___  _ __| |_
   / /  / __| `_ \ / _` | `__|  / _ \ \/ / __/ _ \ | | `__/ _ \ `_ \ / _ \| `__| __|
  / /  | (__| | | | (_| | |    |  __/>  < (_|  __/ | | | |  __/ |_) | (_) | |  | |_
 /_/    \___|_| |_|\__,_|_|     \___/_/\_\___\___|_| |_|  \___| .__/ \___/|_|   \__|
                                                              |_|
## 7 char excel report
*/

/*--- overall response rate ---*/

libname lgs "d:/lgs";

proc delete data=lgs.lgs_mgmRolChr lgs_chisqr1st
      lgs_chisqr1st lgs_chisq lgs_two lgs.lgs_MgmChrCutRpt
      lgs.lgs_MgmChrCutRpt;
run;quit;

proc sql noprint;
 select
    avg(response)
   ,count(*)
 into
   :lgs_avgrsp trimmed
  ,:lgs_cntrec trimmed
 from
    lgs.lgs_rawtrain
;quit;

%put &=lgs_avgrsp; /*---  LGS_AVGRSP=0.014929 ---*/
%put &=lgs_cntrec; /*---  LGS_CNTREC=70000    ---*/

/*--- LGS_AVGRSP=0.014929 ---*/

data lgs_mgmRolChr(drop= val response spc pctrsp valrsp valtot spcone);
  length grp $1024 grpsub $1024;
  retain grp '' responders nonresponders total . rnk valtot  0;
  set lgs.lgs_mgmnrmchr;
  by var newval val;
  if first.val then do;
     valrsp=0;
     valtot=0;
  end;
  responders+(response=1);
  nonresponders+(response=0);
  valrsp+(response=1);
  valtot+1;
  total+1;
  spc="/**/       /**/";
  spcone="/**/ /**/";
  if last.val then do;
         pctrsp=put(valrsp/valtot,percent8.1);
         grpsub=resolve(cats(val,spc,'(',put(valrsp,9.),',',spcone,put(valtot,9.),',',spcone,pctrsp,')'));
         grp=catx('~n',grp,grpsub);
  end;
  if last.newval then do;
     rnk+1;
     if responders=0 then newval=newval+.001;
     index             =  newval/&lgs_avgrsp;
     PercentResponse   =  cats(put(100*newval,6.2),'%');
     output;
     grp='';
     total=0;
     responders=0;
     nonresponders=0;
  end;
  if last.var then do;
     rnk=0;
     put var;
  end;
run;

/* build table */
data lgs_chisqr1st;
  keep var grp rsp cnt newval;
  set lgs_mgmrolchr;
  rsp=1;
  cnt=responders;
  output;
  rsp=0;
  cnt=nonresponders;
  output;
run;

ods output chisq=lgs_chisq (where=( statistic in ('Chi-Square' 'Mantel-Haenszel Chi-Square')));
proc freq data=lgs_chisqr1st;
by var;
tables newval*rsp/chisq list;
weight cnt;
run;

proc sql;
  create
    table lgs_two as
  select
    l.var
   ,case
      when (l.df=1) then catx(' ','Chi-Square=',put(l.value,best.),'P-Value=',put(l.prob,9.5))
      else               catx(' ','Chi-Square=',put(r.value,best.),'P-Value=',put(r.prob,9.5))
    end as Pvl
  from
    lgs_chisq as l, lgs_chisq as r
  where
    l.var = r.var                  and
    l.statistic in ('Chi-Square')  and
    r.statistic in ('Mantel-Haenszel Chi-Square')
;quit;

data lgs.lgs_mgmChrCutRpt;
 retain oneval 1 Rnk GRP VAR RESPONDERS NONRESPONDERS TOTAL NEWVAL INDEX PERCENTRESPONSE;
 label
    rnk             =  "Response#Rank from#Low to High"
    responders      =  "Responders#Planned Givers"
    nonresponders   =  "Non-Responders#Others"
    total           =  "Total"
    coverage        =  "Percent#Coverage"
    var             =  "Variable"
    newval          =  "Response Rate"
    index           =  "Index#Response Rate#divided by#Overall .75%"
    grp             =  "Levels with#similar giving"
    pvl             =  "Chi-Square"
    percentresponse =  "Percent#Planned#Givers";
  merge lgs_mgmrolchr lgs_two;
  by var;
  coverage=       cats(put(100*total/&lgs_cntrec,6.2),'%');
  percentresponse=cats(put(100*responders/total ,6.2),'%');
run;

%utlfkil(d:/lgs/xls/lgs_MgmChrCut.xlsx);

%let cutoff=Bently;

ods listing close;
ods escapechar='~';
ods excel file="d:/lgs/xls/lgs_MgmChrCut.xlsx";
ods  excel
        options(                     /* column widths in points */
        suppress_bylines           = 'no'
        embedded_titles            = 'no'
        gridlines                  = 'yes'
        sheet_interval             = "none"
        sheet_name                 = "chrcut"
        frozen_headers             = 'Yes'
        absolute_column_width      =  "10,30,34,14,14,10,12,12,12"
        autofit_height             = 'yes'
        width_fudge                = "0.67"
        width_points               = "9"
        frozen_rowheaders          = 'no' );

title;footnote;
proc report data=lgs.lgs_mgmChrCutRpt nowd missing split='#'  style=[protectspecialchars=off];
cols rnk pvl var grp  responders nonresponders total coverage index percentresponse ;
define  pvl           / order    noprint order=data;
define  var              / order    "Variable" order=data                                ;
define  rnk              / display "Bentley#Response#Bin from#Low to High"  order=data        ;
define  grp              / display "Levels with similar Bentley#Percent"  style(column)={asis=on tagattr='wrap:yes'};
define  responders       / sum     "At Least#Bentley#Responders"                ;
define  nonresponders    / sum     "No#Bentleys"                  ;
define  total            / sum     "Total#In Bin"                                   ;
define  coverage         / display "Percent#Coverage#Bin Total#/70000"  right style={just=r}   ;
define  index            / display "Odds Ratio#Bentley Rate#divided by#%sysfunc(compbl(Overall %sysevalf(100*&lgs_avgrsp)%))" format=6.2;
define  percentresponse  / display "Percent#Bentley"  right style={just=r};
/*---
compute percentresponse;
  call define(_col_, "Style", "Style = [background = yellow]");
endcomp;
compute total;
  call define(_col_, "Style", "Style = [background = yellow]");
endcomp;
---*/
break before pvl /  skip ;
compute before pvl / style={just=l font_weight=bold};
line "    ";
line  pvl $96.;
endcomp;
break after pvl / summarize skip ;
run;quit;
ods excel close;
ods listing;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/*----
FILE: d:/lgs/xls/lgs_mgmChrCutRpt.xlsx
                                                                                         Bin Coverage  Odds Ratio    Bin Pct
                              At Least   Obs     Pct      Response  No        Total    Coverage      Bin Pct /     at least
                            One Bentley  Income  Bentley  Bentleys  Bentleys  Records  Total in Bin  Overall Rate  one Bently
 BINS  HHINCOME                Owner     Range   Owners   in Bin    in Bin    in Bin    / 70000      Bentleys/70k
       -----------------------------------------------------------------------------------------------------------------------
 1     $15,000 - $19,999      (  3,       525,   0.6%)
       $30,000 - $39,999      ( 13,      1999,   0.7%)
       $40,000 - $49,999      ( 15,      2690,   0.6%)
       LESS THAN $15,000      (  1,       696,   0.1%)      32        5878      5910     8.44%        0.33          0.54%
       -----------------------------------------------------------------------------------------------------------------------
 2     $20,000 - $29,999      ( 10,      1144,   0.9%)
       $50,000 - $74,999      (100,      9318,   1.1%)
       ?  (Missing)           (379,     32470,   1.2%)     489       42443     42932    61.33%        0.74          1.14%
       -----------------------------------------------------------------------------------------------------------------------
 3     $75,000 - $99,999      (118,      7938,   1.5%)     118        7820      7938    11.34%        1.00          1.49%
       -----------------------------------------------------------------------------------------------------------------------
 4     $100,000 - $124,999    (128,      5510,   2.3%)     128        5382      5510     7.87%        1.54          2.32%
       -----------------------------------------------------------------------------------------------------------------------
 5     GREATER THAN $124,999  (278,      7710,   3.6%)     276        7432      7710    11.01%        2.41          3.61%
       -----------------------------------------------------------------------------------------------------------------------
                              1045      68955
---*/

/*___               _   _                 _ _     _
 ( _ )   ___  _ __ | |_(_)_ __ ___   __ _| | |__ (_)_ __   _ __  _   _ _ __ ___   __   ____ _ _ __
 / _ \  / _ \| `_ \| __| | `_ ` _ \ / _` | | `_ \| | `_ \ | `_ \| | | | `_ ` _ \  \ \ / / _` | `__|
| (_)  | (_) | |_) | |_| | | | | | | (_| | | |_) | | | | || | | | |_| | | | | | |  \ V / (_| | |
 \___/  \___/| .__/ \__|_|_| |_| |_|\__,_|_|_.__/|_|_| |_||_| |_|\__,_|_| |_| |_|   \_/ \__,_|_|
             |_|
*/

/*--- CREATE BUCKETN MACRO FOR LATER USE ---*/

libname lgs "d:/lgs";

proc delete data=lgs_mkemor lgs_all lgs.lgs_mgmmkenum lgs.lgs_mgmnrmnumsrt;
run;quit;

%macro lgs_bucketn(varin,numbuk=5);

  %slc_optimalbin
     (
       tla=lgs
      ,lib=work
      ,set=lgs_mkemor
      ,target=response
      ,pre=_
      ,key=zip9n
      ,varinl=&varin
      ,method=float
      ,mincl=2
      ,maxcl=&numbuk
      ,rank=yes
      ,merge=yes
      ,alpha=.05
      ,round=.001
      ,addvar=yes
      ,typevar=lin
      ,cnval=20
     );

%mend lgs_bucketn;

proc sql;
  select
    name into :numvar separated by ' '
  from
    sashelp.vcolumn
  where
    name not in ('ZIP9','SELECTED','RESPONSE') and
    libname = 'LGS' and
    memname = 'LGS_RAWTRAIN' and
    type    = 'num'

;quit;

/*---
  Num Vars
  Column Names
  -----------
  INCOME
  RENT
  INTEREST
  INCOM_USED
  SPENT
  HOMES
  CENINCOME
  HOMEYEAR
  OWNHOME
  LOANHOME
  PURYER
  SINGLEWIDOW
  NOCHILDREN
  AGEGTR65
---*/

/*--- CREATE STATS NEEDED BY OPTIMALBIN --*/
proc sql;
 select mean(response) into :lgs_avgrsp separated by '' from lgs.lgs_rawtrain;
 select count(*)      into  :lgs_cntrec separated by '' from lgs.lgs_rawtrain;
;quit;
%put the overall response is &lgs_avgrsp -- total records are &lgs_cntrec;

/*******************************************************************/
/*  the overall response is 0.014929 -- total records are 70000    */
/*******************************************************************/

/**************************************************************************************************************************/
/*  You need to work through this application manually. Logistic regression is a bit of an art and                        */
/*  you have to make decision at several places in the code                                                               */
/**************************************************************************************************************************/

/*--- WRAPPER MACRO CALL TO OUTPUT WINDOW ---*/

data _null_;
  length cmd $96;
  file print;

  set sashelp.vcolumn(where=(
   libname = 'LGS'         and
   type    = 'num'        and
   memname = 'LGS_RAWHOLD' and
   name not in ('ZIP9','SELECTED','RESPONSE')));

   cmd=cats('%lgs_bucketn(',name,');');
   put cmd;

run;quit;

/*---
You need this information to better design the number of buckets  (from above)

 Variable              Unique Values
--------               -------------

ZIP9          char           100,000

ACSADULTS     char                 6
ACSGENDER     char                 3
ACSMARRIED    char                 5
AGE           char                42
AGEGTR65      num                  2
CENINCOME     num              1,376
CHILDREN      char                 2
DEBITCARD     char                 2
DIVISION      char                10
DIVISIONCDE   char                10
DWELLING      char                 2
HHINCOME      char                 9
HOMES         num                 40
HOMEVAL       char                19
HOMEYEAR      num                 72
HOMEYRS       char                17

INCOME        num             63,932
RENT          num             29,714
INTEREST      num             70,296
INCOM_USED    num             32,428


LOADHOME      num                 19
LOAN2VAL      char                11
LOANS         num                552
NOCHILDREN    num                  2
OCUPASHN      char                25
OWNHOME       num                 11
PURYER        num                 72
REGION        char                 5
REGIONCDE     char                 5
RESPONSE      num                  2
RETAILCARD    char                 2
SINGLEWIDOW   num                  2

MANUALLY CUT FROM OUTPUT WINDOW

NUMERIC BINNING

%lgs_bucketn(INCOME);
%lgs_bucketn(RENT);
%lgs_bucketn(INTEREST);
%lgs_bucketn(INCOM_USED);
%lgs_bucketn(SPENT);
%lgs_bucketn(CENINCOME);
%lgs_bucketn(HOMES);
%lgs_bucketn(PERYEAR);
%lgs_bucketn(LOANHOME);

%lgs_bucketn(SINGLEWIDOW,numbin=3);
%lgs_bucketn(OWNHOME,numbin3);
%lgs_bucketn(NOCHILDREN,numbin=3);
%lgs_bucketn(AGEGTR65,numbin=3);
---*/

data lgs_mkemor ;
  set lgs.lgs_rawtrain(keep=&numvar zip9n response);
run;

/*--- set up an empty dataset to add optimin bins output to ---*/
/*--- place for appened results ---*/
* make empty dataset;
data lgs_all;
 if _n_=0 then output;;
 length zip9n 8  response  8 var $32 val 8 newval 8.;
run;
/*--- cut and paste macro calls from output window here     ---*/

/*--- 5 bins or less ---*/
%lgs_bucketn(INCOME);
%lgs_bucketn(RENT);
%lgs_bucketn(INTEREST);
%lgs_bucketn(INCOM_USED);
%lgs_bucketn(SPENT);
%lgs_bucketn(CENINCOME);
%lgs_bucketn(HOMES);
%lgs_bucketn(PURYER);
%lgs_bucketn(LOANHOME);

/*--- 3 buckets or less ---*/
%lgs_bucketn(SINGLEWIDOW,numbuk=3);
%lgs_bucketn(OWNHOME,numbuk=3);
%lgs_bucketn(AGEGTR65,numbuk=3);


data lgs.lgs_mgmMkeNum;
  set lgs_mkemor;
  array und _:;
  do over und;
    und = und/&lgs_avgRsp; /*--- odds ratio ---*/
  end;
run;

/*---  MANUALALLY CHECK LOG               ---*/
/*---  CHECK TO SEE THAT ALL NUMS WORKED  ---*/

%let lgs_udrvar=%sysfunc(tranwrd(&numvar,%str( ),%str( _)));
%put &lgs_udrvar;

data lgs_nrmNum/view=lgs_nrmnum;
  set lgs_all;
  newval=newval/&lgs_avgRsp; /*--- odds ratio ---*/
run;

proc sort data=lgs_nrmnum out=lgs.lgs_mgmNrmNumSrt (label="Normalized index input for character variables");
by var newval val;
run;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/*---

data x ;
set lgs.lgs_mgmMkeNum(where=(zip9n=330193725));
run;quit;

TWO TABLES

----------------------------------------------------
1. TABLE: LGS.LGS_MGMMKENUM OBS=70,000 30 VARUABLES
--------------------------------------------------

13 NUMERIC VARIABLES and 13 MATCHING VARIABLES WITH ODDS RATIOS GROUPINGS

FOR EACH NUMERIC VARIABLE AN ADDITIONAL NUMERIC VARIABLE WITH THE SAME NAME BUT UNDERLINED
IS CREATED. THE UNDERLINED VARIABLES CONTAIN THE BIN LEVEL WHICH IS THE ODDS RATIO
FOR THE BIN.


   -- NUMERIC --

  ZIP9N                            N6       330193725
  RESPONSE                         N3               0

  INCOME                           N8         1777.48
  RENT                             N8           41745
  INTEREST                         N8       852674.76
  INCOM_USED                       N8         88873.8
  SPENT                            N5          278300
  HOMES                            N3               1
  CENINCOME                        N4           56500
  OWNHOME                          N3               .
  LOANHOME                         N4          237500
  PURYER                           N3            2000
  SINGLEWIDOW                      N3               0
  NOCHILDREN                       N3               0
  AGEGTR65                         N3               0

  MAPPED TO GROUPED BY ODDS RATIOS

  _INCOME                          N8    0.0669856461   >>>> ADDED NUMERIC VARIABLES
  _RENT                            N8    0.5358851685        CONVERTED TO BINNED NUMERIC ODD RATIOS
  _INTEREST                        N8    0.5358851685
  _INCOM_USED                      N8    0.6698564606
  _SPENT                           N8    0.5358851685
  _CENINCOME                       N8     1.071770337
  _HOMES                           N8    1.0047846909
  _PURYER                          N8    1.6076555055
  _LOANHOME                        N8    0.7368421067
  _SINGLEWIDOW                     N8    1.0047846909
  _OWNHOME                         N8    1.0047846909
  _NOCHILDREN                      N8    0.9377990449
  _AGEGTR65                        N8    0.8708133988

Proc means data=lgs.lgs_mgmmkenum min max;
  class _puryer;;
  var puryer;
run;quit;

       Analysis Variable : PURYER

 ODDS
 RATIO       YEARS RANGES
_PURYER  Minimum - Maximum  N Obs
------------------------------------
 0.011   2007.00 - 2010.00  43589   MOST RECENT PURCHASE YEAR HAVE LEAST BENTLEYS

 0.017   2003.00 - 2006.00   6656

 0.018   1992.00 - 1997.00   6261

 0.024   1900.00 - 2002.00  13494  OLDEST HAVE
------------------------------------


-------------------------------------------------------------
2. TABLE: lgs.lgs_mgmNrmNumSrt (NORMALIZED LGS.LGS_MGMMKENUM)
910,000 OBSERVATIONS 13*70,000
I better data structure for exploarory analysis
-------------------------------------------------------------

                                                            ODDS
             ZIP9N     RESPONSE      VAR             VAL     NEWVAL

1          10011550        0       AGEGTR65           0     0.87081
2          10012118        0       AGEGTR65           0     0.87081
3          10012327        0       AGEGTR65           0     0.87081
4          10012602        0       AGEGTR65           0     0.87081
5          10012920        0       AGEGTR65           0     0.87081
...
...
909996    240540000        1       SPENT    14199100.00     4.35407
909997     64307340        0       SPENT    15198534.00     4.35407
909998    941174225        1       SPENT    17298904.00     4.35407
909999    140479651        0       SPENT    19532274.00     4.35407
910000    210143428        0       SPENT    24274231.00     4.35407



---*/

/*___                                              _                            _
 / _ \   _ __  _   _ _ __ ___     _____  _____ ___| | _ __ ___ _ __   ___  _ __| |_
| (_) | | `_ \| | | | `_ ` _ \   / _ \ \/ / __/ _ \ || `__/ _ \ `_ \ / _ \| `__| __|
 \__, | | | | | |_| | | | | | | |  __/>  < (_|  __/ || | |  __/ |_) | (_) | |  | |_
   /_/  |_| |_|\__,_|_| |_| |_|  \___/_/\_\___\___|_||_|  \___| .__/ \___/|_|   \__|
                                                              |_|
## 9 num excel report
*/

%utlfkil(d:/lgs/xls/lgs_MgmNumCut.xlsx);

libname lgs "d:/lgs";

proc delete data=lgs_mgmRolNum lgs.lgs_mgmRolNum lgs_chisq
  lgs_chisqr1st lgs_chisq lgs_two lgs.lgs_MgmNumCut;
run;quit;

ods listing;
proc sql;
 select mean(response) into :lgs_avgrsp separated by '' from lgs.lgs_rawtrain;
 select count(*)     into :lgs_cntrec separated by '' from lgs.lgs_rawtrain
;quit;
%put the overall response is &lgs_avgrsp -- total records are &lgs_cntrec;

options missing='?';

data lgs_mgmrolnum;
   retain rnk grp var responders nonresponders total newval index percentresponse;
   keep rnk grp var responders nonresponders total newval index percentresponse;
   label
      rnk             =  "Response#Rank from#Low to High"
      responders      =  "Responders"
      nonresponders   =  "Non-Responders"
      total           =  "Total"
      coverage        =  "Percent#Coverage"
      var             =  "Variable"
      newval          =  "Response Rate"
      index           =  "Index#Response Rate#divided by#Overall &lgs_avgrsp "
      grp             =  "Levels with#similar giving"
      percentresponse =  "Percent who#Responded#$1,000 or more";
  retain min 1e300 max -1e300;
  do until (last.newval);
    set lgs.lgs_mgmnrmnumsrt;
    by var newval val;
    if first.var then rnk=0;
    if first.newval then do;
      rsp    =0;
      non    =0;
      rspmis =0;
      nonmis =0;
      min    = 1e300;
      max    =-1e300;
    end;
    if not missing(val) then do;
       rsp+(response=1);
       non+(response=0);
       if val<min then min=val;
       if val>max then max=val;
    end;
    else do;
       gotmis=1;
       rspmis+(response=1);
       nonmis+(response=0);
    end;
  end;
  responders    = sum(rsp,rspmis);
  nonresponders = sum(non,nonmis);
  total  = responders + nonresponders;
  if min=1e300  then min=.;
  if max=-1e300 then max=.;
  if not(missing(min)) and gotmis then led='?,';else led='';
  grp=cats(led,put(min,best.),'<=',var,'<=',put(max,best.));
  rnk+1;
  coverage=cats(put(100*total/&lgs_cntrec,6.2),'%');
  index=(responders/total)/&lgs_avgrsp;
  percentresponse=cats(put(100*(responders/total),8.2),'%');
run;

* for numeric variables add the means for each bucket;
proc sql;
  create
    table lgs.lgs_mgmrolnum as
  select
    l.*
   ,r.avgval
  from
    lgs_mgmrolnum as l left join (
       select var, newval, avg(val) as avgval from lgs.lgs_mgmnrmnumsrt group by var, newval ) as r
  on
    l.var      = r.var    and
    l.newval   = r.newval
;quit;

%utlopts;
/* build table */
data lgs_chisqr1st;
  keep var grp rsp cnt newval;
  set lgs.lgs_mgmrolnum;
  rsp=1;
  cnt=responders;
  output;
  rsp=0;
  cnt=nonresponders;
  output;
run;

ods output chisq=lgs_chisq (where=( statistic in ('Chi-Square', 'Mantel-Haenszel Chi-Square')));
proc freq data=lgs_chisqr1st;
by var;
tables newval*rsp/chisq list;
weight cnt;
run;

proc sql;
  create
    table lgs_two as
  select
    l.var
   ,case
      when (l.df=1) then catx(' ','Chi-Square=',put(l.value,best.),'P-Value=',put(l.prob,9.5))
      else               catx(' ','Chi-Square=',put(r.value,best.),'P-Value=',put(r.prob,9.5))
    end as Pvl
  from
    lgs_chisq as l, lgs_chisq as r
  where
    l.var = r.var                  and
    l.statistic in ('Chi-Square')  and
    r.statistic in ('Mantel-Haenszel Chi-Square')
;quit;

data lgs.lgs_MgmNumCut;
 retain oneval 1 Rnk GRP VAR RESPONDERS NONRESPONDERS TOTAL NEWVAL INDEX PERCENTRESPONSE;
 label
    rnk             =  "Response#Decile from#Low to High"
    responders      =  "Responders"
    nonresponders   =  "Non-Responders#All Others"
    total           =  "Total"
    coverage        =  "Percent#Coverage"
    var             =  "Variable"
    newval          =  "Response Rate"
    index           =  "Index#Response Rate#divided by#Overall %sysevalf(100*&lgs_avgrsp)"
    grp             =  "Levels with#similar giving"
    pvl             =  "Chi-Square"
    percentresponse =  "Percent";
  merge lgs.lgs_mgmrolnum lgs_two;
  by var;
  if first.var then rnk=0;
  rnk+1;
  coverage=cats(put(100*total/&lgs_cntrec,6.2),'%');
run;

%utlfkil(d:/lgs/xls/lgs_MgmNumCut.xlsx);


ods listing close;
ods escapechar='~';
ods excel file="d:/lgs/xls/lgs_MgmNumCut.xlsx";
ods  excel
        options(                     /* column widths in points */
        suppress_bylines           = 'no'
        embedded_titles            = 'no'
        gridlines                  = 'yes'
        sheet_interval             = "none"
        sheet_name                 = "chrcut"
        frozen_headers             = 'Yes'
        absolute_column_width      =  "10,30,34,14,14,10,12,12,12"
        autofit_height             = 'yes'
        width_fudge                = "0.67"
        width_points               = "9"
        frozen_rowheaders          = 'no' );

title;footnote;
proc report data=lgs.lgs_MgmNumCut nowd missing split='#'  style=[protectspecialchars=off];
cols rnk pvl var grp  responders nonresponders total coverage index percentresponse ;
define  pvl              / order    noprint order=data;
define  var              / order    "Variable" order=data                                ;
define  rnk              / display "Bentley#Response#Bin from#Low to High"  order=data        ;
define  grp              / display "Levels with similar Bentley#Percent"  style(column)={asis=on tagattr='wrap:yes'};
define  responders       / sum     "At Least#Bentley#Responders"                ;
define  nonresponders    / sum     "No#Bentleys"                  ;
define  total            / sum     "Total#In Bin"                                   ;
define  coverage         / display "Percent#Coverage#Bin Total#/70000"  right style={just=r}   ;
define  index            / display "Odds#Bentley Rate#divided by#%sysfunc(compbl(Overall %sysevalf(100*&lgs_avgrsp)%))";
define  percentresponse  / display "Percent#Bentley"  right style={just=r};
break before var /  skip ;
compute before var / style={just=l font_weight=bold};
line "    ";
line  pvl $96.;
endcomp;
break after pvl / summarize skip ;
run;quit;
ods excel close;
ods listing;

proc print data=lgs.lgs_MgmNumCut(drop=pvl) heading=vertical;
run;quit;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/*---
Table lgs.lgs_MgmNumCut  (alos in excel file)
                                                                                   P
                                                                                   E
                                                      O                            C
                                                      N                            E
                                                R     R                            N
                                                E     E                            T
                                                S     S                            R     C
                                                P     P                            E     O
 O                                              O     O             N              S     V         A
 N                                              N     N      T      E       I      P     E         V
 E                                              D     D      O      W       N      O     R         G
 V R                   G                 V      E     E      T      V       D      N     A         V
 A N                   R                 A      R     R      A      A       E      S     G         A
 L K                   P                 R      S     S      L      L       X      E     E         L

 1 1    0<=AGEGTR65<=0              AGEGTR65   816  62365  63181  0.013  0.86514 1.29% 90.26%       0.00
 1 3    1<=AGEGTR65<=1              AGEGTR65   229   6590   6819  0.034  2.24955 3.36% 9.74%        1.00

 1 1    0<=CENINCOME<=33200         CENINCOME   28   3991   4019  0.007  0.46668 0.70% 5.74%    27540.38
 1 3    ?,33300<=CENINCOME<=40000   CENINCOME  381  33593  33974  0.011  0.75121 1.12% 48.53%   36662.24
 1 4    40100<=CENINCOME<=56500     CENINCOME  189  11816  12005  0.016  1.05458 1.57% 17.15%   48383.42
 1 5    56600<=CENINCOME<=87900     CENINCOME  333  15696  16029  0.021  1.39162 2.08% 22.90%   69118.89
 1 6    88000<=CENINCOME<=200000    CENINCOME  114   3859   3973  0.029  1.92206 2.87% 5.68%   107003.88
 ...
---*/

/*  ___      _       _              _
/ |/ _ \    (_) ___ (_)_ __     ___| |__   __ _ _ __   _ __  _   _ _ __ ___
| | | | |   | |/ _ \| | `_ \   / __| `_ \ / _` | `__| | `_ \| | | | `_ ` _ \
| | |_| |   | | (_) | | | | | | (__| | | | (_| | |    | | | | |_| | | | | | |
|_|\___/   _/ |\___/|_|_| |_|  \___|_| |_|\__,_|_|    |_| |_|\__,_|_| |_| |_|
          |__/
*/

libname lgs "d:/lgs";

proc delete data=lgs.lgs_MgmAllChrNum;
run;quit;

options missing='.';
proc sort
  data=lgs.lgs_rawtrain
  out=lgs.lgs_rawtrainsrt   ;
by zip9n;
run;

data lgs.lgs_MgmAllChrNum (label="Data with groupings ready for logistic");
   retain zip9n response;
   merge
    lgs.lgs_mgmmkechr (keep=zip9n _:)
    lgs.lgs_mgmmkenum (keep=zip9n _:)
    lgs.lgs_rawtrainsrt;
   by zip9n;
run;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/*---
  Middle Observation(350000 ) of table = lgs.lgs_mgmallchrnum- Total Obs 70,000 07DEC2025:13:58:22

  DIMENSION VARIABLES

  ZIP9N                N6    330193725  Primary Key
  RESPONSE             N3    0          0/1 zip9n has at least one Bentley
  SELECTED             N8    0          Always 0 is selected Training Sample

   -- CHARACTER --

  Variable            Typ    Value

  MARRIED              C1    S
  DWELLING             C1    S
  HHINCOME             C21   $100,000 - $124,999
  HOMEYRS              C16   10 YEARS
  OCUPASHN             C41   ?
  AGE                  C15   24 - 25
  ACSMARRIED           C16   MARRIED
  ACSGENDER            C6    MALE
  ACSADULTS            C21   4
  CHILDREN             C1    Y
  RETAILCARD           C39   ?
  DEBITCARD            C39   ?
  REGIONCDE            C5    3
  DIVISIONCDE          C5    5
  INCOME               N8    1777.48
  RENT                 N8    41745
  INTEREST             N8    852674.76
  INCOM_USED           N8    88873.8
  SPENT                N5    278300
  HOMES                N3    1
  CENINCOME            N4    56500
  OWNHOME              N3    .
  LOANHOME             N4    237500
  PURYER               N3    2000
  SINGLEWIDOW          N3    0
  NOCHILDREN           N3    0
  AGEGTR65             N3    0

   -- NUMERIC --   (bins of odds ratios) - odds ratio is just percent in bin/pverall response)

  _MARRIED             N8    0.5358851685
  _DWELLING            N8    1.2057416291
  _HHINCOME            N8    1.5406698594
  _HOMEYRS             N8    1.4736842133
  _OCUPASHN            N8    0.8038277527
  _AGE                 N8    0.0669856461
  _ACSMARRIED          N8    1.3397129212
  _ACSGENDER           N8    1.7416267976
  _ACSADULTS           N8    1.2727272752
  _CHILDREN            N8    1.138755983
  _RETAILCARD          N8    0.8708133988
  _DEBITCARD           N8    0.8038277527
  _REGIONCDE           N8    1.071770337
  _DIVISIONCDE         N8    1.138755983
  _INCOME              N8    0.0669856461
  _RENT                N8    0.5358851685
  _INTEREST            N8    0.5358851685
  _INCOM_USED          N8    0.6698564606
  _SPENT               N8    0.5358851685
  _CENINCOME           N8    1.071770337
  _HOMES               N8    1.0047846909
  _PURYER              N8    1.6076555055
  _LOANHOME            N8    0.7368421067
  _SINGLEWIDOW         N8    1.0047846909
  _OWNHOME             N8    1.0047846909
  _NOCHILDREN          N8    0.9377990449
  _AGEGTR65            N8    0.8708133988

---*/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
