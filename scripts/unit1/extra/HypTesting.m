%[text] %[text:anchor:H_43C69F2F] ## Hypothesis Testing
%[text] Parametric Testing is only relevant for defined Probability curves (like normal curves). Nonparametric testing is used for data with distributions that are not normal (non-parametric). 
%[text] In this exercise, we will learn to identify distributions that are likely non-parametric (like skewed distributions). Then we will perform some nonparametric hypothesis testing. 
%[text] %[text:anchor:H_A8209FE0] - RULE \#1: Know if you're data is Normally distributed or not. That will help you determine what stats to used.
%[text] - RULE \#2: n. If your n\>30, then you can probably just use a Parametric Test. But, if your n is low, then you should probably be using a non-parametric test.  \
%%
%[text] %[text:anchor:H_AEB697D7] ### Test for Normality
%[text] The Anderson-Darling test is a distribution test. It tests the null hypothesis that your data has a normal distribution. The alternative hypothesis is that your data does not have a normal distributions
%[text] Results:
%[text] - H = 0: your data is normal
%[text] - H = 1: your data is not normal \
[h,p] = adtest(right.x)
%[text] - This result indicates that our data is not normal \
%%
%[text] %[text:anchor:H_27FC3630] ### Mann-Whitney U-Test (2-sample, t-test equivalent)
%[text] [https://www.estimationstats.com/\#/analyze/two-independent-groups](https://www.estimationstats.com/#/analyze/two-independent-groups) 
%[text] [https://www.technologynetworks.com/informatics/articles/mann-whitney-u-test-assumptions-and-example-363425](https://www.technologynetworks.com/informatics/articles/mann-whitney-u-test-assumptions-and-example-363425) 
%[text] [Website](https://www.technologynetworks.com/informatics/articles/mann-whitney-u-test-assumptions-and-example-363425)
%[text] Key assumptions for Mann-Whitney U Test :
%[text] - The variable being compared between the two groups must be **continuous** (able to take any number in a range – for example age, weight, height or heart rate). This is because the test is based on ranking the observations in each group.
%[text] - The data are assumed to take a **non-Normal**, or skewed, distribution. If your data are normally distributed, the unpaired Student’s t-test should be used to compare the two groups instead.
%[text] - While the data in both groups are not assumed to be Normal, the data are assumed to be **similar in shape** across the two groups.
%[text] - The data should be two randomly selected **independent** samples, meaning the groups have no relationship to each other. If samples are paired (for example, two measurements from the same group of participants), then a paired samples t-test should be used instead.
%[text] - Sufficient **sample size** is needed for a valid test, usually more than 5 observations in each group. \
%%
%[text] %[text:anchor:H_8462CEEF] ### Example: Made-up data
%[text] Consider a randomized controlled trial evaluating a new anti-retroviral therapy for HIV. A pilot trial randomly assigned participants to either the treated or untreated groups (N=14). 
ViralLoad = [3000 1100 800 540 670 1000 960 1200 4650 4200 3500 4200 1300 900 7400 3250 7500 3001 2500 6000]';
Treatment = categorical([repmat("Treated",10, 1); repmat("Untreated",10, 1)]);
T = table(ViralLoad,Treatment)
%[text] - We want to assess the viral load (quantity of virus per milliliter of blood) in the treated versus the untreated groups. \
%%
ViralLoad = [421.48 590.56 33.951 611.54 250.16 25.658 81.605 197.9 789.6 837.31  1685.9 2362.2  135.8 2446.2 1000.6 102.63 326.42  791.6 3158.4 3349.2]';
Treatment = categorical([repmat("Treated",10, 1); repmat("Untreated",10, 1)]);
T = table(ViralLoad,Treatment)
%%
%[text] %[text:anchor:H_BA53FCD4] ### Visualization
%[text] Review the distribution
%[text] %[text:anchor:H_59F3F0D1] #### Histogram
figure(visible = "on",WindowStyle="docked")
tiledlayout("horizontal")
x = T.ViralLoad(T.Treatment=="Treated");
y = T.ViralLoad(T.Treatment=="Untreated");

nexttile
histogram(x,10,FaceAlpha=0.35)
hold on
histogram(y,30,FaceAlpha=0.25)
legend("Treated","Untreated")
xlabel("Viral Load")
%%
%[text] %[text:anchor:H_C9F80E59] ### swarm charts
nexttile
hold on

swarmchart(T,"Treatment","ViralLoad","filled",MarkerFaceColor='k',MarkerFaceAlpha=0.75)

colors = orderedcolors("gem"); % default color scheme
colororder(gca,colors([1 1 2],:)); % match color order in histogram (swarmchart messes up order)
boxchart(T.Treatment,T.ViralLoad,"GroupByColor",T.Treatment,"ColorGroupLayout","overlaid")

sgtitle("Non-normal Distribution")
% colormap("abyss")


%%
%[text] %[text:anchor:H_E40D803C] ### Statistics
%[text] Test for Normalacy
[h,p] = adtest(T.ViralLoad)
%[text] - h = 1 means that the dataset is not normal so you should not use Parametric tests (like a t-test) \
%%
%[text] %[text:anchor:H_EDBC07BE] #### summary stats
%[text] For non-parametric data, you report median and interquartile range and calculate a ranksum
%[text] - Here we see that the treated group had a lower median Viral load than the untreated group.  \
%%
%[text] %[text:anchor:H_E3D184F2] #### Hypothesis testing:  Mann-Whitney U-test
%[text] To see how likely this difference in medians is, we run a U-test (also called a ranksum test)
x = T.ViralLoad(T.Treatment=="Treated");
y = T.ViralLoad(T.Treatment=="Untreated"); 

[p,h, stats] = ranksum(x,y)
%%
%[text] %[text:anchor:H_BCA13CDC] #### Report your results
%[text] How to report Mann-Whitney U tests: U-tests described [here](https://guides.library.lincoln.ac.uk/c.php?g=110730&p=4638042).
groupsummary(T,"Treatment",["median","range"]);

s = sprintf('The treated group had a significantly lower viral load than the untreated group,\n');
s = sprintf('%smedian=%1.2f vs %1.2f, respectively,',s,  median(x), median(y));
fprintf('%s as indicated by a Mann-Whitney U-test, U(Nleft=%d, Nright=%d)=%1.2f,z=%1.2f, p=%0.3f.',...
    s,...
    numel(x),...
    numel(y),...
    stats.ranksum,...
    stats.zval, ...
    p)
%[text] 
%%
%[text] %[text:anchor:H_708963E2] ### Estimate Statistics
%[text] Estimate statistics are a counterpart to t-tests. Importantly, they accept nonparametrically distribute data: [https://www.estimationstats.com/\#/user-guide/two-independent-groups](https://www.estimationstats.com/#/user-guide/two-independent-groups) 
%[text] In their words:
%[text] To replace this outmoded method, estimation uses a *separate but aligned axes* to show the experimental intervention’s effect size. In addition, this plot presents the effect size as a *bootstrap 95% confidence interval* (95% CI) to the right of the raw data, with the mean of the test group aligned with the effect size. 
%[text] [](https://www.estimationstats.com/#/analyze/two-independent-groups)
clf;

effect = meanEffectSize(x,y,"Effect","mediandiff")
hl = gardnerAltmanPlot(x,y,Effect="mediandiff");
%[text] - The fact that the two medians do not overlap in the confidence interval (demarcated by the yellow zone) indicates a significance \
%%
%[text] %[text:anchor:H_E7B2962C] #### Plugging your data into the website
%[text] [https://www.estimationstats.com/\#/analyze/two-independent-groups](https://www.estimationstats.com/#/analyze/two-independent-groups) 
x = T.ViralLoad(T.Treatment=="Untreated")
y = T.ViralLoad(T.Treatment=="Treated")

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
