上一篇文章我们讨论了**离群值（outliers）**的识别问题，包括使用箱型图、双变量箱型图以及使用`bacon`命令进行的多元变量检测等方法。本篇我们将继续讨论离群值的处理问题。

### 提要

[TOC]

### 1. 了解你的数据

在处理离群值之前，首先应该做的是了解你所要处理的数据。我见过很多人在处理数据的时候，不管三七二十一，首先对模型用到的所有数据都进行了首尾1%的缩尾处理，这是极不负责的懒人行为。

从上一篇关于离群值的识别（链接：）可以看出，离群值的识别具有一定的主观性。因此只有你了解了所使用的数据及其生成过程，才能确保你能对于某一数值是否是离群值有一个基本判断。

举个例子，比如在处理银行的不良贷款率数据时，我们**首先**应该知道银行的不良贷款率应该大于0，不存在某一家银行，它的不良贷款率可以小于等于0的。**其次**，银行不良贷款率一定是小于100%，同样不存在一家银行的贷款全部是不良贷款的情况。**再次**，如果我们对中国银行业的不良贷款率有一点了解的话，那么我们知道，大多数银行的不良贷款率都在1%~5%之间，这是因为不良贷款率的监管指标要求要小于5%。基于上述信息，我们可以将不良贷款率数据超过8%的数据（这仍然是一个很主观的标准，你可以适当放宽）认为是离群值，然后对其进行处理。

此外，我们还应该了解数据的生成过程，有些数据中的0或者999可能是该数据用作缺失值的标识，我们不应该将这些数据当成离群值对其进行处理。比如银行存款数据永远不可能为0，如果某一家银行的存款数据为0，那么这个“0”必然代表的是缺失值，我们不应该好心地去给这样的值进行缩尾处理。

当然，我们上述举得例子都是常识，但是大多数犯的错误都是常识性错误。因此，在处理数据之前，**首先要了解的你的数据！**

### 2. 缩尾处理（winsorize）

**缩尾处理（winsorize）**是最常见的处理离群值的方法，下面我们将介绍一些常见的缩尾处理的方法。

#### 2.1 标准差倍数缩尾

如果一个数据是服从正态分布，那么数据分布在[μ - 3σ, μ + 3σ]之间的概率为99.7%（μ为均值，σ为标准差）。基于此我们可以将3σ之外的数据认为是离群值，然后将其替换为边界值。当然σ的倍数你也可以自己设定，或者4σ、5σ等等。

基于此，我们写了一个简单的小程序`winsor_sd`来进行
```cpp
cap program drop winsor_sd	
program def winsor_sd, sortpreserve
	version 15.0
	syntax varname [if] [in] [, N(real 3.0) Generate(str)]
	
	// 确认要生成的新变量是否存在
	cap confirm new variable `generate'  	// 捕获异常
	if _rc{ 								// 处理异常
		dis as err "generate() should give new variable name"
		exit _rc
	}
	
	// 标记将要winsor的样本
	marksample touse
	
	// 获取变量的均值与标准差
	qui sum `varlist' if `touse'
	local mean = r(mean)
	local sd = r(sd)
	local low = `mean' - `n' * `sd'
	local high = `mean' + `n' * `sd'
	
	// 进行缩尾
	clonevar `generate' = `varlist'
	qui replace `generate' = `low' if `touse' & `generate' < `low'
	qui replace `generate' = `high' if `touse' & `generate' > `high'
end
```

上述对于数据进行缩尾处理的程序，在关键地方都已经进行了注释说明，应该说是比较清晰的了。我们做一下简单说明：

第4行用来定义`winsor_sd`命令的用法，其用法格式为：
`winsor_sd 变量 [if] [in] [, n(倍数) generate(新变量名)]`；
第6~11行用来确认用户输入的新变量名是否存在；
第14行用来标记需要处理的样本，这一命令会将满足`if`、`in`限定条件以及非缺失值标记为1，方便后续处理；
第16~21行用来获取边界值；
第23~26行用来进行缩尾处理。

我们从Stata中导入88年妇女工资的数据`nlsw88.dta`，然后对工资`wage`进行缩尾处理。这里我们没有指定参数`n()`的值，其默认为3。

```cpp
sysuse nlsw88.dta, clear
winsor_sd wage, g(wage_wsd)
```

关于`winsor_sd`命令处理后的结果`wage_wsd`，我们在介绍完所有命令后将统一进行对比呈现。

#### 2.2 绝对界限缩尾

即将位于某一绝对范围外的值替换为边界值。我们编写了`winsor_range`命令，代码如下：

```cpp
cap program drop winsor_range	
program def winsor_range, sortpreserve
	version 15.0
	syntax varname [if] [in] , Range(numlist min=2 max=2) Generate(str)
	
	// 判断给定的范围是否超出变量的最大最小值
	tokenize "`range'"
	local low = `1'
	local high = `2'
	qui sum `varlist'
	local min = r(min)
	local max = r(max)
	if (`low'>`high')|(`low'<`min')|(`high'>`max'){
		dis as err "range() error, please check it"
		exit
	}
	
	// 确认要生成的新变量是否存在
	cap confirm new variable `generate'  	// 捕获异常
	if _rc{ 								// 处理异常
		dis as err "generate() should give new variable name"
		exit _rc
	}
	
	// 标记将要winsor的样本
	marksample touse
	
	// 进行缩尾
	clonevar `generate' = `varlist'
	qui replace `generate' = `low' if `touse' & `generate' < `low'
	qui replace `generate' = `high' if `touse' & `generate' > `high'
end
```
其基本逻辑同上，在此不赘述。如果我们假设工资在[2, 30]之外的值为离群值，那么:

```cpp
winsor_range wage, range(2 30) g(wage_wrg)
```

与此类似的，我们还可以只对数据头尾的某几个值进行缩尾处理，这样可以用到一个第三方命令`winsor`完成上述操作。

例如，我们对工资数据首尾5个数据进行缩尾处理，生成变量`wage_wh5`。相应操作为：

```cpp
ssc install winsor
winsor wage, h(5) gen(wage_wh5)  // 使用winsor命令，对头尾5个值进行缩尾
```

#### 2.3 分位数界限缩尾

应该说，分位数界限缩尾是目前最常用的缩尾方法。其具体操作就是将位于某一分位数范围外的值替换为边界值。

关于分位数缩尾，上述`winsor`命令就可以做到，因此不用我们去写命令。比如我们对头尾1%进行缩尾，生成变量`wage_wq1`，相应代码为：

```cpp
winsor wage, p(0.01) gen(wage_wq1)
```

同样我们也可以使用另一个第三方命令`winsor2`完成上述操作：

```
winsor2 wage, cut(1 99) s(_wq1)  // 使用winsor2命令，结果同上
```

#### 2.4 中位数缩尾

中位数缩尾就是将位于[med - n * distance, med + n * distance]之外的值替换成边界值，其中`med`为我们数据的中位数，`distance`为所有数据减去`med`的绝对值的中位数。

据此，我们编写了`winsor_med`命令，如下：

```cpp
cap program drop winsor_med	
program def winsor_med, sortpreserve
	version 15.0
	syntax varname [if] [in] [, N(real 3.0) Generate(str)]
	
	// 确认要生成的新变量是否存在
	cap confirm new variable `generate'  	// 捕获异常
	if _rc{ 								// 处理异常
		dis as err "generate() should give new variable name"
		exit _rc
	}
	
	// 标记将要winsor的样本
	marksample touse
	
	// 获取变量的中位数
	_pctile `varlist'
	local med = r(r1)
	
	// 生成临时变量var1
	tempvar var1
	gen `var1' = abs(`varlist' - `med')
	
	// 获取distance
	_pctile `var1'
	local distance = r(r1)
	
	// 进行缩尾	
	local low = `med' - `n' * `distance'
	local high = `med' + `n' * `distance'
	
	clonevar `generate' = `varlist'
	qui replace `generate' = `low' if `touse' & `generate' < `low'
	qui replace `generate' = `high' if `touse' & `generate' > `high'
end
```

参数`n()`默认为3，对工资`wage`进行中位数缩尾，生成变量`wage_wmd`的代码为：

```cpp
winsor_med wage, g(wage_wmd)
```

我们将上述方法得到的缩尾后的结果以及原变量进行对比，如下：

![图1](img/1.png)

可以看出采用中位数缩尾的结果，与原变量相比变化较大，其最大值、标准差、均值都明显变小。

### 3. 截尾处理

截尾处理的思路较为简单，即将超出范围的值替换为缺失值（`.`）。这样做的好处，是处理后比较干净，但会损失一定样本，对于大样本数据较为适合。

其相应代码，我们就不在此赘述了，你只需将上述代码中的`replace`开头的两行带稍加变换即可：

```cpp
replace `generate' = . if `touse' & `generate' < `low'
replace `generate' = . if `touse' & `generate' > `high'
```

我们就不在此演示了。

虽然我们了解了很多处理离群值的方法，但在实际应用中应该选择哪一种方法，并没有一定的规则。总之，要了解你的数据，然后选择适用的方法。

