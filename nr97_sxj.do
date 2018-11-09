clear
set more off

cd "E:\博士\农学院\应用计量I\作业\Sachs and Warner_1997"
use "nr97.dta"

*检查缺失值
sum
mdesc gea7090 lgdpea70 sxp sopen linv7089 rl dtt7090
mi set mlong
mi misstable summarize gea7090 lgdpea70 sxp sopen linv7089 rl dtt7090
mi misstable patterns gea7090 lgdpea70 sxp sopen linv7089 rl dtt7090   

mdesc gea7090 sxp    
mi set mlong
mi misstable summarize gea7090  sxp
mi misstable patterns gea7090 sxp 

*画图看是否有outlier，即figure1
scatter gea7090 sxp if sxp!=.& gea7090!=.,mlabel(country) ylabel(minmax)  xlabel(minmax) title("growth and natural resource intensity")
scatter gea7090 sxp if sxp!=.& gea7090!=.,ylabel(minmax)  xlabel(minmax) msymbol(oh) title("growth and natural resource intensity")

*检查outlier
fit gea7090 lgdpea70 sxp sopen    //同reg
drop dfits    
fpredict dfits, dfits    //同predict dfits, dfits
gsort -dfits
* list country dfits shcode6 if dfits~=.
drop excl1       
generate excl1=0
replace excl1=1 if abs(dfits)>2*sqrt(4/91) 
list country dfits if dfits~=. & excl1==1
*若用leverage的方法
reg gea7090 lgdpea70 sxp sopen
predict lev,leverage
stem lev  
hilo lev country,show(5) high   
display (2*3+2)/91
list country lev if lev>.879 & lev~=.  
*若用Cook’s D的方法
reg gea7090 lgdpea70 sxp sopen
predict d,cooksd
list country d if d>4/91 & d~=.   
sum d 
*若用abs(DFBETA)的方法
reg gea7090 lgdpea70 sxp sopen 
dfbeta 
scatter _dfbeta_1 _dfbeta_2 _dfbeta_3 ,  yline(.2096 -.2096) mlabel(country country country)  
list _dfbeta_3 country if [abs(_dfbeta_1) > .2096  | abs(_dfbeta_2) > .2096 ]& _dfbeta_3~=.


*** Basic regressions without excluding the outliers
fit gea7090 lgdpea70 sxp
fit gea7090 lgdpea70 sxp sopen
fit gea7090 lgdpea70 sxp sopen linv7089
fit gea7090 lgdpea70 sxp sopen linv7089 rl
fit gea7090 lgdpea70 sxp sopen linv7089 rl dtt7090

*** Table I
fit gea7090 lgdpea70 sxp if excl1==0 
est store tab1_1
fit gea7090 lgdpea70 sxp sopen if excl1==0 
est store tab1_2
fit gea7090 lgdpea70 sxp sopen linv7089 if excl1==0 
est store tab1_3
fit gea7090 lgdpea70 sxp sopen linv7089 rl if excl1==0 
est store tab1_4
fit gea7090 lgdpea70 sxp sopen linv7089 rl dtt7090 if excl1==0 
est store tab1_5

outreg2 [tab1_*] using "第二次作业 申雪婧/table1.doc", title(Table I Partial Assosiatioins between Grotwth(1970-90) and Natural Resource Intensity) stats(coef tstat) bdec(2) tdec(2) replace

*** regression for footnote 18, confirming that controling for
*** growth in the 1960's doesn't vitiate the estimated sxp effect.

fit gea7090 lgdpea70 sxp sopen linv7089 rl dtt7090 gr6070 if excl1==0


*** Table III 
fit gea7090 lgdpea70 sxp   sopen linv7089 rl dtt7090
est store tab3_1
fit gea7090 lgdpea70 snr   sopen linv7089 rl dtt7090
est store tab3_2
fit gea7090 lgdpea70 pxi70 sopen linv7089 rl dtt7090
est store tab3_3
fit gea7090 lgdpea70 land  sopen linv7089 rl dtt7090
est store tab3_4
outreg2 [tab3_*] using "第二次作业 申雪婧/table3.doc", title(Table III Assosiatioins between Grotwth and Resource Intensity Using Alternative Mesures of Resource Intensity) stats(coef tstat) bdec(2) tdec(2) replace

*** Table IV 

fit gea7090 lgdpea70 sec70 pri70 gvxdxe revcoup assassp ppi70dev inv7089
est store tab4_1
fit gea7090 sxp sopen dtt7090 lgdpea70 sec70 pri70 gvxdxe revcoup assassp ppi70dev inv7089
est store tab4_2
outreg2 [tab4_*] using "第二次作业 申雪婧\table4.doc", title(Table IV Estimation of Barro [1991] with Variables from This Paper) stats(coef tstat) bdec(2) tdec(2) replace


***Table V 

fit gea7090 lgdpea70 kllsec klLLY70
est store tab5_1
fit gea7090 sxp sopen dtt7090 lgdpea70 kllsec klLLY70
est store tab5_2
outreg2 [tab5_*] using "第二次作业 申雪婧\table5.doc", title(Table V Estimation of King and Levine [1993] with Variables from This Paper) stats(coef tstat) bdec(2) tdec(2) replace



*** Table VI 

fit gea7090 lgdpea70 gp7090 inv7089
est store tab6_1
fit gea7090 sxp sopen dtt7090 lgdpea70 gp7090 inv7089
est store tab6_2
outreg2 [tab6_*] using "第二次作业 申雪婧\table6.doc", title(Table VI Estimation of Mankiw, Romer and Weil [1992] with Variables from This Paper) stats(coef tstat) bdec(2) tdec(2) replace



*** Table VII 

fit gea7090 lgdpea70 lfg equip nes
est store tab7_1
fit gea7090 sxp sopen dtt7090 lgdpea70 lfg equip nes
est store tab7_2
outreg2 [tab7_*] using "第二次作业 申雪婧\table7.doc", title(Table VII Estimation of DeLong and Summers [1991] with Variables from This Paper) stats(coef tstat) bdec(2) tdec(2) replace



*** Table VIII 

fit dmx7090 sxp sopen smx70
est store tab8_1
fit gnr7090 sxp sopen lgdpea70 linv7089 rl    //原code的自变量之一是lgdpnr7，这里改成lgdpea70
est store tab8_2
fit servs70 sxp
est store tab8_3
outreg2 [tab8_*] using "第二次作业 申雪婧\table8.doc", title(Table VIII Assosiatioins between Natural Resource Abundance and Secroral Data) stats(coef tstat) bdec(2) tdec(2) replace


*** Table IX 

fit gea7080 lgdpea70 sxp sopen7 dtt7080 linv7079
est store tab9_1
fit gea8090 lgdpea80 sxp80 sopen8 dtt8090 linv8089 rl
est store tab9_2
outreg2 [tab9_*] using "第二次作业 申雪婧\table9.doc", title(Table IX Estimated Growth Regressions for the Decades of the 1970s and 1980s seperately) stats(coef tstat) bdec(2) tdec(2) replace


*** Table X 

fit ns7089 lgdpea70 sxp
est store tab10_1
fit linv7089 sxp sopen rl lpip70
est store tab10_2
fit dtyr7090 lgdpea70 sxp
est store tab10_3
fit sopen sxp sxp2 land
est store tab10_4
fit lpip70 lgdpea70 sxp sopen
est store tab10_5
outreg2 [tab10_*] using "第二次作业 申雪婧\table10.doc", title(Table X Associations between Natural Resource Abundance and Other Explanatory Variables) stats(coef tstat) bdec(2) tdec(2) replace


*** Table XI 

fit grc  lgdpea80 sxp
est store tab11_1
fit re   lgdpea80 sxp
est store tab11_2
fit corr lgdpea80 sxp
est store tab11_3
fit rl   lgdpea80 sxp
est store tab11_4
fit bq   lgdpea80 sxp
est store tab11_5
outreg2 [tab11_*] using "第二次作业 申雪婧\table11.doc", title(Table XI Associations between Quality of Institutions and Natural Resource Intensity) stats(coef tstat) bdec(2) tdec(2) replace
