# GameStub

[简体中文](/.github/README_zh-CN.md)

## What is this?
A macOS app written in Swift that enables the Game Mode (introduced in macOS Sonoma) for Java-based games such as Minecraft.

## How to use?

### For launcher developers
When creating the game process, change the executable path to `/path/to/GameStub.app/Contents/Resources/launcher` and prepend the absolute path of `java` to the arguments. This will activate the Game Mode.

### For players
If your launcher supports setting a "Wrapper Command", simply enter `/path/to/GameStub.app/Contents/Resources/launcher` into the field.

## What does it do?
1. `launcher` starts the main executable (which we call `runner`) via `NSWorkspace.openApplication`.
2. After `runner` is registered as a Game App, it replaces the current process with the `java` process using `execv`, allowing the game to inherit the Game App identity.

> [!WARNING]
> When Game Mode is active, macOS may reduce the performance of the launcher process. If `runner` is a child or descendant process of the launcher, its performance will also be degraded.<br>
> `launcher` uses `NSWorkspace.openApplication` to entrust `runner` to `launchd` to avoid game performance degradation. However, this approach prevents log and return value transmission.<br>
> We may add a Java Agent in future versions to transmit `stdout`, `stderr`, and the exit code to `launcher` via a socket, which will then forward them to the launcher.<br>

## How it works?
I don't know, it's probably... magic ✨