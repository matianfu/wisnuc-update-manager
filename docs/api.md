# APIs

## 读取状态 

```
GET /v1
```

### 返回 200

```javascript
{
  betaOn: false,            // true or false, use beta
  operation: 'appInstall' // appStart, appStop, appInstall
  appifi: {               // null or object
    state: 'Starting'     // 'Starting', 'Started', 'Stopping', 'Stopped',
    tagName: '0.9.14'
    isBeta: 'false'       // present appifi is prerelease or not
  },
  releases: [             // array
    {
      state:              // 'Idle', 'Failed', 'Ready', 'Downloading', 'Repacking', 'Verifying', 
                          // ('Downloaded' not used now)
      view: null          /** null or object
                              Failed {
                                startTime:        // timer start time
                                timeout:          // timer timeout duration
                                message:          // error message
                                code:             // error code
                              } 
                              Downloading {
                                length:           // number or null
                                bytesWritten:     // downloaded
                              }
                          **/
      remote:             // release from github api
      local:              // release extracted from local tarball
    }
  ],
  fetch: {
    state: 'Pending'      // or 'Working'
    view:                 // 
    last: null or object  /**
                          {
                            time: when last is updated,
                            error: null or { message, code },
                            data: last retrieved data
                          }
                          **/
  },
  node: null              // not used
  deb: null               // not used
}
```

### 返回 503

此时Bootstrap初始化失败，无法启动。返回数据包括`{ message, code}`，为错误详细信息。

## 设置是否启用beta版本

启用beta，则会自动下载最新的beta release，否则自动下载最新的stable release

beta数据被持久化，每次bootStrap启动时都会读取beta数据。默认为false。当beta数据更新时，同时会将持久化的数据更新。

beta不同值下的表现：
1. false：不使用beta release，自动下载最新的stable release。
2. true：自动下载最新的release，可能是beta，也可能是stable。

beta的两种变化情况：
1. false -> true：目前运行的一定是stable版本，不需要stop，重新schedule。
2. true -> false：目前运行的可能是beta版本，如果是，则先stop，再重新schedule。

```
PATCH   /v1
```

**body**
```json
  {
    "betaOn": true
  }
```

**return**
  + 200，修改成功

## 安装、启动和停止应用服务

以下三个方法为互斥方法：
1. 任何一个在服务时，其他不可用。
2. 启动或停止服务的同类并发方法不会返回错误。

### 安装应用服务

提供`tagName`，来自`releases`资源列表。

```
PUT   /v1/app
```

**body**
```json
{
  "tagName": "0.9.14"
}
```

**return**
+ 200
+ 400, ENOTFOUND, 如果没有找到给定tag name的release
+ 400, ENOTREADY, 如果给定tag name的release未处于Ready状态
+ 403, ERACE，操作冲突
+ 500, 内部错误

### 启动或停止应用服务

```
PATCH /v1/app
```

**body**
```json
{
  "state": "Started"
}
```

`state`可以是`Started`或`Stopped`。

**return**
  + 200
  + 400，state错误
  + 403，ERACE，操作冲突
  + 404，ENOTFOUND，app未安装
  + 500，内部错误

## 启动或停止下载一个Release

启动指启动下载，包括Release的tarball下载，及其依赖性包的下载和安装。

```
PATCH /v1/releases/:tagname
```

**body**
```json
{
  "state": "Ready"
}
```

`state`可以是`Ready`或`Idle`。

**return**
  + 200
  + 400，state错误，state只能是Ready 或 Idle
  + 404，ENOTFOUND，给定tagName的release未找到
  + 500，内部错误


## 检查更新

```
PATCH /v1/fetch
```

**body**
```
{
  "state": "Pending"
}
```

`state`可以是`Pending`（意味着停止）或`Working`（意味着启动）。

**return**
  + 200
