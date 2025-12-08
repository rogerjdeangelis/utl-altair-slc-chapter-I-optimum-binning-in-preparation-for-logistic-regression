****   *****  *   *  *   *  *   *   ***;

%macro slc_optimalbin
(tla=ucs,lib=ftftft,set=ftftft,target=ftftft,varinl=ftftft,
   pre=lll,weight=.,key=.,rank=no,nranks=10,merge=no,method=free,
   alpha=.05,mis1=.,mis2=.,mis3=.,round=.001,sel=(1=1),
   mincl=2,maxcl=10,history=no,addvar=no,typevar=dum,
   combcl=yes,corr=no,r2crit=.,cnval=40,libtemp=work);

/********************************************************************
Macro:                                  Optibin
Language:                               Base SAS, SAS Graph (Version 8e)
Programmer:                             Roger DeAngelis & Clemens van Brunschot


General description: a SAS macro for dummification or linearisation of
nominal, ordinal or continuous predictor variables. In linearisation
the dataset is augmented with a variable where (ranges of) original
values of a predictor variable (bins) are replaced by mean values
on a target variable. The result is a linear relationship between the
new predictor variable and the target variable. In this macro this is
done after merging (bins of) original values using a chi square test.
This merging is aimed at bivariately optimising the relation between
the predictor and a target variable. In dummification a dummy variable
(0,1) is created for each of the resulting bins.
The original predictor values are optionally ranked into quantiles at
the start of the process. A weight variable is allowed (however, not
used for ranking nor for the chi square test). And a set of missing
values on the predictor may be defined.
The process is controlled by a number of parameters declared in the
macro invocation. Parameters are either obligatory or there is a
default available. The process may be applied to a selection of the
dataset. There is an option for printing iteration information.
A graph is produced for a visual inspection of the variable created.
The process ends in a print of information that shows the relationship
between the original and the created predictor. This print should also
be used to write out the model built with the linearised variables.
If desirable, a set of dummy variables instead of one linearised
variable is produced. (One from a set of dummy variables will have to
be left out of predictive modelling.)
More than 1 predictor at a time can easily be handled, as long as they
require the same parameter setting. However, the merging of bins is
done bivariately with the target variable. Use AUTOLOG (programmed by
Piet de Koster at ING Group, Netherlands) if you wish to produce a
model based on dummy variables created in a MULTIvariate setting.

Current restrictions:
- SAS 8 or higher (for large datasets in a fast installation)
- character predictors are allowed with these parameter restrictions:
                        - parameters RANK and METHOD are automatically set to
                          'no' and 'free', respectively;
                        - parameters for missing values are ignored;
                        - no value '.' allowed in predictor;
Note: The merging process is inefficient in case of many bins.
Therefore, with continuous variables, always use the ranking option.

How can the OPTIBIN macro be used?
For direct input of bins to predictive modelling (with bin merging):
a.      Automatic production of linearised variables.
b.      Automatic production of dummy variables (one per bin). This
        has the advantage that the (bivariately produced) bins may
        receive different coefficients in (multivariate) predictive
        modelling.
c.      More careful production of linearised or dummy variables, e.g.
        one predictor at a time.
In hybrid approaches:
d.      (with bin merging:) Producing linearised bin variables -->
        subjecting them to CHAID --> producing interaction dummy variables.
e.      (without bin merging:) Producing unmerged linearised bin
        variables --> subjecting them to principal components analysis
        --> feeding (a selection of) the components to modelling.
        (This is the original suggestion by Dr. Peter Furness).

Macro invocation (example):
        %let macroloc=C:\Programs\SAS macros;
        libname dataloc v7 'C:\Datalokaal\Diversen';
        %include "&macroloc.\Optibin.sas";
        %optibin(lib=dataloc,set=c1,libtemp=dataloc,
                target=bad12,pre=ddd,weight=.,key=idid,
                varinl=v003 v008 v040-v042 v033 v089 v090,
                merge=yes,method=float,typevar=dum,rank=yes,
                mis1=9999999,mis2=999999,mis3=9999,
                addvar=yes,combcl=yes,history=no,
                nranks=25,mincl=2,maxcl=20,alpha=.05,round=.001,
                corr=yes,r2crit=.,cnval=40);
Notes:
-       Gather these %optibin macro invocations (for each set of
        predictors) in one program file for later reconstruction.
-       Because the bins will be different when using new data, you
        should not apply the macro to a validation/test dataset. Rather,
        write out the final predictive model (using the output provided)
        and apply that to the validation/test dataset. Please adapt the
        minima/maxima of original predictors in the bins to
        accomodate new values in new data.
-       When writng out a predictive model based on linearised variables
        multiply the model coefficients with the bin levels.
-       To prevent dataset pollution run the macro with ADDVAR=NO first.
-       MAKE SURE THAT THE DATASET IS IN A SAS VERSION 7 or higher
        LIBRARY (WHERE DATASETS HAVE .SAS7BDAT EXTENSIONS).

Parameter description (in alphabetical order):
        Notes:
        -       all non-obligatory parameters have a default value.
        -       USE ONLY undercase IN SPECIFYING THE PARAMETERS.
        -       The default can easily be changed in the first macro statement.
ADDVAR (default=NO): should produced variable be added to dataset?
        Note: domain is YES, NO.

ALPHA (default=.05): critical p(chi square) value for leaving two
        bins unmerged.

CNVAL (default=40): max. number of different values allowed for
        the combination of METHOD=ORD/FLOAT, RANK=NO, MERGE=NO.

        Note: if exceeded, MERGE and RANK will be set to YES.
COMBCL (default=YES): Should merged bins be merged when printing
        minima and maxima of original predictor in produced bins?
        Note: domain is YES, NO.

CORR (default=NO): print Pearson correlation of lin. predictor and target
        Note: can (as R square) be used as criterion for writing variables.

HISTORY (default=NO): print iteration history?
        Note: domain is YES, NO.

KEY: ID field with unique values.
        Note: If omitted or KEY=. a field IDID will be added to the dataset.
        This takes time, so do not let this happen in each invocation.

LIB (obligatory): name of SAS library.
        Note: refers to libname assigned before invocation.

LIBTEMP (default=work): libname for temporary dataset 'excerpt'.
        Note: should be already assigned. If non-default, slows macro down.
MAXCL (default=10): maximum number of final bins allowed.

MERGE (default=YES): merge bins (ranges, quantiles) of predictor?
        Note: domain is YES, NO.

METHOD (default=FREE): method used for merge of bins.
        Note: only in effect when MERGE=YES. Domain:
        FREE for nominal (categorical) variables.
        ORD for ordinal/continuous variables where missing values are to be
                merged with the lowest bin.
        FLOAT for ordinal/continuous variables where missing values may be
                merged with any other bin.

MINCL (default=2): minimum number of final bins allowed.
        Note: only in effect when MERGE=YES.

MIS1/MIS2/MIS3: extra missing value for predictor.
        Note: missing value . is added automatically.
        Ignored in case of character predictor.

NRANKS (default=10): number of quantiles to be produced.

PRE (default=lll): prefix for to-be-created variables.
        Note: will be put before predictor name.

R2CRIT (by default not active): minimum R square as a criterion for
        writing produced variables to dataset.
        Note: R2CRIT is a percentage (e.g. 1.50).

RANK (default=NO): rank predictor in quantiles?
        Note: has no direct consequences for predictor in dataset.
        With character predictor or METHOD=FREE automatically NO.

ROUND (default=.001): decimal for rounding proportion in linearised
        variable.

SEL (default=none): selection used for reading/writing in dataset.
        Note: enclose by parentheses!

SET (obligatory): name of dataset.  Note: no extension needed.

TARGET (obligatory): name of target variable.  Note: a numeric 0/1 variable.

TYPEVAR (default=LIN): Type of variable(s) to be created.
        Note: domain is LIN (a linearised variable), DUM (dummy variables).

VARINL (obligatory): variable list of predictors.
        Note: see 'Current restrictions' above.

WEIGHT: name of weight variable.
        Note: if omitted or WEIGHT=., weights of 1 will be applied.
        Not used for ranking nor chi square test. May contain decimals.

********************************************************************/
*** Step 1: Initialisation and input checking ***;
        options label nocenter /* mprint mlogic symbolgen spool */;
        %let release=1F;
        * Memory;
        %let m_merge=&merge; %let m_rank=&rank;
        %if &lib=ftftft or &set=ftftft or &target=ftftft or
                "&varinl"="ftftft" or &mincl>&maxcl or &mincl<2 or
                not %sysfunc(exist(&lib..&set)) %then %do;
                %put >>>>>>>>>> Error. Incorrect macro invocation;
                %goto error;
        %end;
        %if &syscharwidth^=1 %then %do; * Just check SAS release;
                %put >>>>>>>>>> Error. Use SAS release 8 or higher;
                %goto error;
        %end;
        %if &weight=. %then %let weigh=weight; %else %let weigh=&weight;
        * Are there central variables missing? What type are variables?;
 
        %let dsid=%sysfunc(open(&lib..&set,i));
                %let tar_n=%sysfunc(varnum(&dsid,&target));
                %if &key^=. %then %let key_n=%sysfunc(varnum(&dsid,&key));
                %else %let key_n=999;
                %if &tar_n=0 or &key_n=0 %then %do;
                        %put >>>>>>>>>> Error. Missing variables dsid=&dsid target=&tar_n key=&key_n;
                        %goto error;
                %end;
                %let tar_type=%sysfunc(vartype(&dsid,&tar_n));
        %let rc=%sysfunc(close(&dsid));
 

        %*let tar_type=N;

        %if &tar_type^=N %then %do;
                %put >>>>>>>>>> Error. Target variable not numeric;
                %goto error;
        %end;
        %let pre=%upcase(&pre);
        * Determine predictor variables;
        %let nvar=0;
        data work.vars;
                set &lib..&set(keep=&varinl obs=1);
                array inp{*} &varinl;
                call symput('nvar',dim(inp));
        run;
        %if &nvar=0 %then %goto error;
        %let writeok=0; %let dropvar= ;
* Per variable now, in the order of the dataset;
%do ivar=1 %to &nvar;
        * Restore parameter memory; %let merge=&m_merge; %let rank=&m_rank;
        %let dsid=%sysfunc(open(vars,i));
        * Pick up predictor characteristics;
                %let varin=%sysfunc(varname(&dsid,&ivar));
                %let in_type=%sysfunc(vartype(&dsid,&ivar));
                %let in_lab=%bquote(%sysfunc(varlabel(&dsid,&ivar)));
        %let rc=%sysfunc(close(&dsid));
        %if &in_lab= %then %let in_lab=&varin;
        %let varout=&pre.&varin;
        %if &in_type=C %then %do;
                %let method=free;
                %let mis1=9876543210123456789; %let mis2=&mis1; %let mis3=&mis1;
        %end;
        %let varx=&varin; %let foutchar=0; %let fouttar=0;
        %let r2ok=1; %let stop=1;
        %let m_mis=9876543210123456789; * In case there is no missing value;
        %let finish=no; %let m_n=0; %let m_freq=.; %let maxp=.; %let maxi=.;
        %if &method=free %then %let rank=no;
        title1 "&varin " %if &in_lab^=&varin %then %do; "(&in_lab)" %end; ;
        title3;
        %put >>>>>>>>>>>>>>>>>>>>> Working on predictor: &varin;

*** Step 2: Data extraction and some extra checks ***;
        * Add key variable if necessary;
        %if &ivar=1 %then %do;
                %if &key=. %then %do;
                        %let key=idid;
                        data &lib..&set;
                                set &lib..&set;
                                &key=_n_;
                        run;
                %end;
                proc sort data=&lib..&set;
                        by &key;
                data &libtemp..excerpt(keep=&target &varinl &key
                        %if &weight^=. %then %do;
                                &weight
                        %end;
                        );
                        set &lib..&set(where=&sel);
                        if &target^=.;
                run;
        %end;
        proc sort data=&libtemp..excerpt;
                by &varin;
        proc sort data=&libtemp..excerpt(keep=&varin) out=work.diffval nodupkey;
                by &varin;
        data _null_;
                set diffval end=last;
                if last then call symput('ndiff',_n_);
        run;
        %if &method^=free & &merge=no & rank=no & &ndiff>&cnval %then %do;
                %let merge=yes; %let rank=yes;
        %end;
        title2 "Optibin macro (&release): &varin becomes &varout;
   rank=&rank(&nranks), method=&method, merge=&merge(&alpha)";
        data work.tweevar;
                set &libtemp..excerpt(drop=&key);
                %if &weight=. %then %do;
                        weight=1;
                %end;
                * Replace missing values in numeric predictor;
                %if &in_type=N %then %do;
                        if &varin in(&mis1 &mis2 &mis3) then &varin=.;
                %end;
                %else %do;
                        * Check on value '.' of character predictor;
                        if &varin='.' then call symput('foutchar',1);
                %end;
                * Is the target variable a (0,1) variable?;
                if &target not in(0,1) then call symput('fouttar',1);
        run;
        %if &foutchar=1 %then %do;
                %put >>>>>>>>>> Error. Predictor contains a '.';
                %goto loop;
        %end;
        %if &fouttar=1 %then %do;
                %put >>>>>>>>>> Error. Target variable not a (0,1) variable;
                %goto error;
        %end;

*** Step 3: Ranking continuous variables ***;
*** Not using weight information yet     ***;
        %if &rank=yes %then %do;
                proc rank data=tweevar out=rankvar groups=&nranks;
                        var &varin;
                        ranks R&varin;
                proc datasets library=work details nolist;
                        delete tweevar;
                        change rankvar=tweevar;
                run;
        %end;

*** Step 4: Computing means, using weight variable ***;
        %if &rank=yes %then %do;
                %let varx=r&varin;
                proc sort data=tweevar;
                        by r&varin;
                run;
        %end;
        proc means data=tweevar missing mean nway noprint;
                var &target;
                by &varx;
                weight &weigh;
                output out=work.means1 mean=&varout sumwgt=nwgt;
/* rjd 3/5/2011
        proc datasets library=work nolist;
                modify means1;
                label &varout="&pre %trim(%left(&in_lab))"
                                nwgt="Weighed N";
        run; quit;
        %if &history=yes %then %do;
                title3 "Iteration info";
                proc print data=means1 noobs;
        %end;
*/
                data _null_;
                        set means1 end=last;
                        if last & _n_ >= &mincl then call symput('stop',0);
                run;
        %if &stop=1 %then %do;
                data _null_;
                        file print;
                        put "&varin: variable(s) NOT written to dataset due to number of bins";
                        file log;
                run;
                %put >>>>>>>>>> Error. Too little different values in predictor;
                %goto loop;
        %end;

*** Step 5: Merging bins according to &method ***;
        %if &merge=yes %then %do;
                %if &method=free %then %do;
                        proc sort data=means1;
                                by &varout;
                        run;
                %end;
                %else %if &method=ord %then %do;
                        * No action needed. Missings are already first;
                %end;
                %else %if &method=float %then %do;
                        * Missings to be placed near most alike bin;
                        data means1;
                                set means1;
                                if &varx=. then do;
                                        call symput('m_freq',_freq_);
                                        call symput('m_val',&varout);
                                        call symput('m_wgt',nwgt);
                                        delete; * To be moved;
                                end;
                        run;
                        %if &m_freq=. %then %goto nomiss;
                        data _null_;
                                set means1 end=last;
                                retain mindiff(9999999999) nmin(0);
                                if abs(&varout-&m_val)<mindiff then do;
                                        nmin=_n_;
                                        mindiff=abs(&varout-&m_val);
                                end;
                                if last then call symput ('m_nmin',nmin);
                        data means1;
                                set means1;
                                output;
                                * The moved record;
                                if _n_=&m_nmin then do;
                                        &varx=.;
                                        _freq_=&m_freq;
                                        &varout=&m_val;
                                        nwgt=&m_wgt;
                                        output;
                                end;
                        run;
                %nomiss: ;
                %end;
                %if &history=yes %then %do;
                        proc print data=means1(drop=_type_) noobs;
                        run;
                %end;
      * Now start iterating;
                data collaps /* removed rjd 15oct2010 (keep=was is) */;
                run;
                %do %while (&finish=no) ;
                        * Find the bin which is closest to the previous one (by chi2);
                        data means1(drop=n1p n2p sumn pchi2 maxpchi2 imax);
                                set means1 end=last;
                                retain n1p n2p maxpchi2 imax;
                                if _n_=1 then do;
                                        n1=_freq_*&varout; n2=_freq_-n1;
                n1p=n1; n2p=n2; * p stands for previous;
                                end;
                                else do;
                                        n1=_freq_*&varout;
                                        n2=_freq_-n1;
                                        sumn=n1p+n2p+n1+n2;
                                        if sumn>0 then do; * e stands for expected;
                                                n1pe=(n1p+n1)*(n1p+n2p)/sumn;
                                                n1e= (n1p+n1)*(n1+n2)  /sumn;
                                                n2pe=(n2p+n2)*(n1p+n2p)/sumn;
                                                n2e= (n2p+n2)*(n1+n2)  /sumn;
                                                if n1pe>0 & n1e>0 & n2pe>0 & n2e>0 then do;
                                                        chi2=((n1p-n1pe)**2)/n1pe + ((n1-n1e)**2)/n1e +
                                                             ((n2p-n2pe)**2)/n2pe + ((n2-n2e)**2)/n2e;
                                                        pchi2=1-cdf('chisquare',chi2,1);
                                                end;
                                        end;
                                        if pchi2=. & _n_>1 then pch2=2; * First merge bins with 0-margin;
                                        else pch2=pchi2;
                                        if _n_>1 & pch2>=maxpchi2 then do;
                                                maxpchi2=pch2;
                                                imax=_n_;
                                        end;
                        n1p=n1; n2p=n2;
                                end;
                                if (last & maxpchi2<=&alpha &
                                        &mincl<=_n_<=&maxcl) then call symput('finish','yes');
                                else if last then do;
                                        call symput('maxp',maxpchi2);
                                        call symput('maxi',imax);
                                        call symput('m_n',_n_);
                                end;
                        run;
                        %put finish=&finish maxp=%left(&maxp) max=%left(&maxi)
                                m_n=%left(&m_n) mincl=%left(&mincl) maxcl=%left(&maxcl);
                        %if &finish=no & &m_n=&mincl %then %do;
                                title3 "Process stopped (there were %left(&m_n) categories left)";
                                proc print data=means1 noobs;
                                run;
                                %put >>>>>>>>>> Linearisation not feasible for &varin;
                                %goto loop;
                        %end;
                        %if &history=yes %then %do;
                                proc print data=means1 noobs;
                                run;
                        %end;
                        %if (&finish=no and &maxp>.) %then %do;
                                %* Collapse bin &maxi with bin &maxi-1;
                                %* Retain collapsed bin id;
                                data means1(keep=&varx &varout _freq_ n1 nwgt) collnew(keep=was is);
                                        set means1(keep=_freq_ n1 &varx &varout nwgt);
                                        retain nprev nwprev n1prev n1wprev was;
                                        select;
                                                when(_n_=&maxi-1) do;
                                                        nprev=_freq_;
                                                        nwprev=nwgt; * Weighed;
                                                        n1prev=n1;
                                                        n1wprev=nwgt*&varout; * Weighed;
                                                        was=&varx;
                                                        call symput('m_was',was);
                                                        * This bin is dropped;
                                                end;
                                                when(_n_=&maxi) do;
                                                        _freq_=_freq_+nprev;
                                                        &varout=(n1wprev+nwgt*&varout)/(nwgt+nwprev);
                                                        nwgt=nwgt+nwprev;
                                                        output means1;
                                                        is=&varx;
                                                        call symput('m_is',is);
                                                        output collnew;
                                                end;
                                                otherwise output means1;
                                        end;
                                run;
                                %if &history=yes %then %do;
                                        proc print data=means1 noobs;
                                        run;
                                %end;
                                * Merge collapsed bin infos;
                                data collaps;
                                        set collaps(in=old) collnew;
                                        if was=is then delete;
                                        %if &in_type=N %then %do;
                                                if old & is=&m_was then is=&m_is;
                                        %end;
                                        %else %if &in_type=C %then %do;
                                                if old & is="&m_was" then is="&m_is";
                                        %end;
                                run;
                                %if &history=yes %then %do;
                                        proc print data=collaps noobs;
                                        run;
                                %end;
                        %end; %* End of iteration;
                %end; %* End of all iterations;
                * Gather results;
                %if &maxp>. %then %do;
                        proc sort data=means1(keep=&varx &varout nwgt);
                                by &varx;
                        proc sort data=collaps(keep=was is);
                                by is;
                        data meancoll;
                                merge collaps(in=inc rename=(is=&varx)) means1;
                                by &varx;
                                if inc;
                        proc sort data=meancoll(drop=&varx);
                                by was;
                        data means1(drop=nwgt);
                                set means1 meancoll(rename=(was=&varx));
                        proc sort data=means1;
                        by &varx;
                        run;
                %end; %* End of gathering results;
        %end; %* End of merge;
        %if (&finish=yes) %then %do;
                proc print data=means1 noobs;
                run;
        %end;
/*
*** Step 6: Graph ***;
        title3 "Graph for visual inspection of &varout (excl. missing)";
        goptions device=win ctext=blue graphrc interpol=join;
                pattern1 color=blue value=solid;
                symbol1 c=black i=join w=2 v=none;
                axis1 color=blue width=2.0;
        proc gplot data=means1;
                plot &varout * &varx /haxis=axis1 vaxis=axis1 frame areas=1 nolastarea;
        run;
*/

*** Step 7: Substituting means for original predictor ***;
        * Adapt &varout to facilitate min/max;
        %if &method^=free %then %do;
                proc sort data =means1;
                        by &varout;
                data means1(drop=plus previous);
                        set means1;
                        retain plus(2e-11) previous;
                        if _n_=1 then previous=&varout;
                        else if &varout=previous then do;
                                previous=&varout;
                                &varout=&varout+plus;
                                plus+(2e-11);
                        end;
                        else previous=&varout;
                proc sort data=means1;
                        by &varx;
                run;
        %end;
        proc sort data=means1;  * roger deangelis;
                by &varx;
        run;
        data _null_;
                set means1;
                %if &in_type=N %then %do;
                        if &varx=. then call symput('m_mis',&varout);
                %end;
        data tweevar(keep=&varin &varout);
                merge tweevar means1;
                by &varx;
        proc sort data=tweevar(rename=(&varin=varind)) nodupkey;
                by varind;
        data &libtemp..excerpt(drop=&varout);
                set &libtemp..excerpt;
                varind=&varin;
                %if &in_type=N %then %do;
                        if varind in(. &mis1 &mis2 &mis3) then varind=.;
                %end;
        proc sort data=&libtemp..excerpt;
                by varind;
        data &libtemp..excerpt(drop=temp varind);
                merge &libtemp..excerpt tweevar(rename=(&varout=temp));
                by varind;
                &varout=temp;
                %if in_type=N %then %do;
                        if &target=. then &varout=.;
                        else if &varin in(. &mis1 &mis2 &mis3) then
                                &varout=&m_mis;
                %end;
                %if &method=free %then %do;
                        &varout=round(&varout,&round);
                %end;
        proc sort data=&libtemp..excerpt;
                by &varin;
        run;

*** Step 8: Documentation for specifying the final model ***;
        %if &method=free %then %do;
                title3 "Values of &varin by &varout";
                proc freq data=&libtemp..excerpt(where=(&varout^=.));
                        tables &varin * &varout /missing list nocum nopercent;
                        %if &weight^=. %then %do;
                                weight &weight;
                        %end;
                data &libtemp..excerpt;
                        set &libtemp..excerpt(where=(&target^=.));
                run;
        %end;
        %else %do;
                title3 "Min and Max &varin (excl. missing values) by &varout :";
                proc means data=&libtemp..excerpt
                        (where=(&target^=. & &varin not in(. &mis1 &mis2 &mis3)))
                                missing min max nway noprint;
                        var &varin;
                        class &varout;
                        %if &weight^=. %then %do;
                                weight &weight;
                        %end;
                        output out=work.means2 min=min max=max n=n
                                %if &weight^=. %then %do;
                                        sumwgt=nwgt;
                                %end;
                                ;
                proc sort data=means2(drop=_freq_ _type_);
                        by min;
                data means2;
                        set means2;
                        &varout=round(&varout,&round);
                        format min max;
                %if &combcl=yes %then %do;
                        data means2(keep=min max &varout n
                                %if &weight^=. %then %do;
                                        nwgt
                                %end;
                                );
                                set means2;
                                by &varout notsorted;
                                retain minprev nprev nwprev;
                                if first.&varout then do;
                                        minprev=min;
                                        nprev=n;
                                        nwprev=nwgt;
                                end;
                                else do;
                                        nprev+n;
                                        nwprev+nwgt;
                                end;
                                if last.&varout then do;
                                        min=minprev;
                                        n=nprev;
                                        nwgt=nwprev;
                                        output;
                                end;
                        run;
                %end;
                proc print data=means2 noobs;
                        var min max &varout n
                        %if &weight^=. %then %do;
                                nwgt
                        %end;
                        ;
                data &libtemp..excerpt;
                        set &libtemp..excerpt;
                        &varout=round(&varout,&round);
                        if &target ne .;
                title3 "Missing value set consists of :";
                proc freq data=&libtemp..excerpt
                                (where=(&varin in(. &mis1 &mis2 &mis3)));
                        tables &varin * &varout /missing list nopercent;
                        %if &weight^=. %then %do;
                                weight &weight;
                        %end;
                run;
        %end;
        * Extra job: determine number of bins;
        data means1;
                set means1(keep=&varout);
                &varout=round(&varout,&round);
        proc sort data=means1(keep=&varout) nodupkey;
                by &varout;
        data _null_;
                set means1 end=last;
                if last then call symput('nbin',_n_);
        run;

*** Step 9: Production of dummy variables ***;
        %if &typevar=dum %then %do;
                title3 "Production of dummy variables";
                data _null;
                        call symput('len',round(log10(1/&round)));
                run;
                %if &len<1 or &len>6 %then %do;
                        %put >>>>>>>>>> Error. Your ROUND parameter is not OK;
                        %goto error;
                %end;
                %do i=1 %to &nbin;
                        data _null_;
                                length temp $&len;
                                set means1;
                                if _n_=&i then do;
                                        temp=left(round(&varout/&round));
                                        temp=translate(right(temp),"0"," ");
                                        call symput("d&i",temp);
                                end;
                        run;
                %end;
                data &libtemp..excerpt;
                        set &libtemp..excerpt;
                        %do i=1 %to &nbin;
                                if &varout^=. then do;
                                        &varout._&&d&i=(round(&varout/&round)=&&d&i);
                                end;
                        %end;
                proc datasets library=&libtemp nolist;
                        modify excerpt;
                        label
                                %do i=1 %to &nbin;
                                        &varout._&&d&i="&pre %trim(%left(&in_lab)) &&d&i"
                                %end;
                        ;
                        run; quit;
                proc freq data=&libtemp..excerpt;
                        tables (
                        %do i=1 %to &nbin;
                                &varout._&&d&i
                        %end;
                        ) * &target /nopercent nocol;
                        %if &weight^=. %then %do;
                                weight &weigh;
                        %end;
                run;
        %end;

*** Step 10: Correlation coefficient ***;
        %if &corr=yes %then %do;
                title3 "Correlation coefficient";
                %let r2ok=0;
                proc corr data=&libtemp..excerpt outp=outp noprint;
                        var &target &varout;
                        %if &weight^=. %then %do;
                                weight &weigh;
                        %end;
                proc print data=outp noobs;
                data _null_;
                        set outp end=last;
                        if last then do;
                                r2=100*&target**2;
                                if r2^=. & r2>=&r2crit then call symput('r2ok',1);
                        end;
                run;
                title3;
        %end;

*** Step 11: Bins in the excerpt file ***;
        data _null_;
                file print;
                %if &r2ok=1 %then %do;
                %let writeok=1; put;
                        *put "Available for writing to dataset (for overview list see LOG!!!) :"; put;
                        %if &typevar=lin %then %do;
                                *put "&nbin bins in 1 variable &varout (from %trim(%left(&in_lab)))";
                        %end;
                        %else %if &typevar=dum %then %do;
                                put "&nbin dummies :";
                                %do i=1 %to &nbin;
                                        put "           &varout._&&d&i (from %trim(%left(&in_lab)))";
                                %end;
                        %end;
                %end;
                %else %do;
                        put "&varin: variable(s) NOT available due to R2 criterion";
                %end;
                file log;
        run;
        * Drop waste from the excerpt file;
        %if &addvar=no or (&addvar=yes & &r2ok^=1) %then %do;
                data &libtemp..excerpt(drop=&varout
                        %if &typevar=dum %then %do i=1 %to &nbin;
                                &varout._&&d&i
                        %end;
                        );
                        set &libtemp..excerpt;
                run;
        %end;
        %else %if &typevar=dum %then %let dropvar=&dropvar &varout;

%loop: ; * Go to next variable;
%end;

*** Step 12: Writing to original dataset ***;
        %if &addvar=yes & &ivar>=&nvar & &writeok=1 %then %do;
                data work.contents;
                        set &libtemp..excerpt(obs=1 drop=&target &key &varinl &dropvar
                                %if &weight^=. %then %do;
                                        &weight
                                %end;
                                );
                run;
                %let dsid=%sysfunc(open(contents,i));
                        %let nvars=%sysfunc(attrn(&dsid,nvars));
                        %let varia= ;
                        %do i=1 %to &nvars;
                                %let varia=&varia %sysfunc(varname(&dsid,&i));
                        %end;
                        %put All variables written to dataset:; %put &varia;
                %let rc=%sysfunc(close(&dsid));
                proc sort data=&libtemp..excerpt(drop=&target &varinl &dropvar
                        %if &weight^=. %then %do;
                                &weigh
                        %end;
                        );
                        by &key;
                data &lib..&set;
                        merge &lib..&set(in=in1) &libtemp..excerpt;
                        by &key;
                        if in1;
                run;
                * normalize;
/*
                %let pre=_;
                %let varinl=certificated_alum;
*/
                data ucs_add(keep=&key &target var val newval);
                   set &lib..&set(keep=&varinl &target &key &pre.&varinl);
                   length var newvar $32;
                   var=vname(&varinl);
                   val=&varinl;
                   newval=&pre.&varinl;
                run;
                proc append base=&tla._all data=ucs_add force;
                run;
        %end;

%error: ; * Stop macro execution;
title1; title2; title3;
%mend slc_optimalbin;

