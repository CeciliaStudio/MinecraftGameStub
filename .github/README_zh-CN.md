# GameStub

## 这是什么？
一个使用 Swift 编写的 macOS App，用于为 Minecraft 等 Java 游戏开启 macOS Sonoma 添加的游戏模式。

## 如何使用？

### 对于启动器开发者
在创建游戏进程时，将进程的可执行文件更改为 `/path/to/GameStub.app/Contents/Resources/launcher`，并在参数前添加 `java` 的绝对路径即可生效。

### 对于普通玩家
如果您的启动器支持设置“Wrapper Command“，将 `/path/to/GameStub.app/Contents/Resources/launcher` 填入其中即可。

## 它做了什么？
1. `launcher` 通过 `NSWorkspace.openApplication` 启动主可执行文件（我们把它称为 `runner`）。
2. `runner` 在被注册为 Game App 后，通过 `execv` 将当前进程替换为 `java` 进程，使游戏继承 Game App 身份。

> [!WARNING]
> 当游戏模式激活时，macOS 会降低启动器进程的性能。如果 `runner` 是启动器的子进程，其性能也会被降低。<br>
> `launcher` 使用 `NSWorkspace.openApplication` 将 `runner` 托付给了 `launchd` 来解决游戏性能下降问题，但这种方式无法传输日志与返回值。<br>
> 我们可能会在未来的版本中添加一个 Java Agent，通过 socket 向 `launcher` 传输 `stdout`、`stderr` 和退出代码，并由 `launcher` 转发给启动器。<br>

## How it works?
我不知道，这大概就是……魔法吧 ✨