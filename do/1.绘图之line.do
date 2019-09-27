
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*==============================
* 绘图之line
*==============================

sysuse uslifeexp, clear  //美国预期寿命的数据
d                        //Describe data in memory or file

line le le_male le_female le_w le_wmale le_wfemale le_b le_bmale le_bfemale year

line le* year             //默认模式相当丑


*================
* 改造
*================
#delimit ;
	twoway line le* year,
		title("美国预期寿命")  					// 增加标题
		subtitle("1900-1999年")  				// 副标题
		xlabel(, grid)                          // x轴标签设置
		ylabel(20(10)80, grid)					// y轴标签设置
		xtitle("年份")							// x轴标题
		ytitle("预期寿命")						// y轴标题
		legend(label(1 "平均") label(2 "男性")
			   label(3 "女性") label(4 "白人")
			   label(5 "白人男性") label(6 "白人女性")
			   label(7 "黑人") label(8 "黑人男性")
			   label(9 "黑人女性")				// 添加图例标签
			   rows(3) ring(0) position(5) 		// 将图例设置为3行
			   symxsize(*0.5) size(*0.8))		// 添加图例大小
		scheme(tufte)        					// 设置风格为s1color
	;
#delimit cr


/*
 s2color     color        white       factory setting
 s2mono      monochrome   white       s2color in monochrome
 s2gcolor    color        white       used in the Stata manuals
 s2manual    monochrome   white       s2gcolor in monochrome
 s2gmanual   monochrome   white       previously used in the [G] manual


 s1rcolor    color        black       a plain look on black background
 s1color     color        white       a plain look
 s1mono      monochrome   white       a plain look in monochrome
 s1manual    monochrome   white       s1mono but smaller

 economist   color        white       The Economist magazine
 sj      
*/

