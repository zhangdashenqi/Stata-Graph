
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************


* 数据处理

import excel "机构退出列表.xls", sheet("许可证情况导出") firstrow clear
	
gen year = yofd(date(批准成立日期, "YMD")) 		// 银行分支机构成立年份
gen quit_year = yofd(date(发生日期, "YMD"))  	// 银行分支机构退出年份
gen age = quit_year - year + 1 					// 存续时间，年龄


replace 省份 = "福建" if 省份 == "厦门" 		// 修正部分数据
replace 省份 = "辽宁" if 省份 == "大连"
replace 省份 = "浙江" if 省份 == "宁波"
replace 省份 = "山东" if 省份 == "青岛"
replace 省份 = "广东" if 省份 == "深圳"


* 按省份统计
collapse (count) banknum = 流水号 (mean) age = age, by(省份)
rename 省份 prov

save bank.dta, replace

* 地图
cap mkdir china_map
cd china_map

copy "http://fmwww.bc.edu/repec/bocode/c/china_map.zip" china_map.zip, replace
unzipfile china_map, replace  // 解压压缩文件

doedit map_example.do

use china_label,clear
br
gen x = uniform()
format x %9.3g
spmap x using "china_map.dta", /// 
  id(id) label(label(ename) xcoord(x_coord) ycoord(y_coord) size(*.66))

use china_map.dta, clear
scatter _Y _X, msize(vtiny)

use china_map.dta, clear
scatter _Y _X if _ID==1, msize(tiny)

* 浙江省 31-38

scatter _Y _X if _ID>=31 & _ID<=38, msize(tiny)

// use china_label.dta, clear
//
// clear
// unicode encoding set gb18030
// unicode translate china_label.dta

use china_label.dta, clear
gen prov = ustrregexra(name, "省|市|维吾尔|回族|壮族|自治区|特别行政区", "")
save china_prov.dta, replace


use bank.dta, clear
merge 1:m prov using china_prov.dta
list if _merge==2  // 列示没有合并的数据


* 绘制地图

spmap banknum using "china_map.dta", id(id) 

** 添加标题
spmap banknum using "china_map.dta", id(id) 		///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))

/*
spmap banknum using "china_map.dta", id(id) 		///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(region(lcolor(black))) 
	
spmap banknum using "china_map.dta", id(id) 		///
	ndfcolor(red) 									///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(region(lcolor(black))) 
	
	
spmap banknum using "china_map.dta", id(id) 		///
	clmethod(eqint) clnumber(5) eirange(20 70)      ///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(region(lcolor(black)))
	
	
spmap banknum using "china_map.dta", id(id) 		///
	clnumber(5) fcolor(Reds2) ocolor(none ..)  		/// 
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(region(lcolor(black)))
*/

/*
图例
legstyle():
	0: 无标签
	1：数值区间，(20,35]
	2：数值区间，20 - 35
	3：第一个和最后一个值有标签
*/


spmap banknum using "china_map.dta", id(id) 		///
	clnumber(10) fcolor(Reds2) ocolor(none ..)  	/// 
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 

/*
fcolor():
	Blues
	Blues2
	Greens
	Greens2
	Greys
	Greys2
	Reds
	Reds2
*/
	
spmap banknum using "china_map.dta", id(id) 		///
	clnumber(10) fcolor(Reds2) ocolor(none ..)  	/// 
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 

	
/*
spmap banknum using "china_map.dta", id(id) 		///
	clnumber(5) fcolor(Reds2) ocolor(none ..)  		/// 
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 		///
	plotregion(margin(vlarge))
*/

** 背景颜色	
	
spmap banknum using "china_map.dta", id(id) 		///
	clnumber(10) fcolor(Reds2) ocolor(none ..)  	/// 
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 		///
	plotregion(icolor(navy*0.2)) 					///
	graphregion(icolor(navy*0.2))
	
/*
* 附加其他图形

spmap banknum using "china_map.dta", id(id) 		///
	clnumber(5) fcolor(Reds2) ocolor(none ..)  		///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 		///
	plotregion(icolor(stone)) 						///
	graphregion(icolor(stone))						///
	polygon(data("chinarail_co.dta") ocolor(black))	///
	line(data("chinarail_co.dta") color(blue))
*/


* 标签

spmap banknum using "china_map.dta", id(id) 		///
	clnumber(10) fcolor(Reds2) ocolor(none ..)  	///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 		///
	plotregion(icolor(gs15)) 						///
	graphregion(icolor(gs15))						///
	label(label(prov) xcoord(x_coord) 				///
		  ycoord(y_coord))


* 比例尺
	
spmap banknum using "china_map.dta", id(id) 		///
	clnumber(10) fcolor(Reds2) ocolor(none ..)  	///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 		///
	plotregion(icolor(gs15)) 						///
	graphregion(icolor(gs15))						///
	label(label(prov) xcoord(x_coord) 				///
		  ycoord(y_coord)) 							///
	scalebar(units(500) scale(1.2) 					///
			 xpos(100) ypos(-100) label(100公里))
	
*= 附加统计图形

/*
spmap banknum using "china_map.dta", id(id) 		///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	diagram(variable(banknum) range(0 100)          ///
        xcoord(x_coord) ycoord(y_coord) fcolor(navy))
*/

label var banknum "退出机构数量"
label var age "退出机构的平均年龄"

spmap banknum using "china_map.dta", id(id) 		///
	clnumber(10) fcolor(Reds2) ocolor(none ..)  	///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 		///
	plotregion(icolor(gs15)) 						///
	graphregion(icolor(gs15))						///
	scalebar(units(500) scale(1.2) 					///
			 xpos(100) ypos(-100) label(100公里))	///
	diagram(variable(age) legenda(on) 				///
			fcolor(navy) xcoord(x_coord) ycoord(y_coord))

format age %02.0f
spmap age using "china_map.dta", id(id) 			///
	clnumber(10) fcolor(Blues2) ocolor(none ..)  	///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 		///
	plotregion(icolor(gs15)) 						///
	graphregion(icolor(gs15))						///
	scalebar(units(500) scale(1.2) 					///
			 xpos(100) ypos(-100) label(100公里))	///
	diagram(variable(banknum) legenda(on) 			///
			fcolor(green) xcoord(x_coord) ycoord(y_coord))


format age %02.0f
gen bankbefore = int(banknum * (1 + uniform()))
label var bankbefore "上一年机构数量（虚构）"


spmap age using "china_map.dta", id(id) 			///
	clnumber(10) fcolor(Greens2) ocolor(none ..)  	///
	title("银行分支机构退出情况", size(*0.8))       ///
    subtitle("2016.12-2018.11", size(*0.8))			///
	legstyle(2) legend(ring(0) position(7)) 		///
	plotregion(icolor(gs15)) 						///
	graphregion(icolor(gs15))						///
	scalebar(units(500) scale(1.2) 					///
			 xpos(100) ypos(-100) label(100公里))	///
	diagram(variable(banknum bankbefore)  			///
			legenda(on) type(pie) fcolor(Set3)		///
			xcoord(x_coord) ycoord(y_coord))
