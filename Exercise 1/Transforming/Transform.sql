DROP TABLE CLEANTECH;
CREATE TABLE cleanTECH AS SELECT 
SUBSTR(HOSPITALNAME, 2, LENGTH(HOSPITALNAME) - 2) AS HOSPITALNAME,
SUBSTR(SCORE, 2, LENGTH(SCORE) - 2) AS SCORE
FROM TECH;

DROP TABLE CLEANCONVTECH;
CREATE TABLE cleanConvTECH AS SELECT HOSPITALNAME, CAST(SCORE AS DECIMAL) AS SCOREDEC FROM CLEANTECH;

DROP TABLE CLEANCONVFILTEREDTECH;
CREATE TABLE cleanConvFilteredTECH AS SELECT HOSPITALNAME, SCOREDEC FROM cleanConvTECH WHERE SCOREDEC is not NULL;

DROP TABLE TECHANALYSIS;
CREATE TABLE TECHAnalysis AS SELECT HOSPITALNAME, SUM(SCOREDEC) AS SUMSCORE, AVG(SCOREDEC) AS AVGSCORE, VARIANCE(SCOREDEC) AS VARSCORE FROM cleanConvFilteredTECH GROUP BY HOSPITALNAME;

CREATE TABLE TECSANALYSIS AS SELECT STATE, SCORE FROM TECS;

CREATE TABLE CLEANTECS AS SELECT
SUBSTR(STATE, 2, LENGTH(STATE) - 2) AS STATE,
SUBSTR(SCORE, 2, LENGTH(SCORE) - 2) AS SCORE
FROM TECS;

CREATE TABLE cleanConvTECS AS SELECT STATE, CAST(SCORE AS DECIMAL) AS SCOREDEC FROM CLEANTECS;

CREATE TABLE cleanConvFilteredTECS AS SELECT STATE, SCOREDEC FROM cleanConvTECS WHERE SCOREDEC is not NULL;

CREATE TABLE TECSSTATS AS SELECT STATE, SUM(SCOREDEC) AS SUMSCORE, AVG(SCOREDEC) AS AVGSCORE, VARIANCE(SCOREDEC) AS VARSCORE FROM cleanConvFILTEREDTECS GROUP BY STATE;

CREATE TABLE CLEANVARPROC AS SELECT 
SUBSTR(MEASUREID, 2, LENGTH(MEASUREID) - 2) AS MEASUREID,
SUBSTR(MEASURENAME, 2, LENGTH(MEASURENAME) - 2) AS MEASURENAME,
SUBSTR(SCORE, 2, LENGTH(SCORE) - 2) AS SCORE
FROM TECH;

CREATE TABLE cleanConvVARPROC AS SELECT MEASUREID, MEASURENAME, CAST(SCORE AS DECIMAL) AS SCOREDEC FROM CLEANVARPROC;

CREATE TABLE cleanConvFilteredVARPROC AS SELECT MEASUREID, MEASURENAME, SCOREDEC FROM cleanConvVARPROC WHERE SCOREDEC is not NULL;

CREATE TABLE VARPROCSTATS AS SELECT MEASUREID, MEASURENAME, SUM(SCOREDEC) AS SUMSCORE, AVG(SCOREDEC) AS AVGSCORE, VARIANCE(SCOREDEC) AS VARSCORE FROM cleanConvFilteredVARPROC GROUP BY MEASUREID, MEASURENAME HAVING AVGSCORE > 20;

drop table hospsurvey;
CREATE TABLE HospSurvey AS SELECT SUBSTR(HOSPITALNAME, 2, LENGTH(HOSPITALNAME)-2) HOSPITALNAME, SUBSTR(HCAHPSBASE, 2, LENGTH(HCAHPSBASE)-2) AS SURVEYBASE FROM SURVEY;

drop table hospsurveycast;
CREATE TABLE HOSPSURVEYCAST AS SELECT HOSPITALNAME, CAST(SURVEYBASE AS DECIMAL) AS SURVEYBASE FROM HOSPSURVEY;

drop table qualitysurveyjoin;
CREATE TABLE QualitySurveyJoin AS SELECT HOSPSURVEYCAST.HOSPITALNAME, AVGSCORE, SURVEYBASE FROM TECHAnalysis INNER JOIN HOSPSURVEYCAST ON TECHAnalysis.HOSPITALNAME == HOSPSURVEYCAST.HOSPITALNAME;

CREATE TABLE QUALITYSURVEYJOINCORR AS SELECT CORR(AVGSCORE, SURVEYBASE) AS SCORECORR FROM QUALITYSURVEYJOIN;