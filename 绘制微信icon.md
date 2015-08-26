#使用Core Graphics绘画一个山寨微信icon#
最终效果：
![wechatDraw.gif](http://img.blog.csdn.net/20150825212023130)

- - -
绘画这个纯属周末雨天无聊，这里使用的都是Core Graphics上很基本的几个方法，对新手（我也是新手）来说还是有帮助的。下面说下这个绘制过程。
0. 设置背景色
1. 绘制绿色椭圆
2. 绘制绿色三角形
3. 绘制眼睛
4. 绘制白色椭圆
5. 绘制白色三角形
6. 绘制眼睛
7. 就这么简单
_ _ _
那么，省去创建project的步骤之后我们要做的就是自定义个UIView子类，我们就将它命名为`WechatView`，然后在storyboard上拖动一个`UIView`到视图控制器上。
![1.png](http://img.blog.csdn.net/20150825212153844)

接着，为了在绘制过程中能不需要每次都编译，我们可以使用iOS7之后的一个新特性 `IB_DESIGNABLE` 来时时看到我们的绘画过程。说到 `IB_DESIGNABLE` 就自然的会联想到 `IBInspectable`，先浅陋的介绍一下这两个的作用。首先是 `IB_DESIGNABLE`，如刚才所说，它可以让我们时时的看到我们的绘制过程，大大的省去了我们编译的时间，是iOS7上一个超赞的新特性。然后是 `IBInspectable`，它是添加在属性上的，在属性上添加上它我们就可以在Xcode的右边的*Show the Attributes inspector*上看到，并可以自定义这些值（当然，并不是所有的类习惯都支持的，具体有哪些，需要的时候试试便知哈）。
回到正题，现在我们只需要将 `IB_DESIGNABLE` 添加到`WechatView` 的头文件上即可（当然，你想添加到.m文件上编译器也不反对）。然后，在这里就添加一个用处不大的属性bkColor作为背景颜色，如下代码：
```Objective-C

IB_DESIGNABLE
@interface WechatView : UIView

@property(nonatomic, assign)IBInspectable UIColor *bkColor;

@end

```
这样，我们就可以在点击storyboard后，选择*Show the Identity inspector*上看到下图:
![2.png](http://img.blog.csdn.net/20150825212301999)

在*Show the Attributes inspector*上看到下图：
_ _ _

![3.png](http://img.blog.csdn.net/20150825212321338)

现在改变一下bkColor,将它改为灰色。

![4.png](http://img.blog.csdn.net/20150825212335473)

改后当然是看不到视图改变的，我们得真正的为 `backgoundColor` 这个属性赋值；或者使用Core Graphices来填充背景。方法一中如果想时时看到改变效果，我们可以添加如下代码：
```Objective-C
- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];

    self.backgroundColor = self.bkColor;
}
```
代码刚上，效果即可见哈，爽
![设置灰色背景](http://img.blog.csdn.net/20150825212354662)

`prepareForInterfaceBuilder` 这个方法是iOS8之后才有的，它就是提供给我们试试查看效果的，但是它只是在当你的view准备被绘制在*Interface Builder*时被执行，换句话说就是程序运行时它是不被调用的。==command+r==运行下程序我们就可以发现，这是的view背景并不是刚才所看到的灰色。说明`prepareForInterfaceBuilder`确实没有被调用。（我们可以通过这个方法，省去编译时间来看我们的绘制效果，然后再将代码移到我们所要的位置）。这个方法就说到这。

###填充背景###
还有方法二，也是接下来我们要用到的方法:使用Core Graphices来填充背景。将前面的代码注释掉，然后添加如下代码：
```Objective-C
- (void)drawRect:(CGRect)rect {
	/*0. 填充背景*/
    //将当前context的颜色填充为bkColor
    [self.bkColor setFill];
    //填充颜色到当前的context上，大小为rect
    CGContextFillRect(context, rect);
}
```
同样，可以看到`WechatView`的背景变成了灰色。这样就算开始了第0步绘画。

###绘制绿色椭圆###
第1步是开始绘制绿色椭圆，在以上的代码基础上继续添加如下代码:
```Objective-C
	//绘制的最小宽度
    CGFloat minWidth = MAX(160, rect.size.width);

    //定义绿色椭圆位置和大小
    CGFloat greenX = 10;
    CGFloat greenY = 10;
    CGFloat greenCircleWidth = minWidth/1.5;
    CGFloat greenCircleHeight = 21.0/24 * greenCircleWidth;
    CGFloat gcW = greenCircleWidth;
    CGFloat gcH = greenCircleHeight;

    //1. 绘制绿色椭圆
    UIColor *greenColor = RGB(125, 225, 73, 1);
	//将当前context的颜色填充为greenColor
    [greenColor setFill];
	//绘制并填充椭圆
    CGContextFillEllipseInRect(context, CGRectMake(greenX, greenY, greenCircleWidth, greenCircleHeight));
```
完成了第1步，效果见图：
![绘制绿色椭圆.png](http://img.blog.csdn.net/20150825220716185)

###绘制绿色三角形###
第2步：绘制绿色三角形。通过观察微信的icon，计算，微调，我们可以添加以下的代码来绘制这个三角形：
```Objective-C
	//2. 画三角形
    //椭圆左边焦点
    CGFloat greenCircleFocusLeft = gcW/2-sqrt(pow(gcW/2, 2)-pow(gcH/2, 2));
    //椭圆右边焦点
    CGFloat greenCircleFocusRight = gcW/2+sqrt(pow(gcW/2, 2)-pow(gcH/2, 2));
    CGFloat gcFL = greenCircleFocusLeft;
    CGFloat gcFR = greenCircleFocusRight;

    //眼睛大小
    CGFloat eyesWidth1 = gcW/7.5;

    //2. 画三角形
    CGPoint points[] = {
        CGPointMake(gcFL-eyesWidth1, greenY + gcH + (gcFL-eyesWidth1)/12-10),
        CGPointMake(greenX+gcW/2+40, 1.2*(greenX+gcW/2) + greenY),
        CGPointMake(gcFL+10, 1.8*gcFL + greenY)};
    CGContextAddLines(context, points, 3);
    CGContextClosePath(context);

    //CGContextStrokePath(context);
    CGContextFillPath(context);
```
三角形的三个点的计算花了我不少时间，但是这不是重点，重点是其实很简单的问题我却傻X的花了很长时间哈，而且最终还只是凑合的，不是最优解。取消`CGContextStrokePath(context);`这句的注释，我们可以看到下图：
![绘制三角形](http://img.blog.csdn.net/20150825220746948)

注释掉后即可看到：

![去掉三角形边框](http://img.blog.csdn.net/20150825220812478)

###绘制眼睛###
第3步：绘制眼睛。眼睛的位置取的是椭圆焦点的位置，而且绘制后看起来还挺对的。眼睛无非是两个黑色的圆形。如下：
```Objective-C
//3. 画眼睛（圆）
    [RGB(45, 49, 32, 1) setFill];
    CGContextFillEllipseInRect(context, CGRectMake(greenX + gcFL, greenY+gcH/4, eyesWidth1, eyesWidth1));
    CGContextFillEllipseInRect(context, CGRectMake(greenX + gcFR-eyesWidth1, greenY+gcH/4, eyesWidth1, eyesWidth1));
```
然后就是这样了：

![绘制眼睛](http://img.blog.csdn.net/20150825220847437)

###绘制白色icon###
第4，5，6步跟1，2，3步基本是一样的，只是位置不同而已。
```Objective-C
	//4. 画白色椭圆
    CGFloat wcX = greenX + gcW / 2;
    CGFloat wcY = greenY + gcH / 2;
    CGFloat wcW = gcW * 0.8;
    CGFloat wcH = gcH * 0.8;

    CGFloat whiteCircleFocusLeft = wcW/2-sqrt(pow(wcW/2, 2)-pow(wcH/2, 2));
    CGFloat whiteCircleFocusRight = wcW/2+sqrt(pow(wcW/2, 2)-pow(wcH/2, 2));
    CGFloat wcFL = whiteCircleFocusLeft;
    CGFloat wcFR = whiteCircleFocusRight;

    CGFloat eyesWidth2 = wcW/7.5;
    UIColor *whiteColor = RGB(251, 251, 251, 1);
    [whiteColor setFill];
    CGContextFillEllipseInRect(context, CGRectMake(wcX, wcY, wcW, wcH));

    //5. 画白色三角形
    CGPoint whiteTrianglePoints[] = {
        CGPointMake(wcFR+eyesWidth2/4+wcX, wcY + wcH + (wcFL-eyesWidth2/4)/4),
        CGPointMake(wcX+wcW/2, 0.9*(wcX+wcW/2)),
        CGPointMake(wcFR+eyesWidth2, 0.9*wcFR + wcY)};
    CGContextAddLines(context, whiteTrianglePoints, 3);
    CGContextClosePath(context);
    CGContextFillPath(context);

    //6. 画眼睛（圆）
    [RGB(60, 64, 49, 1) setFill];
    CGContextFillEllipseInRect(context, CGRectMake(wcX + wcFL, wcY + wcH/4, eyesWidth2, eyesWidth2));
    CGContextFillEllipseInRect(context, CGRectMake(wcX + wcFR - eyesWidth2, wcY + wcH/4, eyesWidth2, eyesWidth2));
```
OK,现在就长这样了，咋一看还是挺像的哈。
![绘制白色icon](http://img.blog.csdn.net/20150825220920770)

###添加阴影###
下面我们再添加一些细节上的东西。比如我们发现少了阴影，还有微信的icon上的三角形是圆角的。首先是阴影：在`CGFloat minWidth = MAX(160, rect.size.width);`这句之上加上下面的代码：
```Objective-C
//阴影
CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0.5), 6, [UIColor blackColor].CGColor);
```
![加阴影](http://img.blog.csdn.net/20150825220956167)

阴影是加上了，但是并不是我们想要的效果。怎样才能让它只是在边缘上加阴影呢？也很简单，继续在刚才添加的语句下添加：
```Objective-C
CGContextBeginTransparencyLayer(context, nil);
```
![修正阴影](http://img.blog.csdn.net/20150825221026316)

搞定，感觉还行哈，不过眼睛的阴影好像也没了。试试用同样的方法看能不能解决：在第3步画眼睛之前添加：
```Objective-C
	CGContextEndTransparencyLayer(context);
	//为绿色椭圆的眼睛添加阴影
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0.5), 2, [UIColor blackColor].CGColor);
```
然后在第3步画完眼睛之后添加：
```Objective-C
	CGContextBeginTransparencyLayer(context, nil);
```
再然后在第6步画眼睛之前添加上：
```Objective-C
	//为白色椭圆的眼睛添加阴影
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0.5), 2, [UIColor blackColor].CGColor);
```
这样说有点乱，注意到了：`CGContextBeginTransparencyLayer(context, nil)` 和 `CGContextEndTransparencyLayer(context)` 是成对出现的，从函数名称可以知道它们的作用分别是开始一个透明的layer和结束一个透明的layer。而夹在它们中间的绘图操作在指定的context上被合成到一个完全透明的背景(在context中作为一个分离的目标缓冲区)。这个操作会保持context原有的裁剪区域。调用了`Begin`之后除了1.全局的透明度被设置为1；2.阴影被屏蔽外，其他的都不变。这样解释后，上面的代码应该可以理解了。现在我们的icon看起来是这样的：
![给眼睛添加阴影](http://img.blog.csdn.net/20150825221135013)

###圆角三角形###
最后，解决下圆角三角形的问题：回到第2步，将`CGContextFillPath(context);`注释，并添加以下代码：
```Objective-C
	CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, greenColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
```
然后同理在第5步画白色三角形上注释`CGContextFillPath(context);`,并添加以下代码：
```Objective-C
	CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, whiteColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
```
好了，废话说完了，也算是完成了，最终效果：
![14.png](/Users/shaolie/Desktop/14.png)
实际上，微信的icon的颜色还是一个渐变的，在这里就不继续研究了，要实现渐变可以用`CGContextDrawLinearGradient(CGContextRef context, CGGradientRef gradient, CGPoint startPoint, CGPoint endPoint, CGGradientDrawingOptions options)`或`CGContextDrawRadialGradient(CGContextRef context, CGGradientRef gradient, CGPoint startCenter, CGFloat startRadius, CGPoint endCenter, CGFloat endRadius, CGGradientDrawingOptions options)`这两个函数。

###bug 修复###
command+r 编译+运行以下（现在才需要编译，这也太好了吧），然后发现成功的crash了。
![crash](http://img.blog.csdn.net/20150825221208736)

什么原因？好吧，我把属性定义成 `assign` 了（低级错误），改成`strong` ，问题解决。

###结束语###
以上就是我绘制的整个编码过程，绘制微信icon实际上就用了core graphics的几个基本功能，希望能对初学者有所帮助，说错的地方也希望能得到指点哈~~

源码地址：