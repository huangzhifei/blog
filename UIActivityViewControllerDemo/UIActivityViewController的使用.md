#UIActivityViewController的使用#

`UIActivityViewController`是iOS上为App实现多种服务的一个标准视图控制器，系统默认提供了很多的标准服务，如拷贝链接，添加到Safari阅读列表，还有就是多平台的分享，包括微博，Facebook，email等。其实看起来就是一个actionSheet。

我们的任务是负责配置、显示和关闭这个视图控制器，配置也就是为这个视图控制器提供数据源。当然，我们也可以根据需要自定义自己服务（通过继承UIActivity）。在iPad上，我们以popover的形式显示这个视图控制器；而在 iPhone 和 iPod touch上, 我们需要以模态的形式显示。

先写一个最基本的代码：
```swift
	let image = UIImage(named: "iOS9")
	let str = "hello iOS9"
	let url = NSURL(string: "http://helloseed.io")
	let items:[AnyObject] = [image!, str, url!];
	
	self.presentViewController(vc, animated: true, completion: nil)
```

![标准显示](http://img.blog.csdn.net/20151004142535364)
可以看到，几句代码就可以显示出我们需要的controller了。Activity分为两类，图中可以看到它被分割线分为上下两部分，上面部分为Share（Objective-C为UIActivityCategoryShare)类型,下面部分为Action(Objective-C为UIActivityCategoryAction)类型。

下面我们添加如下代码：
```swift
	vc.completionWithItemsHandler = {(activityType:String?, completed:Bool, returnedItems:[AnyObject]?, activityError:NSError?) -> Void in
		if completed {
	        self.alert("成功")
        }
		vc.completionWithItemsHandler = nil
	}
```
然后点击其中的一个item，这时会弹出**成功**的alert。没错，这个block属性就是用来处理点击后的回调。
![结果回调](http://img.blog.csdn.net/20151004142603038)

几个参数说明：`activityType`为被点击的服务类型；`completed`标识服务是否执行成功；`returnedItems`是一个包含`NSExtensionItem`对象的数组；`activityError`指出出错原因。更详细的参数说明可以参考[官方文档](http://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIActivityViewController_Class/index.html)

现在，我们再在调用`presentViewController`方法之前添加一行代码：
```swift
	vc.excludedActivityTypes = [UIActivityTypeMail, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact];
```
再次运行，可以发现少了**Mail**、**Assign to Contact**、**Add to Reading List**这三个item。是的，`excludedActivityTypes`这个数组就是用来指定不需要那些服务的。我们可以将不需要的服务写进数组内，具体还有哪些服务，见文档。（注：现在所运行的环境都是在iOS8上的，iOS9后还添加了Notes（备忘录），和Reminders（提醒事项）这两个服务）
![取消显示不必要是item](http://img.blog.csdn.net/20151004142623970)
标准的基本上就这些，然并卵。。。
基本上，仅使用系统默认提供的服务是不够的，每个App有自己的需求，所以自定义服务是必然的。前面说到，通过继承`UIActivity`来实现自定义，下面来自定义几个常用的服务：微信Timeline，微信Session、新浪微博、拷贝链接。(这里就以微博和拷贝链接为例，其他都大同小异的)
1. 先创建一个类名为：`CustomActivity`，继承于`UIActivity`，以后其他自定义的Activity类直接继承它。代码如下：

```swift
import UIKit

class CustomActivity: UIActivity {
    var title:String?
    var image:UIImage?
    var url:NSURL?
    
    override class func activityCategory() -> UIActivityCategory {
        return .Share
    }
    
    override func activityType() -> String? {
        return NSStringFromClass(self.classForCoder)
    }
    
    /**
    返回是否可以执行
    
    - parameter activityItems: 从调用处传进来的items，可以通过这个items里面存放的类型数据来判断是否可以执行
    
    - returns: 返回true，则这个activity就会在controller上出现；否则，则不会出现
    */
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        //只要items有数据，就返回true。
        if activityItems.count > 0 {
            return true
        }
        return false
    }
    
    /**
    准备数据
    
    - parameter activityItems: 数据对象数组
    */
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for activityItem in activityItems {
            if let title = activityItem as? String {
                self.title = title
            } else if let image = activityItem as? UIImage {
                self.image = image
            } else if let url = activityItem as? NSURL {
                self.url = url
            }
        }
    }
    
    /**
    执行点击
    */
//    override func performActivity() {
//		  super.performActivity()

//        print(self.title)
//        print(self.image)
//        print(self.url)
//    }
}
```
几个需要我们override的方法的作用已经在注释上说明，就不多说了。
接着，我们创建一个`WeiboActivity`，如下：
```swift
import UIKit

class WeiboActivity: CustomActivity {
    override func activityTitle() -> String? {
        return "新浪微博"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "weibo")
    }
    
    override func performActivity() {
		super.performActivity()
		
        //将需要分享的数据通过微博SDK进行分析
        
    }
}
```
然后创建一个`CopyLinkActivity`类，如下：
```swift
import UIKit

class CopyLinkActivity: CustomActivity {
    override class func activityCategory() -> UIActivityCategory {
        return .Action
    }
    
    override func activityTitle() -> String? {
        return "拷贝链接"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "share_link")
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
	//因为是拷贝链接，所有如果不存在NSURL对象，则返回false
        for item in activityItems {
            if let _ = item as? NSURL {
                return true
            }
        }
        return false
    }
    
    override func performActivity() {
		super.performActivity()
        //拷贝需要的链接
    }
}
```

自定义工作告一段落，现在回到ViewController，将代码改成如下：
```swift
	let image = UIImage(named: "seed")
	let str = "hello iOS9"
	let url = NSURL(string: "http://helloseed.io")
	let items:[AnyObject] = [image!, str, url!];

	let weibo = WeiboActivity()		//实例化WeiboActivity
	let copylink = CopyLinkActivity()	//实例化CopyLinkActivity

	let vc = UIActivityViewController(activityItems: items, applicationActivities: [weibo, copylink])
	vc.excludedActivityTypes = [UIActivityTypeMail, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact];
	self.presentViewController(vc, animated: true, completion: nil)

	vc.completionWithItemsHandler = {(activityType:String?, completed:Bool, returnedItems:[AnyObject]?, activityError:NSError?) -> Void in
		if completed {
			self.alert("成功")
		}
		vc.completionWithItemsHandler = nil
	}
```
执行程序：
![自定义Activity](http://img.blog.csdn.net/20151004142700341)

顺利完成。不过我们发现，点击自定义的activity后，不会调用`completionWithItemsHandler`方法，即没有弹出**成功**。我的解决方法是，同样自定义一个closure（Objective-C中的block）来执行回调。于是，在`CustomActivity`中添加：
```swift
    var finishedBlock:(()-> Void)?
```
并将上面注释掉的方法`performActivity`解注释。如下：
```swift
	/**
    执行点击
    */
    override func performActivity() {
        super.performActivity()
        
        if let block = self.finishedBlock {
            block()
        }
        
        self.activityDidFinish(true)
    }
```
这样，在调用处想执行什么代码直接添加到`finishedBlock`即可。
再啰嗦一下，其实我们可以连`prepareWithActivityItems`都不需要override，`title`,`image`,`url`也都不需要定义，`CustomActivity`的子类也不需要override`performActivity`了。直接将要执行的代码放到`finishedBlock`上，类似这样：
```swift
	/**
    执行点击
    */
    override func performActivity() {
        super.performActivity()
        
        if let block = self.finishedBlock {
            block()
        }
        
        self.activityDidFinish(true)
    }
```

最后，为Activity提供的图片需要注意的一点：如果Activity的Category是**Share**，则不能是透明的，即关闭透明通道；如果Category是**Action**，则图片需要开启透明通道，因为系统需要将图片渲染成和标准的一样颜色（所以，不需要将图片颜色调成一致，系统会帮我们做），另外，圆角也是系统处理的。

参考文章：
https://github.com/nixzhu/dev-blog/blob/master/2014-04-22-ui-activity-viewcontroller.md